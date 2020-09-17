import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ViewSensorPiezo extends StatefulWidget {
  ViewSensorPiezo();

  @override
  _ViewSensorPiezoState createState() => _ViewSensorPiezoState();
}

class _ViewSensorPiezoState extends State<ViewSensorPiezo> {
  Map<dynamic, dynamic> _readings;

  @override
  void initState() {
    getData();
  }

  void getData() async {
    final FirebaseDatabase database = FirebaseDatabase();
    DatabaseReference ref = database.reference();
    database
        .reference()
        .child('piezo-1')
        .orderByKey()
        .limitToLast(100)
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        _readings = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetReadings =
        new List.from(<Widget>[Text('Time'), Text('Reading')]);
    if (_readings == null) {
      widgetReadings.addAll([Text('Loading...'), Text('Loading...')]);
    } else {
      DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
      for (String utcSeconds in _readings.keys) {
        widgetReadings.add(Text(formatter.format(
            DateTime.fromMillisecondsSinceEpoch(
                int.parse(utcSeconds) * 1000))));
        widgetReadings.add(Text("${_readings[utcSeconds]}"));
      }
    }
    return Scaffold(
      body: Center(
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 2,
            children: widgetReadings),
      ),
    );
  }
}
