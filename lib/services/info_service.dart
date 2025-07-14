import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odontobb/models/info_model.dart';

class InfoService {
  InfoService();

  Future<InfoModel> get() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("info").get();

    List<InfoModel> result = InfoList.fromJsonMap(querySnapshot.docs).infoList;

    return result.first;
  }
}
