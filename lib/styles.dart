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
    fixedSize: Size(minDimension*0.11, minDimension*0.11),
  );
}

ButtonStyle myButtonDisabled(BuildContext context, bool isTrue) {
  // Obtiene el estilo por defecto de styles.dart
  ButtonStyle defaultStyle = myButtonStyle(context);
  if (isTrue) {
    // Modifica el estilo por defecto para cambiar el color de fondo a gris
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
    );
  } else {
    return defaultStyle;
  }
} 

ButtonStyle myFinishButton(BuildContext context, bool isTrue) {
  // Obtiene el estilo por defecto de styles.dart
  ButtonStyle defaultStyle = myButtonStyle(context);
  if (isTrue) {
    // Modifica el estilo por defecto para cambiar el color de fondo a gris
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
    );
  } else {
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.green),
    );
  }
} 

ButtonStyle myStartButton(BuildContext context, bool isTrue) {
  // Obtiene el estilo por defecto de styles.dart
  ButtonStyle defaultStyle = myButtonStyle(context);
  if (isTrue) {
    // Modifica el estilo por defecto para cambiar el color de fondo a gris
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
    );
  } else {
    return defaultStyle;
  }
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

ButtonStyle myReverseButtonStyle(BuildContext context, bool isTrue) {
  ButtonStyle defaultStyle = myButtonStyle(context);
  if (isTrue) {
    // Modifica el estilo por defecto para cambiar el color de fondo a gris
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
    );
  } else {
    return defaultStyle;
  }
}


ButtonStyle mySmallButtons (BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return ElevatedButton.styleFrom(
    shape: CircleBorder(),
    padding: EdgeInsets.all(6),
    //fixedSize: Size(minDimension*0.11, minDimension*0.11),
    //backgroundColor: Colors.green, 
  );
}

ButtonStyle mySaveButtonStyle(BuildContext context, bool isTrue) {
  ButtonStyle defaultStyle = mySmallButtons(context);
  if (isTrue) {
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.green),
    );
  } else {
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
    );
  }
} 

ButtonStyle myDeleteButtonStyle(BuildContext context, bool isTrue) {
  ButtonStyle defaultStyle = mySmallButtons(context);
  if (isTrue) {
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.red),
    );
  } else {
    return defaultStyle.copyWith(
      backgroundColor: MaterialStateProperty.all(Colors.grey),
    );
  }
} 

///***   SIZED BOX   ***///
SizedBox mySizedBox(BuildContext context, {double? widthFactor}) {
  double minDimension = calculateMinDimension(context);
  return SizedBox(
    height: minDimension * 0.04,
    width: minDimension * 0.04,
  );
}

 
///***   TEXT   ***///
TextStyle textStyle(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return TextStyle(
    fontSize: minDimension*0.1,
    fontWeight: FontWeight.bold,
  );
}

TextStyle textStyleConfigLabel(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return TextStyle(
    fontSize: minDimension*0.02,
    fontWeight: FontWeight.bold,
  );
}

TextStyle textStyleConfigScreen(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return TextStyle(
    fontSize: minDimension*0.02,
    fontWeight: FontWeight.bold,
  );
}

///***   FORMS   ***///
TextStyle mySettingsForm(BuildContext context) {
  double minDimension = calculateMinDimension(context);
  return TextStyle(
      fontSize: minDimension*0.02,
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

///***   TEXT FIELDS   ***///
InputDecoration textFieldStyle(BuildContext context, String hintText) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(8),
    hintText: hintText, // Este valor puede ser dinámico según tus necesidades
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.amber, width: 4),
      borderRadius: BorderRadius.circular(12),
    ),
    hintStyle: mySettingsForm(context),
  );
}
