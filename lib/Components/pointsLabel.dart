import 'package:flutter/material.dart';

class PointsLabel extends StatelessWidget {
  final String penaltyPoints;
  final TextStyle textStyle;

  PointsLabel({required this.penaltyPoints, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        penaltyPoints,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}