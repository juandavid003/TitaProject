import 'dart:async';

import 'package:odontobb/models/challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeService {
  ChallengeService();

  Future<List<ChallengeModel>> get() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("challenges")
        .where('active', isEqualTo: true)
        .get();

    List<ChallengeModel> result =
        Challenges.fromJsonMap(querySnapshot.docs).challengeList;

    result.sort((a, b) => a.order!.compareTo(b.order!));
    return result;
  }
}
