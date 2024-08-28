
import 'package:flutter/material.dart';

//Import Screens
import '../../Screens/ConfigMenu/ConfigMenu.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 1.0, // ajusta esto para cambiar la posición
      right: 1,//right: 10.0, // ajusta esto para cambiar la posición
      child: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfigMenu()),
              );
            },
            child: Icon(Icons.settings),
          );
        },
      ),
    );
  }
}