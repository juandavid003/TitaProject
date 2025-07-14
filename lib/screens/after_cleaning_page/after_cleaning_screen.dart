import 'package:flutter/material.dart';
import 'package:odontobb/screens/after_cleaning_page/components/after_cleaning_body.dart';
import 'package:odontobb/widgets/base_scaffold.dart';

class AfterCleaningScreen extends StatelessWidget {
  static const routeName = "/afterCleaning_page";

  final bool cameFromBrushing;
  final dynamic selectedChild;

  const AfterCleaningScreen(
      {super.key, this.cameFromBrushing = false, this.selectedChild});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: AfterCleaningBody(
        cameFromBrushing: cameFromBrushing,
        selectedChild: selectedChild,
      ),
    );
  }
}
