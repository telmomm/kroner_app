import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kroner_app/Utils/controller.dart';

import '../../../Utils/controller.dart';

class PointsLabel extends StatelessWidget {
  final RiderController riderController = Get.find();
  final String penaltyPoints;
  final TextStyle textStyle;

  PointsLabel({required this.penaltyPoints, required this.textStyle});
 

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Obx(() => 
        Text(
          riderController.penaltyPoints.value,
          //penaltyPoints,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}