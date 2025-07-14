import 'package:flutter/material.dart';
import 'components/create_account_body.dart';

class CreateAccountScreen extends StatefulWidget {
  static const routeName = "/create_account_page";

  const CreateAccountScreen({super.key});
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CreateAccountBody());
  }
}
