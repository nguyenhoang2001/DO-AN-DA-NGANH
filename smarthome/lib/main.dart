import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/provider/providers.dart';
import 'ui/screens/home.dart';
import 'utils/utils.dart';
import 'theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/route/app_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = ThermometerTheme.dark();
  final _profileManager = GoogleSignInProvider();
  final _appStateManager = AppStateManager();
  late AppRouter _appRouter;

  void initState() {
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      profileManager: _profileManager,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _profileManager),
        ChangeNotifierProvider(create: (context) => _appStateManager),
      ],
      child: Consumer<GoogleSignInProvider>(
        builder: (context, value, child) {
          ThemeData theme;
          if (value.darkMode) {
            theme = ThermometerTheme.dark();
          } else {
            theme = ThermometerTheme.light();
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: messengerKey,
            navigatorKey: navigatorKey,
            title: 'Smart Home',
            theme: theme,
            // home: const HomeScreen(),
            home: Router(
              routerDelegate: _appRouter,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          );
        },
      ),
    );
  }
}
