//////////////////// filename: blecontroller.dart
// ble no scan get nrf connect in google play store to get ble id
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'package:get/get.dart';

class BleController {
final frb = FlutterReactiveBle();
late StreamSubscription<ConnectionStateUpdate> connection;
late QualifiedCharacteristic rx;
RxString status = 'not connected'.obs;
RxString temperature = ' '.obs;

void connect() async {
  status.value = 'connecting...';
  connection = frb.connectToDevice(id: '0643E9DF-BABC-A9DF-1075-547193032657').listen((state){
    if (state.connectionState == DeviceConnectionState.connected){         
      status.value = 'connected!';
      print("Connected");
      
      // get rx
      rx = QualifiedCharacteristic(
        serviceId: Uuid.parse("1823"),            
        characteristicId: Uuid.parse("2A18"), 
        deviceId:'C4:35:D9:8F:09:F4' );          
        // subscribe to rx
        frb.subscribeToCharacteristic(rx).listen((data){
        temperature.value = String.fromCharCodes(data);
        });
    }
  });
}

}