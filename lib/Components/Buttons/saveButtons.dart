import 'package:flutter/material.dart';
import 'package:kroner_app/styles.dart';

class SaveButtonList extends StatefulWidget {
  SaveButtonList();

  @override
  _SaveButtonListState createState() => _SaveButtonListState();
}

class _SaveButtonListState extends State<SaveButtonList> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            key: const Key('save'),
            onPressed: () {},
            child: Center(
              child: IconTheme(
                data: iconTheme(context),
                child: Icon(Icons.save),
              ),
            ),
            style: myButtonStyle(context),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 50, // Ajusta esto según tus necesidades
          child: ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.add, size: 12),  // Cambia esto al icono y tamaño que desees
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),  // Cambia esto al color que desees
              shape: MaterialStateProperty.all(CircleBorder()),
              padding: MaterialStateProperty.all(EdgeInsets.all(6)),  // Cambia esto al padding que desees
            ),
          ),
        ),
      ],
    );
  }
}