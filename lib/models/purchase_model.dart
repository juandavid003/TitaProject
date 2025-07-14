import 'package:cloud_firestore/cloud_firestore.dart';

class Purchases {
  List<PurchaseModel> purchasesList = [];
  Purchases();

  Purchases.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final purchase = PurchaseModel.fromJsonMap(item);
      purchasesList.add(purchase);
    }
  }
}

class PurchaseModel {
  String? id;
  String? userId;
  String? productId;
  double? price;
  String? documentID;
  DateTime? created;
  DateTime? updated;

  PurchaseModel({this.userId, this.productId});

  PurchaseModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    id = item.id;
    userId = json['userId'];
    productId = json['productId'];
    price = json['price'];
  }

  static Map<String, dynamic> toMap(PurchaseModel purchase) {
    return {
      'userId': purchase.userId,
      'productId': purchase.productId,
      'price': purchase.price,
      'created': purchase.created,
      'updated': purchase.updated
    };
  }
}
