import 'dart:ffi';

import 'package:get/get.dart';

import 'package:kroner_app/Utils/controller.dart';
import 'package:kroner_app/Utils/timerManager.dart';

/*
class GeneralMenuController extends GetxController {
  RxString deviceName = ''.obs;
  RxString serialNumber = ''.obs;
  RxBool isFallDetectionEnabled = true.obs;
  RxBool isFallDetected = false.obs;

  void toggleFallDetection(bool value) {
    isFallDetectionEnabled.value = value;

    // Si isFallDetectionEnabled se desactiva, restablece isFallDetected a false
    if (!isFallDetectionEnabled.value) {
      isFallDetected.value = false;
    }
    print("isFallDetected VAriable: " + isFallDetected.value.toString());
  }
}
*/

final TimerManager timerManager = Get.find();

class RiderController extends GetxController {
  RxString penaltyPoints = '0'.obs;
  List<String> prevPenaltyPoints = ["0"];
  RxString baremo = "A1".obs;
  RxBool pointsEnable = true.obs;
}

class TimeController extends GetxController {
  RxBool isCountdown = false.obs;
  RxInt currentTime = 0.obs;
  RxInt initialTime = (4 * 1000).obs;
  RxInt maxTime = (5 * 1000).obs;
  RxInt timePerAdditionalPoint = (4 * 1000).obs;
  var isRunning = false.obs;
  RxBool enableF1 = true.obs;
  RxBool enableF2 = false.obs;
  RxBool enableF3 = false.obs;
  RxInt timeF1 = 0.obs;
  RxInt timeF2 = 0.obs;
  RxInt timeF3 = 0.obs;
  RxInt lastTime = 0.obs;

  void startTimer() {
    isRunning.value = true;
    // Lógica para iniciar el temporizador
  }

  void pauseTimer() {
    isRunning.value = false;
    // Lógica para pausar el temporizador
  }

}

class Connections extends GetxController {
  RxString ble = "disconnected".obs;
  RxString bleDeviceName = "Kroner-Hub".obs;
}

class Settings extends GetxController {
}

class Results extends GetxController {
  List<Map<String, dynamic>> datos = [];
  RxBool newResult = false.obs;
  //var datos = <Map<String, dynamic>>[].obs;
}
class States extends GetxController {
  RxString state = "IDLE".obs;//IDLE - COUNTDOWN - RUNNING - PAUSED - FINISHED

  void changeState(String newState) {
    state.value = newState;
    print("State: " + state.value);
  }
  void idle2Countdown() {
    if(state.value == "IDLE"){
      changeState("COUNTDOWN");
      timerManager.initCountdown();
    }
  }
  void idle2Running() {
    if(state.value == "IDLE"){
      changeState("RUNNING");
      timerManager.initTime();
    }
  }
  void countdown2Running() {
    if(state.value == "COUNTDOWN"){
      changeState("RUNNING");
      timerManager.initTime();
    }
  }
  void running2Paused() {
    if(state.value == "RUNNING"){
      changeState("PAUSED");
      timerManager.pauseTime();
    }
  }
  void paused2Running() {
    if(state.value == "PAUSED"){
      changeState("RUNNING");
      timerManager.initTime();
    }
  }
  void running2Finished() {
    if(state.value == "RUNNING"){
      changeState("FINISHED");
      timerManager.stopTime();
    }
  }
  void finished2Idle() {
    if(state.value == "FINISHED"){
      changeState("IDLE");
    }
  }
  
}