import 'dart:async';
import 'package:odontobb/models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsService {
  NewsService();

  Future<List<NewsModel>> get() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("news")
        .where('active', isEqualTo: true)
        .get();

    List<NewsModel> result = News.fromJsonMap(querySnapshot.docs).newsList;
    return result;
  }
}
