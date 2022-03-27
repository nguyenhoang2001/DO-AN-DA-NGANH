import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome_mobile_app/main.dart';
import 'package:smarthome_mobile_app/theme.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _emailCheck = false;
  bool _passworkCheck = false;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/authentication/login.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 60.0,
                    ),
                    child: const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: 35,
                    right: 35,
                  ),
                  child: Column(
                    children: [
                      buildEmailField(_emailController),
                      const SizedBox(height: 30.0),
                      buildPasswordField(_passwordController),
                      const SizedBox(height: 30.0),
                      buildButton(),
                      const SizedBox(height: 30.0),
                      buildOptions(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            maximumSize: const Size(double.infinity, 90.0),
            minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 60.0),
            primary: Colors.black,
            shape: const StadiumBorder(),
          ),
          onPressed: signIn,
          child: const Text('Login'),
        ),
      ],
    );
  }

  Row buildOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, 'register');
          },
          child: const Text(
            'Register',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, 'forgot');
          },
          child: const Text(
            'Forgot password?',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  TextFormField buildPasswordField(TextEditingController passwordController) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the password';
        } else if (value.length <= 6) {
          return 'Password must be greator than 6 digits';
        }
      },
      focusNode: _passwordFocusNode,
      obscureText: true,
      style: ThermometerTheme.lightTextTheme.bodyText1,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.grey),
        errorText: _passworkCheck ? 'Wrong Password!' : null,
        fillColor: Colors.grey.shade200,
        filled: true,
        // hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget buildEmailField(TextEditingController emailController) {
    return TextField(
      controller: emailController,
      focusNode: _emailFocusNode,
      style: ThermometerTheme.lightTextTheme.bodyText1,
      cursorColor: Colors.blue[300],
      decoration: InputDecoration(
        hintText: 'abc@example.com',
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: 'Email',
        labelStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.grey.shade200,
        filled: true,
        errorText: _emailCheck ? 'Email is not correct!' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _emailCheck = true; //loginfail is bool
          _passworkCheck = false;
        });
        _emailFocusNode.requestFocus();
      } else {
        setState(() {
          _passworkCheck = true;
          _emailCheck = false; //
        });
        _passwordFocusNode.requestFocus();
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
