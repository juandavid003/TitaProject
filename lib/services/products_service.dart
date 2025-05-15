import 'dart:async';
import 'package:odontobb/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsService {
  ProductsService();

  Future<List<ProductModel>> get() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("products")
        .where('active', isEqualTo: true)
        .get();

    List<ProductModel> result =
        Products.fromJsonMap(querySnapshot.docs).productList;

    result.sort((a, b) => a.weight!.compareTo(b.weight!));

    return result;
  }
}
