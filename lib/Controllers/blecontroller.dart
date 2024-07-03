import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:get/get.dart';

class BleController {
  //final FlutterReactiveBle _flutterReactiveBle;

  //BleController(this._flutterReactiveBle);

  ValueNotifier<DeviceConnectionState> _connectionState = ValueNotifier(DeviceConnectionState.disconnected);
  // Getter para connectionState
  ValueNotifier<DeviceConnectionState> get connectionState => _connectionState;

  @override
  void dispose() {
    _scanStream?.cancel();
    _connection.cancel();
  }

  late QualifiedCharacteristic rx;
  RxString status = 'not connected'.obs;
  RxString temperature = '0'.obs;

  // Bluetooth related variables
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice>? _scanStream;
  late StreamSubscription<ConnectionStateUpdate> _connection;

  // These are the UUIDs of your device
  final serviceId = '19B10000-E8F2-537E-4F6C-D104768A1214';
  final serviceUuid = Uuid.parse('19B10000-E8F2-537E-4F6C-D104768A1214');
  final characteristicUuid = Uuid.parse('b444ea9a-a1b8-11ee-8c90-0242ac120002');

  final uuidTest = "19B10000-E8F2-537E-4F6C-D104768A1214";
  final Uuid characteristicUuidOLD =
      Uuid.parse("19B10001-E8F2-537E-4F6C-D104768A1214");


 void connect(Uuid deviceIdd) async {
  bool isConnected = false;
    status.value = 'connecting...';
    // get rx
    rx = QualifiedCharacteristic(
      serviceId: Uuid.parse('19b10000-e8f2-537e-4f6c-d104768a1214'),            
      characteristicId: Uuid.parse('b444ea9a-a1b8-11ee-8c90-0242ac120002'), 
      deviceId: '84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59'
    );

    _connection = flutterReactiveBle.connectToDevice(
      id:'84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59',
      servicesWithCharacteristicsToDiscover: {serviceUuid: [serviceUuid]},
      connectionTimeout: const Duration(seconds: 2),
      ).listen(
        (state) async{
          //_connectionState.value = state.connectionState;
          print('ConnectionState for device $deviceIdd : ${state.connectionState}');
          if (state.connectionState == DeviceConnectionState.connected) {         
            status.value = 'connected!';
            print("Connected");
          
            print("Looking for services");
            try {
              final discoverServices = await flutterReactiveBle.discoverAllServices('84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59');
              List<Service> services = await flutterReactiveBle.getDiscoveredServices('84121AB4-E9D6-45B3-FF8A-9C24FB2BDD59');
            
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
                  print(response);
                } catch (e) {
                  print(e);
                } 
                //final response = await flutterReactiveBle.readCharacteristic(rx);
              });

              // Detener el escaneo una vez que el dispositivo esté conectado
              //_scanStream?.cancel();
              //_scanStream = null;
            } catch (e) {
              print('Error discovering services: $e');
            }
          } else {
            print(state.connectionState);
          }
        },
        onError: (Object e) =>
          print('Connecting to device $deviceIdd resulted in error $e'),
        );
        
      
  }

  void startScan() async {
    // Platform permissions handling stuff
      bool permGranted = false;
      PermissionStatus permission;
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
      connect(serviceUuid);
    }
}