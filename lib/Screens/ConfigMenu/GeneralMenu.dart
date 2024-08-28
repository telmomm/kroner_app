import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../Utils/controller.dart';

class GeneralMenu extends StatefulWidget {
  const GeneralMenu({Key? key}) : super(key: key);

  @override
  _GeneralMenu createState() => _GeneralMenu();

}

class _GeneralMenu extends State<GeneralMenu> {

  //final GeneralMenuController generalMenuController = Get.find();
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();

  @override
  void initState(){
    super.initState();
    // Inicializa los TextEditingController con los valores almacenados


    void saveValue(String key, String value) async {
      var box = await Hive.openBox('myBox');
      box.put(key, value);
    }

    void loadValue(String key) async {
      var box = await Hive.openBox('myBox');
      String value = box.get(key, defaultValue: '');
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes Generales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nombre del usuario:'),
            TextField(
              controller: deviceNameController,
              // El resto de tu código...
            ),
            Text('Código de usuario:'),
            TextField(
              controller: serialNumberController,
              // El resto de tu código...
            ),
           
          ],
        ),
      ),
    );
  }
}