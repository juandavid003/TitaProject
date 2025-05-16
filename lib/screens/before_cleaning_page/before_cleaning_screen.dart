import 'package:flutter/material.dart';
import 'package:odontobb/screens/before_cleaning_page/components/before_cleaning_body.dart';
import 'package:odontobb/widgets/base_scaffold.dart';

class BeforeCleaningScreen extends StatelessWidget {
  static const routeName = "/beforeCleaning_page";

  const BeforeCleaningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final cameFromBrushing = args != null && args['fromBrushing'] == true;
    final selectedChild = args != null ? args['child'] : null;

    return BaseScaffold(
      body: BeforeCleaningBody(
        cameFromBrushing: cameFromBrushing,
        selectedChild: selectedChild,
      ),
    );
  }
}