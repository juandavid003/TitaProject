import 'package:cloud_firestore/cloud_firestore.dart';

class Tips {
  List<TipModel> tipList = [];
  Tips();

  Tips.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final tip = TipModel.fromJsonMap(item);
      tipList.add(tip);
    }
  }
}

class TipModel {
  int? id;
  String? title;
  String? description;
  String? bibliographicalCitation;
  String? country;
  String? image;
  String? imageUrl;
  String? category;
  bool? isFavorite;

  TipModel(
      {this.id,
      this.title,
      this.description,
      this.bibliographicalCitation,
      this.country,
      this.image,
      this.imageUrl,
      this.isFavorite,
      this.category});

  TipModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    title = json['name'];
    description = json['description'];
    bibliographicalCitation = json['bibliographicalCitation'];
    category = json['category'];
    image = json['image'];
  }
}
