import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:odontobb/models/appoitment_model.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:http/http.dart' as http;
import 'package:odontobb/services/authentication_service.dart';

class AppoitmentService {
  AppoitmentService();

  Future<dynamic> getHours(DateTime date, int clinicId) async {
    final response = await http.get(Uri.https('odontofy.org',
        'OdontoFyWebApi/api/Appoitment/Available/$clinicId/${date.day}/${date.month}/${date.year}'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<dynamic> createAppoitment(
      AppoitmentModel appt, PersonModel person) async {
    final authService = AuthenticationService(FirebaseAuth.instance);
    String? phoneNumber = await authService.getUserPhoneNumber();
    final response = await http.post(
      Uri.https(
          'odontofy.org', 'OdontoFyWebApi/api/Appoitment/SmartAppoitment'),
      // Uri.http('localhost:21737', '/api/Appoitment/SmartAppoitment'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "appoitment": {
          "StartDate": appt.startDate.toString(),
          "EndDate": appt.endDate.toString(),
          "ClinicId": appt.clinicId,
          "Scheduler": 220
        },
        "person": {
          "Mobile": phoneNumber,
          "Name": person.name,
          "LastNames": person.lastNames,
          "Sex": 1
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      print("Respuesta del servidor: $responseData");

      if (responseData["Success"] == true) {
        int patientId =
            responseData["Data"]["PatientId"]; // Extraer el PatientId
        await updatePatientIdInFirebase(person.id!, patientId);
      }

      return responseData;
    } else {
      throw Exception('Failed to save appointment');
    }
  }

  Future<dynamic> updateAppointment(
      AppoitmentModel appt, PersonModel person) async {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    String strHour = timeFormat.format(appt.startDate!);

    final response = await http.put(
      Uri.https('odontofy.org', 'OdontoFyWebApi/api/Appoitment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer xaf23BRcO0ImjWcZB9swgpYm_Pel4gLnIU7KyDfeQFOGRaVXprglHBMavD5yLNM8k5f_2VfNoW5qK3C5wsxBNjjF-6qEY1Q8Fs48_Bs6sRNevsUiE11sC74mUArM2iOsk7SOHL6Hll33zIRyLZHGBlCSYomuVYRL_mUGSDHL1Vh_JRlfo9JIM5LOAKRebzJ3zmMXNNiFAtYw0zHdu6IDTLtCQ00kH2nGO-jQMLJmV70kLvLtdV_LsMkN-lwUnx8ZYIMXiWvJ47f5jamUnnRFxfWamoxb3okDQmoYRotix3S51ln0FnelnzEs1PoQQ3Oyhjy_9_43VbxF6m_UtTkszLb245JJMK8t2CLs_9pQsCXZvmHEr9fWLH3GScY1C2VpfDSQtWl3Qb3A7Zg4TMF_SVvWDlKgp2orNOYzRFIdYes02fWsWsM05rtLElyTl7TsEaGJBGeAA-2OW6X3NFQRrPGUQdAtCRfEwE7JtW-WEsbH_HWrTfKWXWYLrsW3D53_'
      },
      body: jsonEncode(<String, dynamic>{
        "Id": appt.id,
        "StartDate": appt.startDate!.toIso8601String(),
        "EndDate": appt.endDate!.toIso8601String(),
        "ClinicId": appt.clinicId,
        "Status": "SCHEDULED",
        "PatientId": person.odontofyPatientId,
        "ClassName": "bgm-orange",
        "Scheduler": 220,
        "EmployeeLastUpdate": 2,
        "strStartDate": null,
        "strHour": strHour,
        "Clinic": null,
        "Employee": null,
        "Patient": null,
        "Duration": 45,
        "CantDateType": 0,
        "DateType": null
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Respuesta del servidor: $responseData");
      return responseData;
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
      throw Exception('Failed to update appointment');
    }
  }

  Future<dynamic> getLastScheduledAppointmentByPatientId(int patientId) async {
    try {
      final response = await http.get(
        Uri.https('odontofy.org',
            'OdontoFyWebApi/api/Appoitment/GetLastScheduledAppointmentByPatientId/$patientId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener la última cita del paciente');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> setAppointmentStatus(String status, int appointmentId) async {
    try {
      final response = await http.get(
        Uri.https('odontofy.org',
            'OdontoFyWebApi/api/Appoitment/Status/$status/$appointmentId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al realizar la accion, vuelvalo a intentar');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

Future<dynamic> updatePatientIdInFirebase(
    String personId, int patientId) async {
  try {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("children").doc(personId);
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update({"odontofyPatientId": patientId});
      print("Documento actualizado correctamente.");
    } else {
      print("No se encontró un documento con el personId: $personId.");
    }
  } catch (e) {
    print("Error actualizando Firebase: $e");
  }
}
