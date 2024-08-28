import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kroner_app/styles.dart';
import 'package:kroner_app/Utils/timerManager.dart';
import 'package:kroner_app/Utils/controller.dart';

class ConfigLabel extends StatelessWidget {
  final TimerManager timerManager = Get.find();
  final TimeController timeController = Get.find();
  final RiderController riderController = Get.find();
  final States state = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      //alignment: Alignment.topCenter,
      children : [
        Row(
          children: [
            Obx(() => 
              Text(
                'Baremo: ' + (riderController.baremo.value),
                style: textStyleConfigLabel(context),
                textAlign: TextAlign.center,
              
              ),
            ) 
          ],
        ),
        Row(
          children: [
            Obx(() => 
              Text(
                'Tiempo Cuenta Atrás: ' + (timeController.initialTime.value / 1000).toString() + 's',
                style: textStyleConfigLabel(context),
                textAlign: TextAlign.center,
              
              ),
            ) 
          ],
        ),
        Row(
          children: [
            Obx(() => 
              Text(
                'Tiempo Máximo: ' + (timeController.maxTime.value / 1000).toString() + 's',
                style: textStyleConfigLabel(context),
                textAlign: TextAlign.center,
              
              ),
            ) 
          ],
        ),
        Row(
          children: [
            Obx(() => 
              Text(
                '1 punto por cada ' + (timeController.timePerAdditionalPoint.value / 1000).toString() + 's',
                style: textStyleConfigLabel(context),
                textAlign: TextAlign.center,
              
              ),
            ) 
          ],
        ),
        Row(
          children: [
            Obx(() => 
              Text(
                'Estado: ' + state.state.value,
                style: textStyleConfigLabel(context),
                textAlign: TextAlign.center,
              
              ),
            ) 
          ],
        ),
      ],   
    );  
  }
}