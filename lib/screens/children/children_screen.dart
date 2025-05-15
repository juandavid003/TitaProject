import 'package:flutter/material.dart';
import 'components/children_body.dart';

class ChildrenScreen extends StatefulWidget {
  static const routeName = "/children_form";

  const ChildrenScreen({super.key});
  @override
  _ChildrenScreenState createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChildrenBody());
  }
}
