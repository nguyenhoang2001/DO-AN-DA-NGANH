import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import 'package:provider/provider.dart';
import '../provider/google_sign_in.dart';

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    Future signOut() async {
      FirebaseAuth.instance.signOut();
    }

    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home Page',
            style: Theme.of(context).textTheme.headline2,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .logout();
                },
                child: const Text('Logout'))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoURL ?? ''),
              ),
              const SizedBox(height: 10),
              Text(
                'hello ${user.displayName}',
                style: ThermometerTheme.darkTextTheme.headline2,
              ),
              const SizedBox(height: 10),
              Text(
                'Email: ${user.email}',
                style: ThermometerTheme.darkTextTheme.headline2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
