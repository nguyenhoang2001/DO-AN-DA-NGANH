import 'package:firebase_auth/firebase_auth.dart';

class Customer {
  late User? user;
  bool darkMode;
  Customer({required this.darkMode, this.user});
}
