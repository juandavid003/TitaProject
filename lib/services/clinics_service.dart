import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:odontobb/models/clinics_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicsService {
  ClinicsService();
  final storage = const FlutterSecureStorage();

  Future<List<ClinicsModel>> get() async {
    String code = (await storage.read(key: 'countryCode'))!;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("clinics")
        .where('code', isEqualTo: code)
        .get();

    List<ClinicsModel> result = Clinics.fromJsonMap(querySnapshot.docs).clinicList;
    result.sort((a, b) => a.order!.compareTo(b.order!));

    return [...result];
  }

  Future<bool> isClinicPhone(String code, String phone) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("clinics")
        .where('code', isEqualTo: code)
        .get();

    List<ClinicsModel> result = Clinics.fromJsonMap(querySnapshot.docs).clinicList;

    try {
      ClinicsModel x =
          result.firstWhere((element) => element.phones!.contains(phone));
    } catch (e) {
      return false;
    }
    return true;
  }


Future<List<ClinicsModel>> getClinicById(int globalId) async {
  String code = (await storage.read(key: 'countryCode'))!;

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("clinics")
      .where('code', isEqualTo: code)
      .where('globalId', isEqualTo: globalId)
      .get();

  List<ClinicsModel> result = Clinics.fromJsonMap(querySnapshot.docs).clinicList;
  result.sort((a, b) => a.order!.compareTo(b.order!));

  return [...result];
}



}
