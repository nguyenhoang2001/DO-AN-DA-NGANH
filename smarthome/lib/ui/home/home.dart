import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/ui/home/components/temperature.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Smart Home"),
      ),
      body: Container(
          child: Center(
              child: Column(
        children: const [TemperatureWidget()],
      ))),
    );
  }
}
