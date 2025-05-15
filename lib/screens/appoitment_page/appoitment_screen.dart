import 'package:flutter/material.dart';
import 'package:odontobb/screens/appoitment_page/components/appoitment_body.dart';
import 'package:odontobb/widgets/base_scaffold.dart';
import 'package:odontobb/models/person_model.dart'; // Asegúrate de importar el modelo adecuado

class AppoitmentScreen extends StatelessWidget {
  static const routeName = "/appoitment_screen";

  final PersonModel? personModel; // Definir el parámetro

  const AppoitmentScreen({super.key, this.personModel}); // Constructor actualizado

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: AppoitmentBody(personModel: personModel), // Pasar el parámetro a AppoitmentBody
    );
  }
}
