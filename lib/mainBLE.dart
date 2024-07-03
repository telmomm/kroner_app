////////////////filename: main.dart
//change in build.gradle - minSdkVersion 21
//give this app location permission and turn on bluetooth on your phone/tablet
//add plugins - flutter_reactive_ble and get
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controllers/blecontrollerBASE.dart';

void main() {
  runApp(MyApp());}

class MyApp extends StatelessWidget {
@override Widget build(BuildContext context) {
return GetMaterialApp(
title: 'Flutter Demo',
theme: ThemeData(
primarySwatch: Colors.blue,
visualDensity: VisualDensity.adaptivePlatformDensity,),
home: MyHomePage());}}

class MyHomePage extends StatelessWidget {
TextStyle myStyle = TextStyle(fontSize: 30);  
final BleController c = Get.put(BleController());
MyHomePage();
@override Widget build(BuildContext context){   
return Scaffold(
appBar: AppBar(title: Text('ble test')),
body: Column(children: <Widget>[

  SizedBox(height:50),
            
  Obx(() => Text('${c.status}',
    style:myStyle)),
    
  SizedBox(height:50),
            
  Obx(() => Text('pico adc(4) value: ${c.temperature}',
    style:myStyle)),
    
  SizedBox(height:50),
    
  Obx(() => Container(
    child: c.status != 'connected!'
      ? ElevatedButton(onPressed: c.connect,
          child: Text('connect',
            style:myStyle))
      : null))]));}}