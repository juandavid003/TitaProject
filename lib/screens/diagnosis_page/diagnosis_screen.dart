import 'package:flutter/material.dart';
import 'package:odontobb/screens/diagnosis_page/components/diagnosis_body.dart';
import 'package:odontobb/widgets/base_scaffold.dart';
import 'package:odontobb/models/person_model.dart'; // Asegúrate de importar el modelo

class DiagnosisScreen extends StatelessWidget {
  static const routeName = "/diagnosis_screen";

  final PersonModel? personModel;

  const DiagnosisScreen({Key? key,  this.personModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: DiagnosisBody(personModel: personModel));
  }
}
