import 'package:cloud_firestore/cloud_firestore.dart';

class InfoList {
  List<InfoModel> infoList = [];
  InfoList();

  InfoList.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final info = InfoModel.fromJsonMap(item);
      infoList.add(info);
    }
  }
}

class InfoModel {
  String? iosVersion;
  String? androidVersion;

  InfoModel({this.iosVersion, this.androidVersion});

  InfoModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    iosVersion = json['iosVersion'];
    androidVersion = json['androidVersion'];
  }
}
