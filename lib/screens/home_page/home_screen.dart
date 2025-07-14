import 'package:flutter/material.dart';
import 'package:odontobb/widgets/drawer_widget.dart';

import '../../constant.dart';
import '../../util.dart';
import 'components/home_body.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kWhiteColor,
      body: HomeBody(),
      drawer: DrawerWidget(),
    );
  }
}
