import 'dart:async';
import 'package:odontobb/models/purchase_model.dart';
import 'package:odontobb/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchasesService {
  PurchasesService();

  Future<List<PurchaseModel>> get(String productId) async {
    final String uid = Utils.globalFirebaseUser!.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("purchases")
        .where('userId', isEqualTo: uid)
        .where('productId', isEqualTo: productId)
        .get();

    List<PurchaseModel> result =
        Purchases.fromJsonMap(querySnapshot.docs).purchasesList;

    return result;
  }

  Future<List<PurchaseModel>> getByUserId() async {
    final String uid = Utils.globalFirebaseUser!.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("purchases")
        .where('userId', isEqualTo: uid)
        .get();

    List<PurchaseModel> result =
        Purchases.fromJsonMap(querySnapshot.docs).purchasesList;

    return result;
  }

  Future<void> save(PurchaseModel purchase) async {
    try {
      purchase.updated = DateTime.now();
      if (purchase.id != null) {
        await FirebaseFirestore.instance
            .collection("purchases")
            .doc(purchase.id)
            .update(PurchaseModel.toMap(purchase));
      } else {
        purchase.created = DateTime.now();
        await FirebaseFirestore.instance
            .collection("purchases")
            .add(PurchaseModel.toMap(purchase));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(PurchaseModel person) async {
    try {
      await FirebaseFirestore.instance
          .collection("children")
          .doc(person.id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
