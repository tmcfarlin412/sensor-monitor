import 'splash.dart';
import 'view_sensor_piezo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  //   name: 'db2',
  //   options: FirebaseOptions(
  //     appId: '1:851132837008:android:d0c5422084f26d2de8bc15',
  //     apiKey: 'AIzaSyDm6u9siikIsqNz9RThgiURacFf_uVSUwE',
  //     projectId: 'arduino-radon',
  //     messagingSenderId: '851132837008',
  //     databaseURL: 'https://arduino-radon.firebaseio.com/',
  //   ),
  // );

  runApp(MyApp(app: app));
}

class MyApp extends StatelessWidget{

  final FirebaseApp app;

  MyApp({this.app});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piezo Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => SplashPage(), // Default
        '/view_sensor_piezo': (BuildContext context) => ViewSensorPiezo(app: this.app), // Default
      },
    );
  }
}