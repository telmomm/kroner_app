import 'package:flutter/material.dart';

class ResultsTable extends StatelessWidget {
  final List<Map<String, dynamic>> datos;

  ResultsTable({required this.datos});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Número',
              ),
            ),
            DataColumn(
              label: Text(
                'Nombre',
              ),
            ),
            DataColumn(
              label: Text(
                'Puntos',
              ),
            ),
            DataColumn(
              label: Text(
                'Tiempo',
              ),
            ),
          ],
          rows: datos.map<DataRow>((Map<String, dynamic> dato) {
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(dato['Numero'].toString()),
                ),
                DataCell(
                  Text(dato['Nombre'].toString()),
                ),
                DataCell(
                  Text(dato['Puntos'].toString()),
                ),
                DataCell(
                  Text(dato['Tiempo'].toString()),
                ),
                // Agrega más celdas según sea necesario
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}