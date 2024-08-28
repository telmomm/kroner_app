import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kroner_app/styles.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:kroner_app/Utils/jsonController.dart';

import '../../../Utils/controller.dart';
import '../../Utils/timerManager.dart';

class ButtonList extends StatefulWidget {

  final ValueChanged<String> onPointsUpdated;
  ButtonList({required this.onPointsUpdated, Key? key}) : super(key: key);

  @override
  _ButtonListState createState() => _ButtonListState();
}

class _ButtonListState extends State<ButtonList> {
  final RiderController riderController = Get.find();
  final TimeController timeController = Get.find();
  final TimerManager timerManager = Get.find();
  final States state = Get.find();
  final Results results = Get.find();
 
  void on4PointsPressed() {
    addPenaltyPoints("4");
  }

  void on1PointsPressed() {
    addPenaltyPoints("1");
  }

  void on6SecPressed() {
    addPenaltyTime(6);
  }

Future<File> definePath() async {
  // Obtener el directorio de documentos de la aplicación
  final directory = await getApplicationDocumentsDirectory();
  
  // Definir la ruta del archivo dentro del directorio de documentos
  final path = p.join(directory.path, 'default.json');

  // Crear el archivo si no existe
  final file = File(path);
  if (!await file.exists()) {
    await file.create();
    // Opcional: Escribir contenido inicial en el archivo
    // await file.writeAsString('Contenido inicial');
  }

  return file;
}

Future<void> saveButtonJSON() async {
  // Suponiendo que time y points son tus datos a guardar
  var time = '10:00'; // Ejemplo de tiempo
  var points = 100; // Ejemplo de puntos

  // Leer el archivo JSON actual
  var file = await definePath();
  var jsonContent = await file.readAsString();
  Map<String, dynamic> jsonData;

  // Intentar decodificar el JSON, manejar el archivo vacío o contenido no válido
  try {
    jsonData = jsonDecode(jsonContent);
  } catch (e) {
    // Si hay un error de decodificación, inicializar jsonData con una estructura básica
    jsonData = {'results': []};
  }

  // Añadir el tiempo y los puntos al JSON
  jsonData['results'].add({
    'time': time,
    'points': points,
  });

  // Convertir de nuevo a cadena JSON y guardar
  var updatedJsonContent = jsonEncode(jsonData);
  await file.writeAsString(updatedJsonContent);

  print('Datos guardados correctamente.');
}

  void elimPressed() {
      //_elimPressed = true;
      riderController.pointsEnable.value = false;

      addPenaltyPoints("ELIM");
      print(riderController.pointsEnable.value.toString());
    }

  void addPenaltyTime(int time) {
    timeController.currentTime.value += time * 1000;
    timeController.lastTime.value += time * 1000;
    print(timeController.lastTime.value.toString());

  }

  void addPenaltyPoints(String points) {
    riderController.prevPenaltyPoints.add(riderController.penaltyPoints.value);
      
      if (points == "ELIM") {
        riderController.penaltyPoints.value = "ELIM";
      } else {
        int currentPoints = int.tryParse(riderController.penaltyPoints.value) ?? 0;
        int newPoints = int.tryParse(points) ?? 0;
        riderController.penaltyPoints.value = (currentPoints + newPoints).toString();
      }
      print("Puntos: " + riderController.penaltyPoints.value);
  }

  void saveButton(){
    state.finished2Idle();
    
    results.newResult.value = true;
    print(timerManager.currentTime / 1000);
    print(riderController.penaltyPoints.value);
    saveJSON('''{
              "Numero": "1",
              "Puntos": "${riderController.penaltyPoints.value}",
              "Tiempo": "${timerManager.currentTime / 1000}"
              }'''
            );
    resetTime();
    resetPoints();
  }
  
  void deleteButton(){
    state.finished2Idle();
    resetTime();
    resetPoints();
  }

  void resetTime(){
    timeController.currentTime.value = timeController.initialTime.value;
    timerManager.stopTime();
    timeController.isRunning = false.obs;
    timeController.isCountdown = false.obs;

  }

  void resetPoints(){
    riderController.penaltyPoints.value = 0.toString();
    riderController.penaltyPoints = "0".obs;
    riderController.pointsEnable.value = true;
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() =>
    Column(
      children: [
        ElevatedButton( key: const Key('4Points'),
          onPressed: !riderController.pointsEnable.value ? null : on4PointsPressed,
          child: Text('+4'),
          style: myButtonDisabled(context, !riderController.pointsEnable.value)
        ),
        mySizedBox(context),
        ElevatedButton( key: const Key('1Point'),
          onPressed: !riderController.pointsEnable.value ? null : on1PointsPressed,
          child: Text('+1'),
          style: myButtonDisabled(context, !riderController.pointsEnable.value)
        ),
        mySizedBox(context),
        ElevatedButton( key: const Key('+6sec'),
          onPressed: !riderController.pointsEnable.value ? null : on6SecPressed,
          child: Text('+6 seg'),
          style: myButtonDisabled(context, !riderController.pointsEnable.value)
        ),
        mySizedBox(context),
        ElevatedButton( key: const Key('elimButton'),
          onPressed: !riderController.pointsEnable.value ? null : elimPressed,
          child: Text('ELIM'),
          style: elimButtonStyle(context)
        ),
        mySizedBox(context),
          ElevatedButton(
            key: const Key('reverse'),
            onPressed: () {
              if (riderController.prevPenaltyPoints.length > 1) {
                riderController.penaltyPoints.value = riderController.prevPenaltyPoints.removeLast();
                //_elimPressed = false;
                riderController.pointsEnable.value = true;

              }
              print("Puntos: " + riderController.penaltyPoints.value);
            },
            child: Center(
              child: IconTheme(
                data: iconTheme(context),
                child: Icon(Icons.arrow_back),
              ),
            ),
            style: myReverseButtonStyle(context, riderController.prevPenaltyPoints.isEmpty),
          ),
        SizedBox(width: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() =>
              ElevatedButton(
                onPressed: () {
                  deleteButton();
                },
                child: Icon(Icons.delete),
                style: myDeleteButtonStyle(context, state.state.value == "FINISHED"),
              ),
            ),
            SizedBox(width: 20), // Ajusta este valor para cambiar el espacio entre los botones
            Obx(() =>
              ElevatedButton(
                onPressed: () {
                  saveButton();
                },
                child: Icon(Icons.save),
                style: mySaveButtonStyle(context, state.state.value == "FINISHED"),
              ), 
            ),
          ],
        ),
        
        
      ],
    ),
    );
  
    

  }
}