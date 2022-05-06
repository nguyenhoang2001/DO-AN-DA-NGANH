import 'package:flutter/material.dart';
import 'package:smarthome/ui/models/models.dart';
import '../provider/providers.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static MaterialPage page() {
    return MaterialPage(
      name: ThermometerPage.splashPath,
      key: ValueKey(ThermometerPage.splashPath),
      child: const SplashScreen(),
    );
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO: Initialize App
    Provider.of<AppStateManager>(context, listen: false).initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.blue.shade300),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50.0,
                      // child: Icon(
                      //   Icons.local_grocery_store,
                      //   color: Colors.black,
                      //   size: 50.0,
                      // ),
                      backgroundImage: AssetImage(
                        "assets/authentication/logo_splashScreen.png",
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Text(
                      "Smart Home",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CircularProgressIndicator.adaptive(value: 3.0,),
              //     Padding(padding: const EdgeInsets.only(top: 20.0))
              //   ],
              // ),)
            ],
          )
        ],
      ),
    );
  }
}
