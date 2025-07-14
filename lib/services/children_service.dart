import 'dart:async';
// ignore: unused_import
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:odontobb/models/award_model.dart';
import 'package:odontobb/models/bbcash_model.dart';
import 'package:odontobb/models/brushing_history_model.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChildrenService {
  final storage = FlutterSecureStorage();

  ChildrenService();

  List<PersonModel> childrenList = [];
  final _childrenStreamController =
      StreamController<List<PersonModel>>.broadcast();

  Function(List<PersonModel>) get childrenSink =>
      _childrenStreamController.sink.add;

  Stream<List<PersonModel>> get childrenStream =>
      _childrenStreamController.stream;

  void disposeStreams() {
    _childrenStreamController.close();
  }

  Future<List<PersonModel>> get() async {
    final String uid = Utils.globalFirebaseUser!.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("children")
        .where('parent', isEqualTo: uid)
        .get();

    List<PersonModel> result =
        Persons.fromJsonMap(querySnapshot.docs).personsList;

    childrenList.addAll(result);
    childrenSink(childrenList);
    return result;
  }

  Future<void> save(PersonModel person) async {
    try {
      if (person.id?.isNotEmpty == true) {
        await FirebaseFirestore.instance
            .collection("children")
            .doc(person.id)
            .update(PersonModel.toMap(person));
      } else {
        await FirebaseFirestore.instance
            .collection("children")
            .add(PersonModel.toMap(person));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(PersonModel person) async {
    try {
      await FirebaseFirestore.instance
          .collection("children")
          .doc(person.id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBrushing(List<PersonModel> childrens) async {
    try {
      childrens.forEach((children) async {
        BrushingHistoryModel hist = BrushingHistoryModel();
        hist.date = DateTime.now();
        hist.personId = children.id;

        await FirebaseFirestore.instance
            .collection("brushing_history")
            .add(BrushingHistoryModel.toMap(hist));
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BrushingHistoryModel>> brushingHistory(String personId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("brushing_history")
          .where("personId", isEqualTo: personId)
          //.orderBy("date", descending: true)
          .get();

      final tips = BrushingHistory.fromJsonMap(querySnapshot.docs);

      return tips.brushingHistory;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> seeBrush() async {
    String brush = await storage.read(key: 'brush') ?? '0';
    int countBrush = int.parse(brush) + 1;
    await storage.write(key: 'brush', value: countBrush.toString());
    return countBrush;
  }

  Future<BbCashModel> getBbCashByPerson(String personId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("bbcash")
          .where("personId", isEqualTo: personId)
          .get();

      final bbcash = BbCash.fromJsonMap(querySnapshot.docs);
      return bbcash.bbcashs.first;
    } catch (e) {
      rethrow;
    }
  }

Future<void> subtractBbCash(String personId, AwardModel bbcashValue) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("bbcash")
        .where("personId", isEqualTo: personId)
        .get();

    final bbcash = BbCash.fromJsonMap(querySnapshot.docs);

    BbCashModel cash = BbCashModel();

    if (bbcash.bbcashs.isNotEmpty) {
      cash = bbcash.bbcashs.first;
      cash.cant = (cash.cant! - bbcashValue.bbcashQuantity!);

      if (bbcashValue.visitsQuantity! > 0) {
        cash.visits = cash.visits! >= bbcashValue.visitsQuantity!
            ? (cash.visits! - bbcashValue.visitsQuantity!)
            : 0;
      }

      cash.rewardsBalance = double.parse((cash.cant! / 100).toStringAsFixed(2));

      cash.updated = Timestamp.now();

      cash.cant = int.parse(cash.cant!.toString());

      await FirebaseFirestore.instance
          .collection("bbcash")
          .doc(cash.id)
          .update(BbCashModel.toMap(cash));
    }
  } catch (e) {
    rethrow;
  }
}

  Future<void> addBBbCash(String personId, String codeScan) async {
    try {
      BbCashModel bbCashValue = getBbCashByCodeScan(codeScan);

      await _updateOrCreateBbCash(personId, bbCashValue);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBBbCashBulk(
      List<PersonModel> childrens, String codeScan) async {
    try {
      BbCashModel bbCashValue = getBbCashByCodeScan(codeScan);

      await Future.wait(childrens
          .map((child) => _updateOrCreateBbCash(child.id!, bbCashValue)));
    } catch (e) {
      rethrow;
    }
  }

Future<void> _updateOrCreateBbCash(
  String personId, BbCashModel bbCashValue) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("bbcash")
      .where("personId", isEqualTo: personId)
      .get();

  final bbcash = BbCash.fromJsonMap(querySnapshot.docs);

  BbCashModel cash = BbCashModel();

  if (bbcash.bbcashs.isNotEmpty) {
    cash = bbcash.bbcashs.first;
    cash.cant = (cash.cant! + bbCashValue.cant!);
    cash.visits = bbCashValue.visits != null && bbCashValue.visits != 0
        ? cash.visits! + bbCashValue.visits!
        : cash.visits!;

    cash.depositedBalance = bbCashValue.depositedBalance! != 0
        ? (cash.depositedBalance! + bbCashValue.depositedBalance!)
        : bbCashValue.depositedBalance!;

      bbCashValue.rewardsBalance = double.parse((bbCashValue.cant! / 100).toStringAsFixed(2));
      cash.rewardsBalance = double.parse((cash.rewardsBalance! + bbCashValue.rewardsBalance!).toStringAsFixed(2));


    cash.updated = Timestamp.now();
  } else {
    cash.cant = bbCashValue.cant!;
    cash.personId = personId;
    cash.created = Timestamp.now();
    cash.rewardsBalance = double.parse((cash.cant! / 100).toStringAsFixed(2));
    cash.visits = bbCashValue.visits;
  }

  cash.cant = int.parse(cash.cant!.toString());

  if (cash.id?.isNotEmpty == true) {
    await FirebaseFirestore.instance
        .collection("bbcash")
        .doc(cash.id)
        .update(BbCashModel.toMap(cash));
  } else {
    await FirebaseFirestore.instance
        .collection("bbcash")
        .add(BbCashModel.toMap(cash));
  }
}

  BbCashModel getBbCashByCodeScan(String codeScan) {
    BbCashModel bbCash = BbCashModel();

    switch (codeScan) {
      case "odontobb_appt": // visita a la consulta
        bbCash.cant = 50;
        bbCash.visits = 1;
        break;
      case "external_input": // compra de un insumo odontológico
        bbCash.cant = 10;
        break;
      case "odontobb_digital": // compra de un producto digital de OdontoBb
        bbCash.cant = 10;
        break;
      case "tita_brush": // cepillado usando tita
        bbCash.cant = 1;
        break;
      default:
        bbCash.cant = 0;
        break;
    }
    return bbCash;
  }

  int cantPerDay(List<BrushingHistoryModel> brushingHistoryWeek) {
    DateTime start = DateTime.now().subtract(Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second));

    List<BrushingHistoryModel> brushingHistoryDay = [];

    brushingHistoryDay = brushingHistoryWeek.where((element) {
      return (element.date!.isAfter(start) &&
          element.date!.isBefore(start.add(const Duration(days: 1))));
    }).toList();

    return brushingHistoryDay.length;
  }

  Future<List<PersonModel>> childrenBrushingAvailable(
      List<PersonModel> childrensSelected) async {
    try {
      List<PersonModel> result = [];

      for (int i = 0; i < childrensSelected.length; i++) {
        PersonModel children = childrensSelected[i];

        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, now.month, now.day);
        QuerySnapshot querySnapshotBrushingHistory = await FirebaseFirestore
            .instance
            .collection("brushing_history")
            .where('date', isGreaterThanOrEqualTo: date)
            .get();

        List<BrushingHistoryModel> brushingHistory =
            BrushingHistory.fromJsonMap(querySnapshotBrushingHistory.docs)
                .brushingHistory;

        brushingHistory = brushingHistory
            .where((element) => element.personId == children.id)
            .toList();

        if (brushingHistory.length <= 2) {
          result.add(children);
        }
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
