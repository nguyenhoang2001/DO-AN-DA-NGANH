import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future signOut() async {
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('hello'),
            IconButton(onPressed: signOut, icon: const Icon(Icons.backspace))
          ],
        ),
      ),
    );
  }
}
