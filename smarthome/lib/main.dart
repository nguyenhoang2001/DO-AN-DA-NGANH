import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/provider/google_sign_in.dart';
import 'ui/screens/home.dart';
import 'utils/utils.dart';
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
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: messengerKey,
        navigatorKey: navigatorKey,
        title: 'Smart Home',
        theme: theme,
        home: const HomeScreen(),
      ),
    );
  }
}
