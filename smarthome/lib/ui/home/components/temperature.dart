import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TemperatureWidget extends StatefulWidget {
  const TemperatureWidget({Key? key}) : super(key: key);

  @override
  State<TemperatureWidget> createState() => _TemperatureWidgetState();
}

class _TemperatureWidgetState extends State<TemperatureWidget> {
  final dbRef = FirebaseDatabase.instance.ref();
  var _temperature;
  var _dateTime;

  @override
  void initState() {
    super.initState();
    _getTemperatureValue();
  }

  void _getTemperatureValue() {
    try {
      dbRef.child("temperature/value").onValue.listen((event) {
        setState(() {
          _temperature = event.snapshot.value;
        });
      });
      dbRef.child("temperature/date and time").onValue.listen((event) {
        setState(() {
          _dateTime = event.snapshot.value;
        });
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _turnOnPump() {
    dbRef.child("pump").update({"state": 1});
  }

  void _turnOffPump() {
    dbRef.child("pump").update({"state": 0});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Text(
          "$_temperature",
          style: TextStyle(fontSize: 48),
        ),
        const SizedBox(height: 24),
        Text(
          "$_dateTime",
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 24),
        TextButton(onPressed: _getTemperatureValue, child: Text("Reset")),
        const SizedBox(height: 24),
        TextButton(onPressed: _turnOnPump, child: Text("Turn on pump")),
        const SizedBox(height: 24),
        TextButton(onPressed: _turnOffPump, child: Text("Turn off pump"))
      ]),
    );
  }
}
