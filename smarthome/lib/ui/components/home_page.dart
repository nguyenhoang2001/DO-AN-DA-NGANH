import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthome/ui/provider/google_sign_in.dart';
import './temperature.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/screen.dart';
import '../models/models.dart';

class SmartHome extends StatefulWidget {
  const SmartHome({Key? key}) : super(key: key);

  @override
  State<SmartHome> createState() => _SmartHomeState();
}

class _SmartHomeState extends State<SmartHome> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    _portraitModeOnly();
    super.initState();
  }

  @override
  void dispose() {
    _enableRotation();
    if (user != null) {
      user = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const AuthPage()
        : Scaffold(
            appBar: AppBar(
              actions: [if (user != null) profileButton()],
              elevation: 2.0,
              // backgroundColor: Colors.white,
              // foregroundColor: Colors.black,
              // centerTitle: true,
              title: const Text("Smart Home"),
            ),
            body: const TemperatureWidget(),
          );
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Widget profileButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(user!.photoURL ??
              'https://thumbs.dreamstime.com/z/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg'), //user.photoURL??''
        ),
        onTap: () {
          // TODO: home -> profile
          Provider.of<GoogleSignInProvider>(context, listen: false)
              .tapOnProfile(true);
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return ProfileScreen(
          //       customer: Customer(darkMode: false, user: user));
          // }));
        },
      ),
    );
  }
}
