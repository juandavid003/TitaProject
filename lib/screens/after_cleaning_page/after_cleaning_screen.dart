import 'package:flutter/material.dart';
import 'package:odontobb/screens/after_cleaning_page/components/after_cleaning_body.dart';
import 'package:odontobb/widgets/base_scaffold.dart';


class AfterCleaningScreen extends StatelessWidget {
    static const routeName = "/afterCleaning_page";
  const AfterCleaningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: AfterCleaningBody());
  }
}

