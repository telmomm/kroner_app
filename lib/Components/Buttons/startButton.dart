import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kroner_app/styles.dart';
import 'package:kroner_app/Utils/controller.dart';
import 'package:kroner_app/Utils/timerManager.dart';

class StartButton extends StatelessWidget {
  final TimeController timeController = Get.find();
  final TimerManager timerManager = Get.find();
  final States state = Get.find();

  void onStartPressed() {
    state.countdown2Running();
    state.paused2Running();
    state.idle2Running();
    //timerManager.initTime();
    //timeController.startTimer();
    //print(timeController.isRunning.value);

  } 

  void onPausePressed() {
    state.running2Paused();
    //timerManager.stopTime();
    //timeController.isRunning.value = false;
    //timeController.pauseTimer();
    //print(timeController.isRunning.value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildButtonBasedOnState(context));
  }


Widget runButton(BuildContext context) {
  return ElevatedButton(
          key: const Key('F1P'),
          onPressed: onStartPressed,
          style: myStartButton(context, state.state.value == "IDLE" || state.state.value == "FINISHED"),
          child: Center(
            child: IconTheme(
              data: iconTheme(context), // Asegúrate de que `iconTheme` es accesible
              child: Icon(Icons.play_arrow),
            ),
          ),
        );
}

Widget pasuseButton(BuildContext context) {
  return ElevatedButton(
          key: const Key('F1P'),
          onPressed: onPausePressed,
          style: myStartButton(context, false),
          child: Center(
            child: IconTheme(
              data: iconTheme(context), // Asegúrate de que `iconTheme` es accesible
              child: Icon(Icons.pause),
            ),
          ),
        );
}

Widget _buildButtonBasedOnState(BuildContext context) {
  switch (state.state.value) {
    case "RUNNING":
      return pasuseButton(context);
    default :
      return runButton(context);
  }
}

}

