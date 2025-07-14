import 'dart:async';
import 'package:odontobb/helpers/debouncer.dart';
import 'package:odontobb/models/tip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipsService {
  TipsService();

  // ignore: close_sinks
  final StreamController<List<TipModel>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<TipModel>> get suggestionStream =>
      _suggestionStreamController.stream;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  Future<List<TipModel>> tips(int limit, TipModel? lastTip) async {
    DocumentSnapshot? lastTipDocument;

    if (lastTip != null) {
      QuerySnapshot findDocuments = await FirebaseFirestore.instance
          .collection('tips')
          .where('name', isEqualTo: lastTip.title)
          .get();

      lastTipDocument = findDocuments.docs[0];
    }

    QuerySnapshot querySnapshot;
    if (lastTipDocument != null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection("tips")
          .orderBy('name')
          .startAfterDocument(lastTipDocument)
          .limit(limit)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection("tips")
          .orderBy('name')
          .limit(limit)
          .get();
    }

    final tips = Tips.fromJsonMap(querySnapshot.docs);

    return tips.tipList;
  }

  Future<List<TipModel>> searchTips(String query) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tips')
          .orderBy('name')
          .get();

      final tips = Tips.fromJsonMap(querySnapshot.docs);

      List<TipModel> result = tips.tipList.where((element) {
        return element.title!.contains(query) ||
            element.description!.contains(query);
      }).toList();

      return result;
    } catch (e) {
      rethrow;
    }
  }

  void getSuggestionsByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchTips(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
