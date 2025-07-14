// ignore_for_file: unused_import

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Clinics {
  List<ClinicsModel> clinicList = [];
  Clinics();

  Clinics.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final clinic = ClinicsModel.fromJsonMap(item);
      clinicList.add(clinic);
    }
  }
}

class ClinicsModel {
  int? value;
  String? name;
  String? address;
  String? code;
  int? order;
  String? image;
  String? imageUrl;
  String? googleMapsUrl;
  List<String>? phones;

  ClinicsModel({this.value, this.name});

  ClinicsModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    value = json['globalId'];
    name = json['name'];
    code = json['code'];
    order = json['order'];
    image = json['image'];
    address = json['address'];
    googleMapsUrl = json['googleMapsUrl'];
    phones = (json['phones'] as List).map((item) => item as String).toList();
  }
}
