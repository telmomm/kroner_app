import 'package:flutter/material.dart';
import 'package:kroner_app/styles.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

import 'GeneralMenu.dart';
import 'package:kroner_app/Components/Menus/myDropdownMenu.dart';
import 'package:kroner_app/Utils/controller.dart';
import 'package:kroner_app/styles.dart';


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/config.json');
}

Future<File> saveConfig(Map<String, dynamic> config) async {
  final file = await _localFile;
  return file.writeAsString(json.encode(config));
}

Future<Map<String, dynamic>> loadConfig() async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    return json.decode(contents);
  } catch (e) {
    return {};
  }
}

class ConfigMenu extends StatefulWidget {
  @override
  _ConfigMenuState createState() => _ConfigMenuState();
}

class _ConfigMenuState extends State<ConfigMenu> {
  final TimeController timeController = Get.find();
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    // Asumiendo que ya has cargado la configuración en `config`
    Map<String, dynamic> config = await loadConfig();

    // Inicializa el TextEditingController para 'countdownTime'
    controllers['countdownTime'] = TextEditingController(text: (timeController.initialTime.value / 1000).toString());
    controllers['maxTime'] = TextEditingController(text: (timeController.maxTime.value / 1000).toString());
    controllers['timePerAdditionalPoint'] = TextEditingController(text: (timeController.timePerAdditionalPoint.value / 1000).toString());

    // Añade un listener para actualizar `timeController` cuando el valor cambie
    controllers['countdownTime']!.addListener(() {
      timeController.initialTime.value = (int.tryParse(controllers['countdownTime']!.text) ?? timeController.initialTime.value) * 1000;
    });
    controllers['maxTime']!.addListener(() {
      timeController.maxTime.value = (int.tryParse(controllers['maxTime']!.text) ?? timeController.maxTime.value) * 1000;
    });
    controllers['timePerAdditionalPoint']!.addListener(() {
      timeController.timePerAdditionalPoint.value = (int.tryParse(controllers['timePerAdditionalPoint']!.text) ?? timeController.timePerAdditionalPoint.value) * 1000;
    });

  }

  @override
  void dispose() {
    // No olvides deshacerte de los controladores para evitar fugas de memoria
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _saveConfig() {
    Map<String, String> configToSave = {};
    controllers.forEach((key, controller) {
      configToSave[key] = controller.text;
    });
    saveConfig(configToSave);
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: ListView(
        children: <Widget>[
          /*ListTile(
            title: Text('Ajustes Generales'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GeneralMenu()),
              );
            },
          ),  
          */  
          mySizedBox(context),
            Text(
             'Baremo',
              style: textStyleConfigScreen(context),
            ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    myDropdownMenu(),
                    const SizedBox(width: 2),
                  ]
                ),
            mySizedBox(context),
            Text(
              'Tiempo Cuenta Atrás (segundos):',
              style: textStyleConfigScreen(context),
            ),
            Container(
              width: 200.0, // Ajusta este valor al ancho deseado
              child: TextField(
                controller: controllers['countdownTime'],
                keyboardType: TextInputType.number,
                decoration: textFieldStyle(context, (timeController.initialTime.value / 1000).toString()),  
              ),
            ),
            mySizedBox(context),
            Text(
              'Tiempo Máximo (segundos):',
              style: textStyleConfigScreen(context),
            ),
            Container(
              width: 200.0, // Ajusta este valor al ancho deseado
              child: TextField(
                controller: controllers['maxTime'],
                keyboardType: TextInputType.number,
                decoration: textFieldStyle(context, (timeController.maxTime.value / 1000).toString()),  
              ),
            ),
            mySizedBox(context),
            Text(
              'Puntos por tiempo (1 punto cada "X" segundos):',
              style: textStyleConfigScreen(context),
            ),
            Container(
              width: 200.0, // Ajusta este valor al ancho deseado
              child: TextField(
                controller: controllers['timePerAdditionalPoint'],
                keyboardType: TextInputType.number,
                decoration: textFieldStyle(context, (timeController.timePerAdditionalPoint.value / 1000).toString()),  
              ),
            ),
        ],
      ),
    );
  }
}
