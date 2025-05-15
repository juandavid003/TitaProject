import 'dart:async';
import 'package:odontobb/models/favorite_model.dart';
import 'package:odontobb/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesService {
  FavoritesService();

  Future<List<FavoriteModel>> get(String productId) async {
    final String uid = Utils.globalFirebaseUser!.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("favorites")
        .where('userId', isEqualTo: uid)
        .get();

    List<FavoriteModel> result =
        Favorites.fromJsonMap(querySnapshot.docs).favoritesList;

    return result;
  }

  Future<void> save(FavoriteModel favorite) async {
    try {
      if (favorite.id != null) {
        await FirebaseFirestore.instance
            .collection("favorites")
            .doc(favorite.id)
            .update(FavoriteModel.toMap(favorite));
      } else {
        await FirebaseFirestore.instance
            .collection("favorites")
            .add(FavoriteModel.toMap(favorite));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(FavoriteModel person) async {
    try {
      await FirebaseFirestore.instance
          .collection("favorites")
          .doc(person.id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
