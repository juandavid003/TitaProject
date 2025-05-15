import 'package:flutter/material.dart';
import 'package:odontobb/screens/before_cleaning_page/components/before_cleaning_body.dart';
import 'package:odontobb/widgets/base_scaffold.dart';

class BeforeCleaningScreen extends StatelessWidget {
  static const routeName = "/beforeCleaning_page";
  const BeforeCleaningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: BeforeCleaningBody());
  }
}
