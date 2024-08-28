import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kroner_app/styles.dart';
import 'package:kroner_app/Utils/timerManager.dart';
import 'package:kroner_app/Utils/controller.dart';

class TimeLabel extends StatelessWidget {
  final TimerManager timerManager = Get.find();
  final States state = Get.find();

  String formatTime(int milliseconds) {
    final seconds = milliseconds / 1000;
    if(state.state.value == "PAUSED" || state.state.value == "FINISHED") {
      return "${seconds.toStringAsFixed(2)}"; 
    } else {
      return "${seconds.toStringAsFixed(1)}"; 
    }
  }

  /*
  String formatTimeOLD(int milliseconds) {
  if (_isCountdown) {
    int remaining = TimeController.initialTime- milliseconds;
   
    int hundredths = (remaining / 10).truncate();
    int seconds = (remaining / 1000).truncate();
    hundredths %= 100;
    //return "${hours.toInt()}:${minutes.toInt().toString().padLeft(2, '0')}:${seconds.toInt().toString().padLeft(2, '0')}";
    return '$seconds.${(hundredths/10).truncate()}';
  } else {
    int hundredths = (milliseconds / 10).truncate();
    int seconds = (hundredths / 100).truncate();
    hundredths %= 100;
    return TimerManager.isRunning ? '$seconds.${(hundredths/10).truncate()}' : '$seconds.${hundredths.toString().padLeft(2, '0')}';
  }
}
*/
  
  //TimeLabel(required this.textStyle});

  //final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Obx(() => 
        Text(
          formatTime(timerManager.currentTime),
          style: textStyle(context),
          textAlign: TextAlign.center,
         
        ),
      ) 
    );  
  }
}