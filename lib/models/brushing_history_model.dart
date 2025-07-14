import 'package:cloud_firestore/cloud_firestore.dart';

class BrushingHistory {
  List<BrushingHistoryModel> brushingHistory = [];
  BrushingHistory();

  BrushingHistory.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final tip = BrushingHistoryModel.fromJsonMap(item);
      brushingHistory.add(tip);
    }
  }
}

class BrushingHistoryModel {
  String? personId;
  DateTime? date;

  BrushingHistoryModel({this.personId, this.date});

  BrushingHistoryModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    personId = json['personId'];
    Timestamp dOfb = json['date'];
    date = dOfb.toDate();
  }

  static Map<String, dynamic> toMap(BrushingHistoryModel person) {
    return {'personId': person.personId, 'date': person.date};
  }
}
