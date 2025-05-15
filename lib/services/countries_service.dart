import 'package:odontobb/models/country_model.dart';
import 'package:odontobb/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CountriesService {
  CountriesService();

  Future<List<CountryModel>> get() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("countries")
        .where('active', isEqualTo: true)
        .get();

    List<CountryModel>? result =
        Countries.fromJsonMap(querySnapshot.docs).countriesList;

    result.sort((a, b) => a.name!.compareTo(b.name!));
    Utils.countryList = result;
    return result;
  }
}
