import 'package:flutter/material.dart';

import 'components/login_body.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen_page";

  const LoginScreen({super.key});
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginBody());
  }
}
