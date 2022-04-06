import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import 'package:email_validator/email_validator.dart';
import '../../utils/utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  bool _hasError = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
                      'RESET \n NOW',
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildEmailField(),
                        const SizedBox(height: 30.0),
                        buildButton(),
                        const SizedBox(height: 30.0),
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

  Row buildOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: 'Register',
            style: ThermometerTheme.lightTextTheme.bodyText1,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'LOGIN',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
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
          onPressed: resetEmail,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text('RESET NOW'),
              Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
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

  Future resetEmail() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() => _hasError = true);
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
      final user = FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      await user;
      Utils.ShowSnackBar('Password reset email sent!');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (error) {
      Utils.ShowSnackBar(error.code);
      Navigator.of(context).pop();
    }
  }
}
