import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  List<ProductModel> productList = [];
  Products();

  Products.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final product = ProductModel.fromJsonMap(item);
      productList.add(product);
    }
  }
}

class ProductModel {
  String? id;
  String? title;
  String? description;
  String? category;
  String? image;
  String? imageUrl;
  String? videoPrev;
  String? linkDemo;
  String? linkProduct;
  double? price;
  bool? forClients;
  String? documentID;
  int? weight;

  ProductModel(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.image,
      this.imageUrl,
      this.videoPrev,
      this.linkProduct,
      this.price,
      this.forClients,
      this.weight});

  ProductModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;
    id = item.id;
    title = json['title'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    videoPrev = json['videoPrev'];
    linkDemo = json['linkDemo'];
    linkProduct = json['linkProduct'];
    price = json['price'];
    forClients = json['forClients'];
    weight = json['weight'];
  }
}
