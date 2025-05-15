import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  List<NewsModel> newsList = [];
  News();

  News.fromJsonMap(List<QueryDocumentSnapshot<Object?>> jsonList) {
    for (var item in jsonList) {
      final news = NewsModel.fromJsonMap(item);
      newsList.add(news);
    }
  }
}

class NewsModel {
  int? id;
  String? title;
  String? description;
  String? imageUrl;
  String? image;

  NewsModel({this.title, this.description, this.image, this.imageUrl, this.id});

  NewsModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    title = json['title'];
    description = json['description'];
    image = json['image'];
  }
}
