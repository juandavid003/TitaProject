import 'package:flutter/material.dart';
import 'package:odontobb/screens/did_you_know_page/components/did_you_know_body.dart';
import 'package:odontobb/widgets/drawer_widget.dart';

import '../../constant.dart';
import '../../util.dart';

class DidYouKnowScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  const DidYouKnowScreen({super.key});

  @override
  _DidYouKnowScreenState createState() => _DidYouKnowScreenState();
}

class _DidYouKnowScreenState extends State<DidYouKnowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kWhiteColor,
      body: DidYouKnowBody(),
      drawer: DrawerWidget(),
    );
  }
}
