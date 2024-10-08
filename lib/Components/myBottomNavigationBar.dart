
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

import '../../../Utils/controller.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);
 
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
   
} 


class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  // Some state management stuff
  final TimeController timeController = Get.find();
  final Connections connections = Get.find();

  // Bluetooth related variables
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice>? _scanStream;
  late StreamSubscription<ConnectionStateUpdate> _connection;
  // Define your stream here
  Stream<CharacteristicValue> characteristicValueStream = Stream<CharacteristicValue>.empty();
  late QualifiedCharacteristic rx;
  // These are the UUIDs of your device
  final serviceId = '19b10000-e8f2-537e-4f6c-d104768a1214';
  final serviceUuid = Uuid.parse('19B10000-E8F2-537E-4F6C-D104768A1214');
  final characteristicUuid = Uuid.parse('b444ea9a-a1b8-11ee-8c90-0242ac120002');

  @override
  void initState() {
    super.initState();
    //stopScan();
    startScan();
  }

  @override
  void dispose() {
    _scanStream?.cancel();
    _connection.cancel();
    super.dispose();
  }

// '84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59'
  void connect(deviceIdd) async {
    //_connection.cancel();
    //stopScan();
    //String deviceTestId = '84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59';
    //status.value = 'connecting...';
    // get rx
    rx = QualifiedCharacteristic(
      serviceId: Uuid.parse(serviceId), //Uuid.parse('19b10000-e8f2-537e-4f6c-d104768a1214'),            
      characteristicId: characteristicUuid,//Uuid.parse('b444ea9a-a1b8-11ee-8c90-0242ac120002'), 
      deviceId: deviceIdd.toString(),//'84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59'
    );

    _connection = flutterReactiveBle.connectToDevice(
      id: deviceIdd.toString(),//'84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59',
      servicesWithCharacteristicsToDiscover: {serviceUuid: [serviceUuid]},
      connectionTimeout: const Duration(seconds: 2),
      ).listen(
        (state) async{
          print('ConnectionState for device $deviceIdd : ${state.connectionState}');
          
          if (state.connectionState == DeviceConnectionState.connected) {    
            connections.ble.value = "connected";     
            //status.value = 'connected!';
            print("Connected");
          
            print("Looking for services");
            try {
              final discoverServices = await flutterReactiveBle.discoverAllServices(deviceIdd);///*'84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59');
              List<Service> services = await flutterReactiveBle.getDiscoveredServices(deviceIdd);//'84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59');
            
              for (Service service in services) {
                print('Service ID: ${service.id}');
                for (Characteristic characteristic in service.characteristics) {
                  print('Characteristic ID: ${characteristic.id}');
                }
              }

              print("Subscribing to rx");

              Timer.periodic(Duration(milliseconds: 100), (Timer t) async {
                try {
                  final response = await flutterReactiveBle.readCharacteristic(rx);
                  final F1 = await decodeData(response, 0);
                  final F2 = await decodeData(response, 4);
                  final F3 = await decodeData(response, 8);
                  //print('F1: $F1 - F2: $F2' - F3: $F3');

                  // Actualiza los valores de F1 y F2
                  timeController.timeF1.value = F1;
                  timeController.timeF2.value = F2;
                  timeController.timeF3.value = F3;

                } catch (e) {
                  print(e);
                } 
                
                //final response = await flutterReactiveBle.readCharacteristic(rx);
              });

              /*
                StreamSubscription subscription = await flutterReactiveBle.subscribeToCharacteristic(rx).listen(
                  (data) {
                    print(data);
                    var byteBuffer = Uint8List.fromList(data).buffer;
                    var byteData = ByteData.view(byteBuffer);
                    int number = byteData.getInt8(0);
                    print('Received number: $number');
                    //temperature.value = String.fromCharCodes(data);
                  },
                  onError: (dynamic error) {
                    print('Error subscribing to characteristic: $error');
                  },
                  onDone: () {
                    print('Finished subscribing to characteristic');
                  },
                );
                //print(dataText);
              
              // Cuando ya no necesites la suscripción, recuerda cancelarla
              // Puedes hacer esto en un método de limpieza o de destrucción, por ejemplo
              //await Future.delayed(Duration(seconds: 10));  // Esperar un poco para que los datos puedan llegar
              await subscription.cancel();
              */

              // Detener el escaneo una vez que el dispositivo esté conectado
              //_scanStream?.cancel();
              //_scanStream = null;
            } catch (e) {
              print('Error discovering services: $e');
            }
          } else {
            connections.ble.value = state.connectionState.toString();
            print('Estado: ');
            print(connections.ble.value);
          }
        },
        onError: (Object e) => {
          print('Connecting to device $deviceIdd resulted in error $e'),
          _connection.cancel()
          }
        );

        // Descubre los servicios después de la conexión
        /*final services = await flutterReactiveBle.discoverServices(deviceId);
        services.forEach((service) {
          print('Found service with id ${service.serviceId}');
          service.characteristics.forEach((characteristic) {
            print('Found characteristic with id ${characteristic.characteristicId}');
          });
        });
*/
/*
        // get rx
        rx = QualifiedCharacteristic(
          serviceId: Uuid.parse("19B10000-E8F2-537E-4F6C-D104768A1214"),            
          characteristicId: Uuid.parse("19B10001-E8F2-537E-4F6C-D104768A1214"), 
          deviceId: deviceId
        );          
        
        // subscribe to rx
        flutterReactiveBle.subscribeToCharacteristic(rx).listen((data) {
          temperature.value = String.fromCharCodes(data);
        });
*/
      
    
  }

  Future<int> decodeData(List<int> futureBytes, int position) async {
    List<int> bytes = await futureBytes;
    ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
    //print(futureBytes);
    // Asegúrate de que tienes al menos 4 bytes
    if (byteData.lengthInBytes >= 4) {
      // Lee los primeros 4 bytes como un entero de 32 bits sin signo en formato little-endian
      int value = byteData.getUint32(position, Endian.little);
      //print('F1: $value');
      return value;
    } else {
      print('Los datos recibidos son menos de 4 bytes');
      return 0;
    }

  }

  void stopScan() {
    _scanStream?.cancel();
  }

  void startScan() async {
    connections.ble.value = "connecting";
    //stopScan();
    bool permGranted = false;
    int maxAttempts = 5; // Max number of attempts
    int attempts = 0; // Attempts counter
    int timeAttempts = 2; //Time between attempts
    PermissionStatus permission;
    String deviceName = "";
    String deviceId = "";

    if (Platform.isAndroid) {
      print('Plataforma detectada: Android');
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
      print('Permiso concedido: $permGranted');
    } else if (Platform.isIOS) {
      print('Plataforma detectada: iOS');
      permGranted = true;
    } else {
      print('Plataforma detectada no compatible');
      permGranted = false;
    }
    
    // Repite el escaneo hasta que se encuentre el dispositivo o se alcance el número máximo de intentos
    do {
      if (permGranted) {
        _scanStream = flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
          //print(device.id);
          if (device.name == connections.bleDeviceName.value) {
            deviceName = device.name;
            deviceId = device.id;
            //print('Device found: ${device.name} - ${device.id}');
            //print(device.serviceUuids);
            //stopScan();
          }
          //stopScan();
        });

        // Espera un tiempo antes de verificar si se encontró el dispositivo
        await Future.delayed(Duration(seconds: timeAttempts)); // Ajusta este tiempo según sea necesario

        if (deviceName == connections.bleDeviceName.value) {
          print('Device found: ${deviceName}');
          stopScan();
          break; // Sal del bucle si se encuentra el dispositivo
        } else {
          print('Device not found, retrying...');
        }
      }

      print("Attempts: $attempts");
      attempts++;
      
      if (attempts >= maxAttempts) {
        print('Max attempts reached, stopping scan.');
        stopScan();
        break; // Sal del bucle si se alcanza el número máximo de intentos
      }
      stopScan();
      print("Device Name: $deviceName");
      print("Device ID: $deviceId");
    } while (deviceId == "" && deviceName != connections.bleDeviceName.value);

    attempts = 0; // Reset the attempts counter

    if (deviceId != "" && deviceName == connections.bleDeviceName.value) {
      print("Connecting...");
      connect(deviceId);
    } else {
      connections.ble.value = "disconnected";
      
    }
    print("TEETET");

    /*
    if(permGranted){
      _scanStream = flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        if(device.name == connections.bleDeviceName.value){
          connections.bleDeviceId.value = device.id;
          stopScan();
        }
      });
      print('Device found: ${connections.bleDeviceId.value}');
      
      //connect(connections.bleDeviceId.value);  
    } 
    */
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color color;
      String text;
      String connectionState = connections.ble.value.toString().split('.').last;
      switch (connectionState) {
        case 'connected':
          color = Colors.green;
          text = 'Conectado';
          break;
        case 'connecting':
          color = Colors.yellowAccent;
          text = 'Conectando...';
          break;
        case 'disconnected':
          color = Colors.red;
          text = 'Desconectado (Pulse para reconectar)';
          break;
        case 'disconnecting':
          color = Colors.red;
          text = 'Desconectado';
          break;
        default:
          color = Colors.grey;
          text = 'Pulse para reconectar';
      }
      

      return BottomAppBar(
        color: color,
        child: InkWell(
          onTap: () {
            //stopScan();
            if (connectionState == 'disconnected'){
              startScan();
            }
            
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

    });
  }

}