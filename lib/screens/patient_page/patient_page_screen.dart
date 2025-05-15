import 'package:flutter/material.dart';
import 'package:odontobb/widgets/base_scaffold.dart';
import 'components/patient_page_body.dart';

class PatientPageScreen extends StatelessWidget {
  static const routeName = "/patient_page";

  const PatientPageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: PatientPageBody());
  }
}
