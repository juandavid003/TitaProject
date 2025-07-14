import 'package:flutter/material.dart';
import 'components/verification_body.dart';

class VerificationScreen extends StatelessWidget {
  static const routeName = "/verification_screen";
  final String verificationId;
  final String? name;
  final String? email;

  const VerificationScreen(this.verificationId, this.name, this.email,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VerificationBody(verificationId, name, email),
    );
  }
}
