import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:kroner_app/styles.dart';
import 'package:kroner_app/Components/Menus/myDropdownMenu.dart';
import 'package:kroner_app/Components/Buttons/pointsButtons.dart';
import 'package:kroner_app/Components/Buttons/saveButtons.dart';
import 'package:kroner_app/Components/myBottomNavigationBar.dart';
import 'package:kroner_app/Components/Buttons/timeButtons.dart';
import 'package:kroner_app/Components/Buttons/SettingsButton.dart';

import 'package:provider/provider.dart';

import 'package:kroner_app/Controllers/blecontroller.dart';
import 'package:kroner_app/Components/Labels/pointsLabel.dart';  
import 'package:kroner_app/Components/Labels/timeLabel.dart';
import 'package:kroner_app/Components/Tables/resultsTable.dart';  

import 'package:kroner_app/Utils/controller.dart';
import 'package:kroner_app/Utils/timerManager.dart';
import 'package:kroner_app/Utils/jsonController.dart';

//List<Map<String, dynamic>> datos = [];

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final bleController = BleController();
  //String jsonDatos = await rootBundle.loadString('assets/datos.json');
  //datos = List<Map<String, dynamic>>.from(jsonDecode(jsonDatos));
  
  
  //Get.put(DataController()); // Crea una instancia de DataController
  Get.put(RiderController()); // Crea una instancia de RiderController
  Get.put(TimeController()); // Crea una instancia de TimeController
  Get.put(States()); // Crea una instancia de States
  Get.put(Connections()); // Crea una instancia de Connections
  Get.put(TimerManager()); // Crea una instancia de smartwatchController
  Get.put(Results()); // Crea una instancia de Results

  final Results results = Get.find();
  
  //results.datos.value = await loadJSON();
  

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
  final TimerManager timerManager = TimerManager();
  final Results results = Get.find();
  String _penaltyPoints = "0";


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timerManager.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final RiderController riderController = Get.find<RiderController>();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Kroner v0.2.0'),
        toolbarHeight: 50.0,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ TimeButtons(
                          onPointsUpdated: (points) {
                            
                          },
                        ),
                        mySizedBox(context),
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
                          TimeLabel(
                           // textStyle: textStyle(context),
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
                            penaltyPoints: riderController.penaltyPoints.value,
                            //penaltyPoints: _penaltyPoints,
                            textStyle: textStyle(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                mySizedBox(context),
                mySizedBox(context),
                  ResultsTable()
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
        SettingsButton(),
        ],
      ),
    
      bottomNavigationBar: Container(
        height: 60,
        child:
          MyBottomNavigationBar(),
      ),
    ),
    );
    
  }
  
  
}

