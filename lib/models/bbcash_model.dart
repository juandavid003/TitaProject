import 'package:cloud_firestore/cloud_firestore.dart';

class BbCash {
  List<BbCashModel> bbcashs = [];
  BbCash();

  BbCash.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final tip = BbCashModel.fromJsonMap(item);
      bbcashs.add(tip);
    }
  }
}

class BbCashModel {
  String? id;
  String? personId;
  int? cant;
  double? rewardsBalance;
  double? depositedBalance;
  int? visits;
  Timestamp? created;
  Timestamp? updated;
  Timestamp? lastReset;

  BbCashModel({
    this.personId,
    this.cant = 0, // Inicializado en 0
    this.rewardsBalance = 0.0, // Inicializado en 0
    this.depositedBalance = 0.0, 
    this.visits = 0
// Inicializado en 0
  });

  BbCashModel.fromJsonMap(QueryDocumentSnapshot<Object?> item)
      : cant = (item.data() as Map<String, dynamic>)['cant'] ?? 0,
        rewardsBalance = (item.data() as Map<String, dynamic>)['rewardsBalance']
                ?.toDouble() ??
            0.0,
        depositedBalance =
            (item.data() as Map<String, dynamic>)['depositedBalance']
                    ?.toDouble() ??
                0.0 {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    id = item.id;
    personId = json['personId'];
    visits = json['visits'];
    created = json['created'];
    updated = json['updated'];
    lastReset = json['lastReset'];
  }

  static Map<String, dynamic> toMap(BbCashModel person) {
    return {
      'personId': person.personId,
      'cant': person.cant,
      'rewardsBalance': person.rewardsBalance,
      'depositedBalance': person.depositedBalance,
      'visits': person.visits,
      'created': person.created,
      'updated': person.updated,
      'lastReset': person.lastReset
    };
  }
}
