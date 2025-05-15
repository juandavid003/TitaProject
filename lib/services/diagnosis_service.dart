import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odontobb/models/diagnosis_model.dart';
import 'package:intl/intl.dart';

class DiagnosisService {
  DiagnosisService();

  static Future<List<DiagnosisModel>> getDiagnosisData(String personId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore
          .collection('predictions')
          .where('personId', isEqualTo: personId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<DiagnosisModel> diagnoses = [];

        for (var document in querySnapshot.docs) {
          var data = document.data() as Map<String, dynamic>;
          String imageUrl = data['image_url'];
          String assistantResponse = data['assistant_response'] ?? "No Response";
          Timestamp timestamp = data['created'];

          DateTime dateTime = timestamp.toDate();
          String formattedDate = DateFormat('d MMMM yyyy HH:mm:ss', 'es_ES').format(dateTime);

          // Obtener y mapear la lista de predicciones directamente como Map
          List<Map<String, dynamic>> predictions = [];
          if (data['predictions'] != null) {
            for (var pred in data['predictions']) {
              predictions.add({
                'class_name': pred['class_name'],
                'confidence': pred['confidence'].toDouble(),
                'coordinates': pred['coordinates'] ?? {},
              });
            }
          }

          // Crear el objeto DiagnosisModel con las predicciones
          DiagnosisModel diagnosis = DiagnosisModel(
            imageUrl: imageUrl,
            assistantResponse: assistantResponse,
            predictionDate: formattedDate,
            predictions: predictions,
          );

          diagnoses.add(diagnosis);
        }

        // Ordenar por fecha
        diagnoses.sort((b, a) {
          DateTime dateA = DateFormat('d MMMM yyyy HH:mm:ss', 'es_ES').parse(a.predictionDate!);
          DateTime dateB = DateFormat('d MMMM yyyy HH:mm:ss', 'es_ES').parse(b.predictionDate!);
          return dateA.compareTo(dateB);
        });

        return diagnoses;
      } else {
        throw Exception('Prediction not found');
      }
    } catch (e) {
      print('Error fetching prediction data: $e');
      return [];
    }
  }
}
