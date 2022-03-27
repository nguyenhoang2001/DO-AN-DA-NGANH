import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/components.dart';
import '../screens/screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _selectedTab = 0;
  // List<Widget> pages = <Widget>[const ResetPassword(), const Register()];
  // void _setPage(int index) {
  //   setState(() {
  //     _selectedTab = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Home",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
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
            return const Example();
          } else {
            return const Login();
          }
        },
      ), //pages[_selectedTab],
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedTab,
      //   selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
      //   onTap: _setPage,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.login),
      //       label: 'Login',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.app_registration),
      //       label: 'Register',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.lock_reset_sharp),
      //       label: 'Reset Password',
      //     )
      //   ],
      // ),
    );
  }
}
