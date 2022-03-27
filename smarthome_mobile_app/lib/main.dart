import 'package:flutter/material.dart';
import 'package:smarthome_mobile_app/ui/screens/home.dart';
import 'theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  ThemeData theme = ThermometerTheme.dark();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Smart Home',
      theme: theme,
      home: const HomeScreen(),
    );
  }
}
