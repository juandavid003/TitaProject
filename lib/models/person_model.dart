import 'package:cloud_firestore/cloud_firestore.dart';

class Persons {
  List<PersonModel> personsList = [];
  Persons();

  Persons.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final person = PersonModel.fromJsonMap(item);
      personsList.add(person);
    }
  }
}

class PersonModel {
  String? id;
  int? odontofyPatientId;
  String? name;
  String? lastNames;
  String? sex;
  String? mobile;
  DateTime? dateOfbirth;
  String? parent;
  bool check = false;

  PersonModel(
      {this.name,
      this.lastNames,
      this.sex,
      this.mobile,
      this.dateOfbirth,
      this.odontofyPatientId});

  PersonModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    id = item.id;
    name = json['name'];
    lastNames = json['lastNames'];
    sex = json['sex'];
    mobile = json['mobile'];
    parent = json['parent'];
    odontofyPatientId = json.containsKey('odontofyPatientId') &&
            json['odontofyPatientId'] != null
        ? json['odontofyPatientId']
        : -1;
    Timestamp dOfb = json['dateOfBirth'];
    dateOfbirth = dOfb.toDate();
  }

  static Map<String, dynamic> toMap(PersonModel person) {
    return {
      'name': person.name,
      'lastNames': person.lastNames,
      'sex': person.sex,
      'mobile': person.mobile,
      'dateOfBirth': person.dateOfbirth,
      'parent': person.parent,
      'odontofyPatientId': person.odontofyPatientId
    };
  }
}
