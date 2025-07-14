import 'package:flutter/material.dart';
import 'components/forgot_password_body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = "/forgot_pass_screen";

  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ForgotPasswordBody());
  }
}
