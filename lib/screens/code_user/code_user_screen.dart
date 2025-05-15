import 'package:flutter/material.dart';
import 'package:odontobb/screens/code_user/components/code_user_body.dart';

class CodeUserScreen extends StatefulWidget {
  static const routeName = "/code_user_screen";

  final String personId;
  final String title;

  const CodeUserScreen({
    super.key,
    required this.personId,
    required this.title,
  });

  @override
  _CodeUserScreenState createState() => _CodeUserScreenState();
}

class _CodeUserScreenState extends State<CodeUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: CodeUserBody(
      //   personId: widget.personId,
      //   title: widget.title,
      // ),
    );
  }
}
