import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kroner_app/styles.dart';
import 'package:kroner_app/Utils/controller.dart';
import 'package:kroner_app/Utils/timerManager.dart';

class FinishButton extends StatelessWidget {
  final TimeController timeController = Get.find();
  final TimerManager timerManager = Get.find();
  final States state = Get.find();

  void onPressed() {
    state.running2Finished();
    //timerManager.pauseTime();

  } 

  
  @override
  Widget build(BuildContext context) {
    return
      Obx(() =>
        ElevatedButton(
            key: const Key('finishButton'),
            onPressed: onPressed,
            style: myFinishButton(context, state.state.value != "RUNNING"),
            child: Center(
              child: IconTheme(
                data: iconTheme(context), // Asegúrate de que `iconTheme` es accesible
                child: Icon(Icons.sports_score),
                
              ),
              
            ),
          )
      );
  }

 
}