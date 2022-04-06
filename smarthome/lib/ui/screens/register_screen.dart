import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import '../../main.dart';
import '../../utils/utils.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.onClickedSignIn}) : super(key: key);
  final VoidCallback onClickedSignIn;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _hasError = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passWordController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/authentication/register.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
              elevation: null,
              backgroundColor: Colors.transparent,
              leading: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              )),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'REGISTER\n NOW',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28,
                    left: 35,
                    right: 35,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildUsernameField(),
                        const SizedBox(height: 30.0),
                        buildEmailField(),
                        const SizedBox(height: 30.0),
                        buildPhoneField(),
                        const SizedBox(height: 30.0),
                        buildPasswordField(),
                        const SizedBox(height: 30.0),
                        buildRegisterButton(),
                        const SizedBox(height: 20.0),
                        buildForgotpassWord(context),
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

  TextFormField buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      obscureText: false,
      style: ThermometerTheme.lightTextTheme.bodyText1,
      cursorColor: Colors.blue[300],
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: _hasError
            ? const TextStyle(color: Colors.red)
            : const TextStyle(color: Colors.blue),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: '0123456789',
        labelText: 'Phone',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) {
          return 'Please enter your phone number';
        }
        if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  TextFormField buildUsernameField() {
    return TextFormField(
      obscureText: false,
      controller: _usernameController,
      style: ThermometerTheme.lightTextTheme.bodyText1,
      cursorColor: Colors.blue[300],
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: _hasError
            ? const TextStyle(color: Colors.red)
            : const TextStyle(color: Colors.blue),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: 'abc@example.com',
        labelText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) {
          return 'Please enter a username';
        } else if (value.length < 3) {
          return 'Username must be at least 3 characters';
        } else if (value.length > 20) {
          return 'Username must be less than 20 characters';
        } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
          return 'Username must be alphanumeric';
        } else {
          return null;
        }
      },
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      obscureText: false,
      controller: _emailController,
      style: ThermometerTheme.lightTextTheme.bodyText1,
      cursorColor: Colors.blue[300],
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: _hasError
            ? const TextStyle(color: Colors.red)
            : const TextStyle(color: Colors.blue),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: 'abc@example.com',
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) {
        return email != null && !EmailValidator.validate(email)
            ? 'Enter a valid email'
            : null;
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      obscureText: true,
      controller: _passWordController,
      style: ThermometerTheme.lightTextTheme.bodyText1,
      cursorColor: Colors.blue[300],
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: _hasError
            ? const TextStyle(color: Colors.red)
            : const TextStyle(color: Colors.blue),
        fillColor: Colors.grey.shade200,
        filled: true,
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) {
          return 'Please input a password';
        } else if (value.length < 8) {
          return 'Password must be more than 7 characters';
        } else if (value.length > 20) {
          return 'Password must be less than 20 characters';
        } else if (value.contains(RegExp(r'[0-9]')) == false) {
          return 'Password must contain at least one number';
        } else if (value.contains(RegExp(r'[A-Z]')) == false) {
          return 'Password must contain at least one uppercase letter';
        } else if (value.contains(RegExp(r'[a-z]')) == false) {
          return 'Password must contain at least one lowercase letter';
        } else if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) == false) {
          return 'Password must contain at least one special character';
        } else {
          return null;
        }
      },
    );
  }

  Row buildRegisterButton() {
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
            onPressed: register,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('REGISTER',
                    style: TextStyle(decoration: TextDecoration.none)),
                Icon(
                  Icons.content_paste_rounded,
                  color: Colors.white,
                ),
              ],
            )),
      ],
    );
  }

  Row buildForgotpassWord(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: "Sign In",
            style: ThermometerTheme.lightTextTheme.bodyText1,
            recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignIn,
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

  Future register() async {
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passWordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Utils.ShowSnackBar(e.message);
    }
    //TODO: Back to the login page
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
