import 'package:flutter/material.dart';
import 'package:odontobb/widgets/drawer_widget.dart';

import '../../constant.dart';
import '../../util.dart';
import 'components/e_learning_body.dart';

class ELearningScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  const ELearningScreen({super.key});

  @override
  _ELearningScreenState createState() => _ELearningScreenState();
}

class _ELearningScreenState extends State<ELearningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kWhiteColor,
      body: ELearningBody(),
      drawer: DrawerWidget(),
    );
  }
}
