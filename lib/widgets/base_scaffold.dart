import 'package:flutter/material.dart';
import '../constant.dart';
import '../util.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;

  const BaseScaffold({super.key, required this.body});

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Utils.isDarkMode ? kDarkBgColor : kWhiteColor,
        body: SafeArea(child: widget.body));
  }
}
