// button_styles.dart
import 'package:flutter/material.dart';
import 'dart:math';

///***  COMMON   ***///
double calculateMinDimension(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  return min(screenWidth, screenHeight);
}

///***   BUTTONS   ***///
ButtonStyle myButtonStyle(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return ElevatedButton.styleFrom(
    shape: CircleBorder(),
    padding: EdgeInsets.zero,
    fixedSize: Size(minDimension*0.12, minDimension*0.12),
  );
}

ButtonStyle elimButtonStyle(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return myButtonStyle(context).copyWith(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return Colors.grey;
        return Colors.red; // Use the component's default.
      },
    ),
  );  
}


///***   SIZED BOX   ***///
SizedBox mySizedBox(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return SizedBox(height: minDimension*0.05);
} 


///***   TEXT   ***///
TextStyle textStyle(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return TextStyle(
    fontSize: minDimension*0.1,
    fontWeight: FontWeight.bold,
  );
}

///***   ICONS   ***///
IconThemeData iconTheme(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return IconThemeData(
    size: minDimension*0.08,
    color: Colors.white
  );
}

