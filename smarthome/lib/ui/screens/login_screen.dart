import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../../theme.dart';
import '../provider/google_sign_in.dart';
import '../screens/screen.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.onClickedSignUp}) : super(key: key);
  final VoidCallback onClickedSignUp;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _hasError = false;
  FocusNode myFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          // appBar: AppBar(
          //   title: Text(
          //     "Smart Home",
          //     style: Theme.of(context).textTheme.headline2,
          //   ),
          // ),
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
                      'Sign In',
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
                    top: MediaQuery.of(context).size.height * 0.4,
                    left: 35,
                    right: 35,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              Provider.of<GoogleSignInProvider>(context,
                                      listen: false)
                                  .googleLogin();
                            },
                            icon: const FaIcon(FontAwesomeIcons.google,
                                color: Colors.red),
                            label: const Text('Sign in with Google')),
                        const SizedBox(height: 30),
                        buildEmailField(_emailController),
                        const SizedBox(height: 30.0),
                        buildPasswordField(_passwordController),
                        const SizedBox(height: 30.0),
                        buildButton(),
                        const SizedBox(height: 20.0),
                        buildOptions(context),
                      ],
                    ),
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
            maximumSize: const Size(170.0, 90.0),
            minimumSize: const Size(170.0, 60.0),
            primary: Colors.black,
            shape: const StadiumBorder(),
          ),
          onPressed: signIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'LOGIN',
                style: TextStyle(decoration: TextDecoration.none),
              ),
              Icon(
                Icons.content_paste_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: 'Sign Up',
            style: ThermometerTheme.lightTextTheme.bodyText1,
            recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
          ),
        ),
        TextButton(
            onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ResetPassword();
                })),
            child: Text(
              'Forgot password',
              style: ThermometerTheme.lightTextTheme.bodyText1,
            ))
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
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      style: ThermometerTheme.lightTextTheme.bodyText1,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: _hasError
            ? const TextStyle(color: Colors.red)
            : const TextStyle(color: Colors.blue),
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
    return TextFormField(
      focusNode: myFocusNode,
      controller: emailController,
      style: GoogleFonts.openSans(
          fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: 'abc@example.com',
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: 'Email',
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: _hasError
            ? const TextStyle(color: Colors.red)
            : const TextStyle(color: Colors.blue),
        fillColor: Colors.grey.shade200,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.black)),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? 'Please input a correct email!'
          : null,
    );
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        _hasError = true;
      });
      return;
    }

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
      Utils.ShowSnackBar(e.code);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
