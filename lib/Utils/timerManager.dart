import 'dart:async';

import 'package:get/get.dart';

import '../../Utils/controller.dart';

class TimerManager {
  Stopwatch _stopwatch = Stopwatch();
  Timer? timer;

  final TimeController timeController = Get.find();
  final RiderController riderController = Get.find();
  final States state = Get.find();
  int timePenaltiesCounter = 0;

  TimerManager() {
    timer = Timer.periodic(Duration(milliseconds: 100), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (_stopwatch.isRunning) {
      timeController.currentTime.value = timeController.initialTime.value - _stopwatch.elapsedMilliseconds;
      if (timeController.currentTime.value <= 0) {
        _stopwatch.stop();
        timeController.currentTime.value = 0;
        // Aquí puedes agregar lógica adicional cuando el temporizador llegue a 0.
      }
    }
  }

  void start() => _stopwatch.start();
  void stop() => _stopwatch.stop();
  
  void reset() {
    _stopwatch.reset();
    //timeController.currentTime.value = timeController.initialTime.value;
    timeController.currentTime.value = 0;
  }

  void initCountdownOLD() {

    timeController.isCountdown = true.obs;
    _stopwatch.reset();
    _stopwatch.start();
    timeController.currentTime.value = timeController.initialTime.value;
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      
      if (timeController.currentTime.value <= 0) {
        _stopwatch.stop();
        timeController.currentTime.value = 0;
        timeController.isCountdown = false.obs;
        //initTime();
        state.idle2Countdown();

        // Aquí puedes agregar lógica adicional cuando el temporizador llegue a 0.
      }
    });
      
  }

void initCountdown(){
  // Cancela cualquier temporizador existente para evitar múltiples instancias
  timer?.cancel();

  // Reinicia el cronómetro para asegurar que comience desde 0
  _stopwatch.reset();
  _stopwatch.start(); // Inicia el cronómetro

  // Asegura que el temporizador no esté en modo cuenta regresiva
  timeController.isCountdown = true.obs;
  timeController.currentTime.value = timeController.initialTime.value; // Inicia el tiempo en 0

  // Activa el botón o funcionalidad necesaria, si es necesario
  // timeController.enableF1 = false.obs;
  //timeController.enableF2 = true.obs;

  // Crea un nuevo temporizador que se actualiza cada 100 milisegundos
  timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
    if (timeController.currentTime.value <= 0) {
        _stopwatch.stop();
        timeController.currentTime.value = 0;
        timeController.isCountdown = false.obs;
        //initTime();
        state.countdown2Running();
        // Aquí puedes agregar lógica adicional cuando el temporizador llegue a 0.
      }else{
        timeController.currentTime.value -= 100;
      }
  });
}

void timePenalties(){
  //auxMaxTime = timeController.maxTime.value * timePenaltiesCounter;
  int currentTime = timeController.currentTime.value;
  if(currentTime >=  timeController.maxTime.value){

    if(currentTime >= timeController.maxTime.value + (timeController.timePerAdditionalPoint.value * timePenaltiesCounter)){
        int currentPoints = int.tryParse(riderController.penaltyPoints.value) ?? 0;
        int newPoints = int.tryParse("1") ?? 0;
        riderController.penaltyPoints.value = (currentPoints + newPoints).toString();
        timePenaltiesCounter++;
    }
  }
}

void initTime(){

  timeController.isCountdown = false.obs;
  timeController.isRunning = true.obs;
  // Cancela cualquier temporizador existente para evitar múltiples instancias
  timer?.cancel();

  // Reinicia el cronómetro para asegurar que comience desde 0
  _stopwatch.reset();
  _stopwatch.start(); // Inicia el cronómetro

  timeController.currentTime.value = timeController.lastTime.value;
 
  // Activa el botón o funcionalidad necesaria, si es necesario
  // timeController.enableF1 = false.obs;
  timeController.enableF2 = true.obs;

  // Crea un nuevo temporizador que se actualiza cada X milisegundos
  timer = Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
    // Incrementa el tiempo actual en X milisegundos
    timeController.currentTime.value += 10;
    timePenalties();
  });
}
 
void pauseTime(){
  // Cancela cualquier temporizador existente para evitar múltiples instancias
  timer?.cancel();
  timeController.lastTime.value = timeController.currentTime.value;
}

void stopTime(){ 
  // Cancela cualquier temporizador existente para evitar múltiples instancias
  timer?.cancel();
  timeController.lastTime.value = 0;
  timePenaltiesCounter = 0;

}
  
int get currentTime => timeController.currentTime.value;
bool get isRunning => _stopwatch.isRunning;
Timer? get _timer => timer; // Getter para acceder al Timer desde fuera

}