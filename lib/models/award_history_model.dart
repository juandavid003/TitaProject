import 'package:cloud_firestore/cloud_firestore.dart';

class AwardsHistory {
  List<AwardHistoryModel> challengeList = [];
  AwardsHistory();

  AwardsHistory.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final tip = AwardHistoryModel.fromJsonMap(item);
      challengeList.add(tip);
    }
  }
}

class AwardHistoryModel {
  String? personId;
  String? awardId;
  Timestamp? created;

  AwardHistoryModel({this.personId, this.awardId, this.created});

  AwardHistoryModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    personId = json['personId'];
    awardId = json['awardId'];
    Timestamp dOfb = json['created'];
    created = dOfb;
  }

  static Map<String, dynamic> toMap(AwardHistoryModel awardHistory) {
    return {
      'personId': awardHistory.personId,
      'awardId': awardHistory.awardId,
      'created': awardHistory.created
    };
  }

  String toStringModel() {
    return 'award=personId:${personId!},awardId:${awardId!},created:${created!}';
  }
}
