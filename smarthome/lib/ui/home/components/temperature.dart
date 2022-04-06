import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/util/constant.dart';

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
  late bool _userControl = false;

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

  MaterialColor _chooseColor() {
    _temperature = _temperature;
    if (_temperature > 0 && _temperature <= temper1) {
      return Colors.blue;
    } else if (_temperature > temper1 && _temperature <= temper2) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  String _chooseLabel() {
    if (_temperature > 0 && _temperature <= temper1) {
      return "Safe";
    } else if (_temperature > temper1 && _temperature <= temper2) {
      return "Warning";
    } else {
      return "Dangerous";
    }
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
                    elevation: 10,
                    shadowColor: _chooseColor(),
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
                        decoration: BoxDecoration(
                            // The child of a round Card should be in round shape
                            shape: BoxShape.circle,
                            color: _chooseColor()))),
                const SizedBox(
                  height: 8,
                ),
                Text(_chooseLabel(), style: TextStyle(color: _chooseColor())),
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
                          value: _userControl ? _pumpTurnedOn : false,
                          onChanged: (value) {
                            if (_userControl) {
                              setState(() {
                                _pumpTurnedOn = value;
                                if (_pumpTurnedOn) {
                                  _turnOnPump();
                                } else {
                                  _turnOffPump();
                                }
                              });
                            }
                          })
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Text(
                            "User control",
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                          value: _userControl,
                          onChanged: (value) {
                            setState(() {
                              _userControl = value;
                              _pumpTurnedOn = _userControl;
                              if (_pumpTurnedOn) {
                                _turnOnPump();
                              } else {
                                _turnOffPump();
                              }
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
