import 'package:flutter/material.dart';

const List<String> list = <String>['A2', 'Dos Fases', 'Dos Fases(*)', 'Desempate'];

class myDropdownMenu extends StatefulWidget {
  const myDropdownMenu({Key? key}) : super(key: key);

  @override
  State<myDropdownMenu> createState() => _myDropdownMenuState();
}

class _myDropdownMenuState extends State<myDropdownMenu> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}