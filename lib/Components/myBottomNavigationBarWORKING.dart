import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kroner_app/Controllers/blecontroller.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
} 

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    final bleController = Provider.of<BleController>(context, listen: true);

    return ValueListenableBuilder<DeviceConnectionState>(
      valueListenable: bleController.connectionState,
      builder: (context, value, child) {
        String connectionText;
        Color backgroundColor;

        switch (value) {
          case DeviceConnectionState.connecting:
            connectionText = 'Conectando...';
            backgroundColor = Colors.yellow;
            break;
          case DeviceConnectionState.connected:
            connectionText = 'Conectado';
            backgroundColor = Colors.green;
            break;
          case DeviceConnectionState.disconnecting:
            connectionText = 'Desconectando...';
            backgroundColor = Colors.orange;
            break;
          case DeviceConnectionState.disconnected:
            connectionText = 'Desconectado';
            backgroundColor = Colors.red;
            break;
          default:
            connectionText = 'Estado desconocido';
            backgroundColor = Colors.grey;
        }

        // Asume que tienes una variable que representa el porcentaje de la batería
        int batteryPercentage = 50; // Reemplaza esto con el valor real

        return BottomAppBar(
          color: backgroundColor, // Usa el color correspondiente al estado de la conexión
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  connectionText, // Muestra el texto correspondiente al estado de la conexión
                  style: TextStyle(
                    color: Colors.white, // Cambia esto al color que prefieras para el texto
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                Positioned(
                  right: 0,
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: 0, // Gira el icono 90 grados hacia la izquierda
                        child: Icon(
                          Icons.battery_std, // Icono de la batería
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$batteryPercentage%', // Muestra el porcentaje de la batería
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}