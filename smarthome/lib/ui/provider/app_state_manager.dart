import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smarthome/ui/provider/google_sign_in.dart';

class AppStateManager extends ChangeNotifier {
  bool _initialized = false;
  bool _loggedIn = false;
  bool _onboardingComplete = false;
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;

// TODO: Add initializeApp
  void initializeApp() {
    Timer(const Duration(milliseconds: 2000), () {
      _initialized = true;
      notifyListeners();
    });
  }

// TODO: Add login
  void login(String username, String password) {
    _loggedIn = true;
    notifyListeners();
  }

// TODO: Add completeOnboarding
  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

// TODO: Add logout
  void logout() {
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;

    initializeApp();
    notifyListeners();
  }
}
