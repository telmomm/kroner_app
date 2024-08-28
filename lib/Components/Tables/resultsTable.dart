import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:kroner_app/Utils/jsonController.dart';
import 'package:kroner_app/Utils/controller.dart';

class ResultsTable extends StatefulWidget {
  

  @override
  _ResultsTableState createState() => _ResultsTableState();
}

class _ResultsTableState extends State<ResultsTable> {
  List<Map<String, dynamic>> datos = [];
  final Results results = Get.find();

  @override
  void initState() {
    super.initState();
    loadData(); // Llama a loadData() en lugar de hacer el trabajo asincrónico directamente aquí.
  }

  // Define loadData como un método separado
  void loadData() async {
    var loadedDatos = await loadJSON(); // Carga los datos
    setState(() {
      results.datos = loadedDatos; // Actualiza los datos en el estado
    }); // Verifica que los datos se hayan cargado correctamente
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (results.newResult.value == true) {
        loadData(); // Si newResult es true, recarga los datos
        results.newResult.value = false; // Restablece newResult a false
      }
      // Construye tu widget aquí, este código se ejecutará cada vez que newResult cambie.
      return resultData(context); // Reemplaza esto con tu widget real
    });
  }

  Widget resultData(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:
          DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Número')),
              DataColumn(label: Text('Puntos')),
              DataColumn(label: Text('Tiempo')),
            ],
            rows: List<DataRow>.generate(
              results.datos.length, // Asegúrate de que esto refleje la cantidad actual de elementos en results.datos
              (index) => DataRow(
                cells: <DataCell>[
                  DataCell(Text('${results.datos[index]["Numero"]}')),
                  DataCell(Text('${results.datos[index]["Puntos"]}')),
                  DataCell(Text(results.datos[index]["Tiempo"])),
                ],
              ),
            ),
          )
      ),  
    );
  } 
}