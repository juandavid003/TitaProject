import 'package:cloud_firestore/cloud_firestore.dart';

class DiagnosisModel {
  String? imageUrl;
  String? assistantResponse;
  String? predictionDate;
  List<Map<String, dynamic>>? predictions;

  DiagnosisModel({
    this.imageUrl,
    this.assistantResponse,
    this.predictionDate,
    this.predictions,
  });

  DiagnosisModel.fromJsonMap(QueryDocumentSnapshot<Object?> item) {
    Map<String, dynamic> json = item.data() as Map<String, dynamic>;

    imageUrl = json['image_url'];
    assistantResponse = json['assistant_response'];
    Timestamp timestamp = json['created'];
    predictionDate = timestamp.toDate().toString();

    if (json.containsKey('predictions') && json['predictions'] is List) {
      predictions = List<Map<String, dynamic>>.from(json['predictions']);
    } else {
      predictions = [];
    }
  }
}
