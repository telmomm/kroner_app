import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:kroner_app/styles.dart';
import 'package:kroner_app/Components/myDropdownMenu.dart';
import 'package:kroner_app/Components/pointsButtons.dart';
import 'package:kroner_app/Components/saveButtons.dart';
import 'package:kroner_app/Components/myBottomNavigationBar.dart';

import 'package:provider/provider.dart';

import 'package:kroner_app/Controllers/blecontroller.dart';
import 'package:kroner_app/Components/pointsLabel.dart';  
import 'package:kroner_app/Components/resultsTable.dart';  

List<Map<String, dynamic>> datos = [];

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final bleController = BleController();
  String jsonDatos = await rootBundle.loadString('assets/datos.json');
  datos = List<Map<String, dynamic>>.from(jsonDecode(jsonDatos));
  Get.put(DataController()); // Crea una instancia de DataController

  runApp(
    Provider<BleController>(
      create: (context) => bleController,
      child: MyApp(),
    ),
  );

  //bleController.startScan();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Center(
        child: Text('Aquí puedes configurar las variables de la aplicación.'),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Stopwatch _stopwatch = Stopwatch();
  String _penaltyPoints = "0";
  Timer? _timer;
  int _initialTime = 45*1000; // Tiempo inicial en milisegundos
  int _currentTime = 0;
  bool _isCountdown = false;
  bool _enableF1 = false;
  bool _enableF2 = false;
  String _dropdownValue = 'A2';

  final dataController = Get.find<DataController>();

/*
  List<Map<String, dynamic>> datosOLD = [
    {
      'Numero': '1',
      'Nombre': 'Name Test',
      'Puntos': '0',
      'Tiempo': '45,10',
    },
    {
      'Numero': '2',
      'Nombre': 'Name Test 2',
      'Puntos': '8',
      'Tiempo': '57,30',
    },
    {
      'Numero': '3',
      'Nombre': 'Name Test 3',
      'Puntos': 'ELIM',
      'Tiempo': '-',
    },
    // Agrega más mapas según sea necesario
  ];
*/
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 100), _updateTimer);

    ever(dataController.F1, (_) {
      onF1Pressed();
    });
    ever(dataController.F2, (_) {
      onF2Pressed();
    });

  }

  void _updateTimer(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {}); // Actualiza visualmente cada 100ms si el cronómetro está en marcha
    }
  }

  void onBellPressed() async {
    AudioCache player = AudioCache();
    await player.play('beep.mov');
    _isCountdown = true;
    _stopwatch.reset();
    _stopwatch.start();
    _currentTime = _initialTime;
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (_currentTime > 0) {
        _currentTime -= 100;
      } else {
        _stopwatch.stop();
        timer.cancel();
        onF1Pressed();
      }
      setState(() {});
    });

    setState(() {
    _enableF1 = true;

  });
  }

  void onF1Pressed() {
  _isCountdown = false;
  _stopwatch.reset();
  _stopwatch.start();

  _enableF1 = false;
  _enableF2 = true;
}

  void onF2Pressed() {
    _stopwatch.stop();
    
    _enableF2 = false;
    setState(() {
      
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Kroner v1.0'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton( key: const Key('bell'),
                  onPressed: () {
                    onBellPressed();
                    _penaltyPoints = "0";
                    setState(() {});
                  },
                  child: Icon(Icons.notifications),
                  style: myButtonStyle(context)
                ),         
                //const SizedBox(height: 40),
                mySizedBox(context),
                mySizedBox(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton( key: const Key('F1'),
                      onPressed: _enableF1 ? onF1Pressed : null, // Deshabilita el botón si _enableF1 es false
                      child: const Text('F1'),
                    ),
                    const SizedBox(width: 20), // Espacio entre los botones
                    ElevatedButton( key: const Key('F2'),
                      onPressed: _enableF2 ? onF2Pressed : null, // Deshabilita el botón si _enableF2 es false
                      child: const Text('F2'),
                    ),
                    const SizedBox(width: 20),
                    ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text('${dataController.F1.value}')),
                    Text("     -     "),
                    Obx(() => Text('${dataController.F2.value}')),
                  ]
                ),
                mySizedBox(context),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10), // Ajusta este valor según tus necesidades
                    child: Text(
                      'Baremo',
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                  ),
                ),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    myDropdownMenu(),
                    const SizedBox(width: 2),
                    ElevatedButton( key: const Key('baremoSettings'),
                      onPressed:(){},
                      child: Icon(Icons.settings),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent), // Hace que el fondo sea transparente
                        foregroundColor: MaterialStateProperty.all(Colors.grey), // Hace que el icono sea gris
                        shadowColor: MaterialStateProperty.all(Colors.transparent), // Elimina la sombra
                        padding: MaterialStateProperty.all(EdgeInsets.zero), // Elimina el padding
                    )
                    )
                  ]
                ),
                const SizedBox(height: 5),
                
              ],
            ),
          ),
  
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          mySizedBox(context),
                          mySizedBox(context),
                          Text(
                            formatTime(_stopwatch.elapsedMilliseconds),
                            style: textStyle(context),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          mySizedBox(context),
                          mySizedBox(context),
                          PointsLabel(
                            penaltyPoints: _penaltyPoints,
                            textStyle: textStyle(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                mySizedBox(context),
                ResultsTable(datos: datos), // Agrega esta línea
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ ButtonList(
                          onPointsUpdated: (points) {
                            setState(() {
                              _penaltyPoints = points;
                            });
                          },
                        ),
                        mySizedBox(context),
                        //SaveButtonList()
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    ),
    );
    
  }

  String formatTime(int milliseconds) {
  if (_isCountdown) {
    int remaining = _initialTime - milliseconds;
   
    int hundredths = (remaining / 10).truncate();
    int seconds = (remaining / 1000).truncate();
    hundredths %= 100;
    //return "${hours.toInt()}:${minutes.toInt().toString().padLeft(2, '0')}:${seconds.toInt().toString().padLeft(2, '0')}";
    return '$seconds.${(hundredths/10).truncate()}';
  } else {
    int hundredths = (milliseconds / 10).truncate();
    int seconds = (hundredths / 100).truncate();
    hundredths %= 100;
    return _stopwatch.isRunning ? '$seconds.${(hundredths/10).truncate()}' : '$seconds.${hundredths.toString().padLeft(2, '0')}';
  }
}
  
  
}

