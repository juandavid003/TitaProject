import 'package:flutter/material.dart';

import '../../util.dart';
import 'components/main_body.dart';

class MainScreen extends StatelessWidget {
  static const routeName = "/main_screen";

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Utils.getColorFromHex("E4E4E4"), body: MainBody());
  }
}
