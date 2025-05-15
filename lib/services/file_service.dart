import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FileService extends ChangeNotifier {
  FileService();

  static Future<String> loadImage(String fileName) async {
    List<String> paths = fileName.split('/');
    if (paths.length > 0 && !paths[1].contains('null')) {
      return await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .getDownloadURL();
    } else {
      return "";
    }
  }

  static Future<Map<String, String>> uploadImage(
      File imageFile, String personId) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('isLoading', 'true');

      Map<String, String> body = {"image": base64Image, "personId": personId};

      final response = await http.post(
        Uri.parse('https://fastapi-yolo-api-220j.onrender.com/predict/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));  // Decodificación UTF-8 explícita
        String imageUrl = jsonResponse['image_url'];
        String assistantResponse = jsonResponse['assistant_response'];

        await prefs.setString('imageUrl', imageUrl);
        await prefs.setString('assistantResponse', assistantResponse);
        await prefs.setString('isLoading', 'true');

        return {
          'imageUrl': imageUrl,
          'assistantResponse': assistantResponse,
        };
      } else {
        throw Exception('Error en la API: ${response.statusCode}');
      }

    } catch (e) {
      print('Error al subir la imagen: $e');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imageUrl', 'No disponible');
      await prefs.setString('assistantResponse', 'No disponible');
      await prefs.setString('isLoading', 'true');

      return {
        'imageUrl': 'No disponible',
        'assistantResponse': 'No disponible'
      };
    }
  }

  //   static Future<String> generateAssistantResponse(dynamic jsonResponse) async {
  //   Map<String, int> classNameCount = {};
  //   Map<String, double> classNameConfidence = {};

  //   for (var prediction in jsonResponse['predictions']) {
  //     String className = prediction['class_name'];
  //     double confidence = prediction['confidence'];

  //     if (classNameCount.containsKey(className)) {
  //       classNameCount[className] = classNameCount[className]! + 1;
  //       if (confidence > classNameConfidence[className]!) {
  //         classNameConfidence[className] = confidence;
  //       }
  //     } else {
  //       classNameCount[className] = 1;
  //       classNameConfidence[className] = confidence;
  //     }
  //   }

  //   List<String> content = [];
  //   classNameCount.forEach((className, count) {
  //     content.add('La probabilidad de tener $className en $count de tus dientes es del ${classNameConfidence[className]!.toStringAsFixed(2)}%.');
  //   });

  //   content.add('Te recomiendo una visita a OdontoBB para un diagnóstico personalizado y a mayor profundidad.');

  //   return content.join(' ');
  // }
}
