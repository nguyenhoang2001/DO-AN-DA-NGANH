import 'package:flutter/material.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {
  static ShowSnackBar(String? text) {
    final snackBar = SnackBar(
      content: Text(text!),
      backgroundColor: Colors.red.shade300,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
