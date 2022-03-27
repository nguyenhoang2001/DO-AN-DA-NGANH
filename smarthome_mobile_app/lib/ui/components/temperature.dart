import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TemperatureWidget extends StatefulWidget {
  const TemperatureWidget({Key? key}) : super(key: key);

  @override
  State<TemperatureWidget> createState() => _TemperatureWidgetState();
}

class _TemperatureWidgetState extends State<TemperatureWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints.expand(height: 450, width: 350),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.blue,
        child: Stack(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text("Switch"), Text("reload button")],
              ),
            )
          ],
        ),
      ),
    );
  }
}
