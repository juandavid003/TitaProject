import 'package:cloud_firestore/cloud_firestore.dart';

class Countries {
  List<CountryModel> countriesList = [];
  Countries();

  Countries.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final clinic = CountryModel.fromJsonMap(item);
      countriesList.add(clinic);
    }
  }
}

class CountryModel {
  String? code;
  String? name;
  String? emoji;
  String? phoneCode;

  CountryModel({this.code, this.name, this.emoji, this.phoneCode});

  CountryModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    code = json['code'];
    name = json['name'];
    emoji = json['emoji'];
    phoneCode = json['phoneCode'];
  }
}
