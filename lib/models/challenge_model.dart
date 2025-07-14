import 'package:cloud_firestore/cloud_firestore.dart';

class Challenges {
  List<ChallengeModel> challengeList = [];
  Challenges();

  Challenges.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final tip = ChallengeModel.fromJsonMap(item);
      challengeList.add(tip);
    }
  }
}

class ChallengeModel {
  String? title;
  bool? active;
  String? query;
  int? brushingQuantity;
  bool show = false;
  int? bbcash;
  int? visits;
  int? order;

  ChallengeModel(
      {this.title,
      this.active,
      this.query,
      this.brushingQuantity = 0,
      this.bbcash = 0,
      this.visits = 0,
      this.order = 0});

  ChallengeModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    title = json['title'];
    query = json['query'];
    brushingQuantity = json['brushingQuantity'];
    bbcash = int.tryParse(json['bbcash'].toString());
    visits = int.tryParse(json['visits'].toString());
    order = json['order'];
  }
}
