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
  var _pumpTurnedOn = false;

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
      color: Colors.blue[50],
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.withOpacity(0.4), width: 1),
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: Container(
                        child: Center(
                          child: Text(
                            "$_temperature\u2103",
                            style: const TextStyle(
                                fontSize: 48, color: Colors.white),
                          ),
                        ),
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                            // The child of a round Card should be in round shape
                            shape: BoxShape.circle,
                            color: Colors.blue))),
                // const SizedBox(height: 24),
                // TextButton(
                //     onPressed: _getTemperatureValue, child: Text("Reset")),
                // const SizedBox(height: 24),
                // TextButton(onPressed: _turnOnPump, child: Text("Turn on pump")),
                // const SizedBox(height: 24),
                // TextButton(
                //     onPressed: _turnOffPump, child: Text("Turn off pump"))
                Padding(
                  padding: const EdgeInsets.all(48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Text(
                            "Pump",
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Connected",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                          value: _pumpTurnedOn,
                          onChanged: (value) {
                            setState(() {
                              _pumpTurnedOn = value;
                            });
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "$_dateTime",
          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
      ]),
    );
  }
}
