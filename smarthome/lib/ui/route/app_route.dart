import 'package:flutter/material.dart';
import 'package:smarthome/ui/screens/home.dart';
import 'package:smarthome/ui/screens/splash_screen.dart';
import '../models/models.dart';
import '../screens/screen.dart';
import '../provider/providers.dart';

// 1
class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
// 2
  @override
  final GlobalKey<NavigatorState> navigatorKey;
// 3
  final AppStateManager appStateManager;
  final GoogleSignInProvider profileManager;

  AppRouter({
    required this.appStateManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    // TODO: Add Listeners
    appStateManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }
// TODO: Dispose listeners
  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

// 6
  @override
  Widget build(BuildContext context) {
// 7
    return Navigator(
// 8
      key: navigatorKey,
      // TODO: Add onPopPage
      onPopPage: _handlePopPage,
// 9
      pages: [
// TODO: Add SplashScreen
        if (!appStateManager.isInitialized) SplashScreen.page(),
// TODO: Add LoginScreen
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          HomeScreen.page(),

// TODO: Add Profile Screen
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getCustomer),
// TODO: Add WebView Screen
        if (profileManager.didTapOnHCMUT) WebViewScreen.page()
      ],
    );
  }

// TODO: Add _handlePopPage
  bool _handlePopPage(
// 1
      Route<dynamic> route,
// 2
      result) {
// 3
    if (!route.didPop(result)) {
// 4
      return false;
    }
// 5
// TODO: Handle state when user closes profile screen
    if (route.settings.name == ThermometerPage.profilePath) {
      profileManager.tapOnProfile(false);
    }
// TODO: Handle state when user closes WebView screen
    if (route.settings.name == ThermometerPage.hcmut) {
      profileManager.tapOnHCMUT(false);
    }

// 6
    return true;
  }

// 10
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
