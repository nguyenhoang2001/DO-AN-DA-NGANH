import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/ui/models/models.dart';
import '../provider/google_sign_in.dart';
import '../components/components.dart';
import '../screens/screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static MaterialPage page() {
    return MaterialPage(
        child: const HomeScreen(),
        name: ThermometerPage.loginPath,
        key: ValueKey(ThermometerPage.loginPath));
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GoogleSignInProvider>(
      builder: (context, manager, _) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     "Smart Home",
          //     style: Theme.of(context).textTheme.headline2,
          //   ),
          // ),
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went Wrong!'),
                );
              } else if (snapshot.hasData) {
                return const VerifyEmailPage();
              } else {
                return const AuthPage();
              }
            },
          ),
        );
      },
    );
  }
}
