import 'package:flutter/material.dart';
import 'package:kroner_app/Components/Labels/configLabel.dart';
import 'package:kroner_app/styles.dart';
import 'package:get/get.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

import '../../../Utils/controller.dart';
import '../../Utils/timerManager.dart';

import 'package:kroner_app/Components/myBottomNavigationBar.dart';
import 'package:kroner_app/Components/Menus/myDropdownMenu.dart';
import 'package:kroner_app/Components/Buttons/startButton.dart';
import 'package:kroner_app/Components/buttons/finishButton.dart';

import 'package:kroner_app/Components/Labels/configLabel.dart';

class TimeButtons extends StatefulWidget {

  final ValueChanged<String> onPointsUpdated;
  TimeButtons({required this.onPointsUpdated, Key? key}) : super(key: key);

  @override
  _TimeButtons createState() => _TimeButtons();
}

class _TimeButtons extends State<TimeButtons> {
  final RiderController riderController = Get.find();
  final TimeController timeController = Get.find();
  final States state = Get.find();

  final TimerManager timerManager = TimerManager();
  

  bool _elimPressed = false;
 
   

  void onF2Pressed() {
    //timerManager.stopTime();
    //timeController.isRunning.value = false;
    //timeController.enableF2 = false.obs;
    state.running2Finished();
    //timerManager.pauseTime();
  }

 void onBellPressed() async {
    state.idle2Countdown();
    //AudioCache player = AudioCache();
    //await player.play('beep.mov');
  }

  void on4PointsPressed() {
    addPenaltyPoints("4");
  }

  void on1PointsPressed() {
    addPenaltyPoints("1");
  }

  void elimPressed() {
      //_elimPressed = true;
      addPenaltyPoints("ELIM");
    }

  void addPenaltyPoints(String points) {
    riderController.prevPenaltyPoints.add(riderController.penaltyPoints.value);
      
      if (points == "ELIM") {
        riderController.penaltyPoints.value = "ELIM";
      } else {
        int currentPoints = int.tryParse(riderController.penaltyPoints.value) ?? 0;
        int newPoints = int.tryParse(points) ?? 0;
        riderController.penaltyPoints.value = (currentPoints + newPoints).toString();
      }
      print("Puntos: " + riderController.penaltyPoints.value);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ElevatedButton( key: const Key('bell'),
                    onPressed: () {
                      onBellPressed();
                      riderController.penaltyPoints.value = "0";
                    },
                    child: Center(
                      child: IconTheme(
                        data: iconTheme(context),
                        child: Icon(Icons.notifications),
                      ),
                    ),
                    style: myButtonStyle(context)
                  ),
        
        mySizedBox(context),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                StartButton(),
                mySizedBox(context),
                Obx(() => Text('${timeController.timeF1.value}')),
              ],
            ),
            
            mySizedBox(context),
            Column(
              children: [
                FinishButton(),
                mySizedBox(context),
                Obx(() => Text('${timeController.timeF2.value}')),
              ],
            ),
          ],
        ),
        mySizedBox(context),
        mySizedBox(context),
        ConfigLabel(),
      ],
    );
  
    

  }
}