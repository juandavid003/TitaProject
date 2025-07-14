// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, body_might_complete_normally_nullable
import 'dart:convert';
import 'package:odontobb/models/purchase_model.dart';
import 'package:odontobb/screens/verification_page/verification_screen.dart';
import 'package:odontobb/services/purchases_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/bottom_navigation_bar.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final storage = const FlutterSecureStorage();
  final PurchasesService _purchasesService = PurchasesService();

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String?> signIn({String? email, String? password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email!, password: password!);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signInWithCredential(
      {String? verificationId, String? code}) async {
    try {
      PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: code!);

      return "Signed in With Credential";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String?> signUp({String? email, String? password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


// Actualización del método signUpWithCredential para manejar códigos expirados y erróneos
Future<String?> signUpWithCredential(
    {String? verificationId,
    String? code,
    String? name,
    String? email,
    BuildContext? context}) async {
  try {
    // Verificar si el código ha expirado
    String? isExpired = await storage.read(key: 'verification_expired_$verificationId');
    if (isExpired == 'true') {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
          content: Text("El código ha expirado. Solicite uno nuevo."), 
          backgroundColor: Colors.red,
        ),
      );
      return "Code expired";
    }

    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: code!);

    try {
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      Utils.authResult = authResult;

      Navigator.of(context!).pop();
      await updateUserProfile(authResult.user, name, email);

      return "Signed in With Credential";
    } on FirebaseAuthException catch (e) {
      // Manejar específicamente el error de código incorrecto
      if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
            content: Text("Código incorrecto. Inténtelo de nuevo."),
            backgroundColor: Colors.red,
          ),
        );
        return "Invalid code";
      } else {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "Error"),
            backgroundColor: Colors.red,
          ),
        );
        return e.message;
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context!).showSnackBar(
      const SnackBar(
        content: Text("Error"),
        backgroundColor: Colors.red,
      ),
    );
    return "Error";
  }
}


Future<void> verifyPhoneNumber({
  required String phone,
  String? name,
  String? email,
  required BuildContext context,
}) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  
  // Variable para controlar si el código ha expirado
  bool isCodeExpired = false;
  
  try {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) async {
        // Cerrar cualquier diálogo o pantalla anterior, si es necesario
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        try {
          final UserCredential result =
              await auth.signInWithCredential(credential);
          final User? user = result.user;

          if (user != null) {
            // Navegar al siguiente paso si la autenticación fue exitosa
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CustomBottomNavigationBar()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(Utils.translate('error'))),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during sign in: ${e.toString()}')),
          );
        }
      },
      verificationFailed: (FirebaseAuthException exception) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(exception.message ?? 'Verification failed')),
        );
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        // Navegar a la pantalla de verificación
        navigatorPlus.show(VerificationScreen(verificationId, name, email));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Marcar que el código ha expirado
        isCodeExpired = true;
        
        // Almacenar esta información para que pueda ser verificada después
        storage.write(key: 'verification_expired_$verificationId', value: 'true');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("El tiempo de verificación se ha agotado. Solicite un nuevo código."), 
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: ${e.toString()}')),
    );
  }
}


  Future updateUserProfile(
      User? currentUser, String? name, String? email) async {
    if (email != null && email.isNotEmpty && Utils.authResult != null) {
      await Utils.authResult!.user!.updateEmail(email);
    }
    if (name != null && name.isNotEmpty) {
      await currentUser!.updateDisplayName(name);
    }
    await currentUser!.reload();

    //Check if the user is client of OdontoBb
    List<PurchaseModel> appClient = await _purchasesService.getByUserId();
    dynamic result = await isOdontoBbClient(currentUser.phoneNumber);

    if (appClient.isNotEmpty) {
      activeClient(true);
    } else if (result is Map &&
        result.containsKey('Success') &&
        result['Success'] == true) {
      dynamic data = result['Data'];
      final patients = List<dynamic>.from(data);

      if (patients.isNotEmpty) {
        PurchaseModel purchase = PurchaseModel();
        purchase.productId = 'client-odontobb';
        purchase.userId = Utils.globalFirebaseUser!.uid;
        purchase.price = 0;

        _purchasesService.save(purchase).then((value) {
          activeClient(true);
        });
      } else {
        activeClient(false);
      }
    }
  }

  Future<bool> isClient() async {
    final client = await storage.read(key: 'client');
    return client == 'true';
  }

  Future<bool> activeClient(bool active) async {
    await storage.write(key: 'client', value: active.toString());
    return active;
  }

  Future<dynamic> isOdontoBbClient(String? phone) async {
    phone = phone!.replaceAll(Utils.selectCountry!.phoneCode!, '');
    final response = await http.get(
      Uri.https('odontofy.org',
          'OdontoFyWebApi/api/Patients/GetPersonByPhone/$phone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to save appoitment');
    }
  }


Future<String?> getUserPhoneNumber() async {
  User? user = _firebaseAuth.currentUser;
  String? phoneNumber = user?.phoneNumber;

  if (phoneNumber != null) {
    if (phoneNumber.startsWith('+593')) {
      // Quito +593 y agrego el 0 al inicio
      return '0${phoneNumber.substring(4)}';
    }
    // Si no es ecuatoriano, devuelvo el número tal como está
    return phoneNumber;
  }

  return null;
}


}
