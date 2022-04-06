import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/utils.dart';
import '../components/components.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool _canResendEmail = true;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVarified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVarified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        _canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 10));
      setState(() {
        _canResendEmail = true;
      });
    } on FirebaseException catch (e) {
      Utils.ShowSnackBar(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const SmartHome()
        : Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An email has been sent to your mailbox, please verify it!',
                    style: GoogleFonts.openSans(
                        fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: _canResendEmail ? sendVerificationEmail : null,
                    icon: const Icon(Icons.email),
                    label: Text(
                      'Resend Email',
                      style: GoogleFonts.openSans(
                          fontSize: 20, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // const SizedBox(height: 10),
                  TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text('Cancel',
                          style: GoogleFonts.openSans(fontSize: 14)))
                ],
              ),
            ),
          );
  }
}
