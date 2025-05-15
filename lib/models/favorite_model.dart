import 'package:cloud_firestore/cloud_firestore.dart';

class Favorites {
  List<FavoriteModel> favoritesList = [];
  Favorites();

  Favorites.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final favorite = FavoriteModel.fromJsonMap(item);
      favoritesList.add(favorite);
    }
  }
}

class FavoriteModel {
  String? id;
  String? userId;
  String? url;
  String? documentID;

  FavoriteModel({this.userId, this.url});

  FavoriteModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    id = item.id;
    userId = json['userId'];
    url = json['url'];
  }

  static Map<String, dynamic> toMap(FavoriteModel favorite) {
    return {
      'userId': favorite.userId,
      'url': favorite.url,
    };
  }
}
