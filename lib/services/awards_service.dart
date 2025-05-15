import 'dart:async';
import 'dart:math';
import 'package:odontobb/models/award_history_model.dart';
import 'package:odontobb/models/award_model.dart';
import 'package:odontobb/models/challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AwardsService {
  AwardsService();

  final _random = Random();

  Future<AwardModel> get(String awardId) async {
    try {
      final award = await FirebaseFirestore.instance
          .collection("adwards")
          .doc(awardId)
          .get();

      return AwardModel.fromMap(award);
    } catch (e) {
      rethrow;
    }
  }

  Future<AwardModel> getByValue(ChallengeModel challenge) async {
    QuerySnapshot querySnapshot;

    if (challenge.query == 'bbcash') {
      querySnapshot = await FirebaseFirestore.instance
          .collection("adwards")
          .where("bbcashQuantity", isEqualTo: challenge.bbcash)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection("adwards")
          .where("brushingQuantity",
              isGreaterThanOrEqualTo: challenge.brushingQuantity)
          .get();
    }

    int posRandom = next(0, querySnapshot.docs.length);
    List<AwardModel> result =
        Awards.fromJsonMap(querySnapshot.docs).challengeList;

    return result[posRandom];
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  Future<AwardHistoryModel> registreAward(
      String personId, String awardId) async {
    try {
      // update award in stock
      final award = await FirebaseFirestore.instance
          .collection("adwards")
          .doc(awardId)
          .get();

      AwardModel awardUpdate = AwardModel();
      awardUpdate = AwardModel.fromMap(award);
      awardUpdate.stock = (awardUpdate.stock! - 1);
      awardUpdate.updated = Timestamp.now();

      await FirebaseFirestore.instance
          .collection("adwards")
          .doc(awardUpdate.id)
          .update(AwardModel.toMap(awardUpdate));

      // Add award history
      AwardHistoryModel awardHistory = AwardHistoryModel();
      awardHistory.personId = personId;
      awardHistory.awardId = awardId;
      awardHistory.created = Timestamp.now();

      await FirebaseFirestore.instance
          .collection("award_history")
          .add(AwardHistoryModel.toMap(awardHistory));

      return awardHistory;
    } catch (e) {
      rethrow;
    }
  }
}
