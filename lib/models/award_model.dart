import 'package:cloud_firestore/cloud_firestore.dart';

class Awards {
  List<AwardModel> challengeList = [];
  Awards();

  Awards.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final tip = AwardModel.fromJsonMap(item);
      challengeList.add(tip);
    }
  }
}

class AwardModel {
  String? id;
  String? type;
  String? description;
  int? brushingQuantity;
  int? bbcashQuantity;
  int? visitsQuantity;
  int? stock;
  String? link;
  bool? enable;
  String? image;
  String? imageUrl;
  Timestamp? updated;

  AwardModel(
      {this.type,
      this.link,
      this.description,
      this.enable,
      this.brushingQuantity = 0});

  AwardModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    id = item.id;
    type = json['type'];
    description = json['description'];
    brushingQuantity = json['brushingQuantity'];
    bbcashQuantity = json['bbcashQuantity'];
    visitsQuantity = json['visitsQuantity'];
    stock = json['stock'];
    link = json['link'];
    enable = json['enable'];
    image = json['image'];
    updated = json['updated'];
  }

  AwardModel.fromMap(DocumentSnapshot<Map<String, dynamic>> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    id = item.id;
    type = json['type'];
    description = json['description'];
    brushingQuantity = json['brushingQuantity'];
    bbcashQuantity = json['bbcashQuantity'];
    visitsQuantity = json['visitsQuantity'];
    stock = json['stock'];
    link = json['link'];
    enable = json['enable'];
    image = json['image'];
    updated = json['updated'];
  }

  static Map<String, dynamic> toMap(AwardModel award) {
    return {
      'type': award.type,
      'description': award.description,
      'brushingQuantity': award.brushingQuantity,
      'bbcashQuantity': award.bbcashQuantity,
      'stock': award.stock,
      'link': award.link,
      'enable': award.enable,
      'image': award.image,
      'updated': award.updated
    };
  }
}
