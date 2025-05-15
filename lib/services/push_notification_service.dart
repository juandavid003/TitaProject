import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/util.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';  // Importar overlay_support

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static String? uid;
  static String? cellphone;

  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
  final entry = showOverlayNotification(
    (context) {
      return NotificationWidget(
        message: message,
        onClose: () => OverlaySupportEntry.of(context)?.dismiss(),
      );
    },
    duration: Duration.zero, // 👈 No se cierra automáticamente
  );

  _messageStream.add(message.data['Hola'] ?? 'No data');
}


  static Future _onMessageOpenApp(RemoteMessage message) async {
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    await requestPermission();
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      token = await FirebaseMessaging.instance.getToken();
      print('Token: $token');
    } else {
      token = null;
      print('Las notificaciones están deshabilitadas. Token establecido en null');
    }

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    setupUser();
  }

  static Future<void> setupUser() async {
    while (Utils.globalFirebaseUser == null ||
        Utils.globalFirebaseUser!.uid == null ||
        Utils.globalFirebaseUser!.phoneNumber == null) {
      await Future.delayed(Duration(milliseconds: 100)); // Espera breve para evitar bloqueos
    }

    uid = Utils.globalFirebaseUser!.uid;
    cellphone = Utils.globalFirebaseUser!.phoneNumber?.replaceFirst('+', '');

    if (uid != null && cellphone != null) {
      await _checkAndUpdateUser(uid!, token, cellphone!);
    }
  }

  static Future<void> _checkAndUpdateUser(String uid, String? token, String cellphone) async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
    DocumentReference userDoc = usersRef.doc(uid);

    DocumentSnapshot userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      var userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        var existingToken = userData['token'];
        if (existingToken == token) {
          print('Token no ha cambiado, no es necesario actualizar.');
          return;
        }
      }
    }
    await userDoc.set(
      {
        "token": token,
        "cellphone": cellphone
      },
      SetOptions(merge: true),
    );
    print('Token actualizado en Firebase.');
    await _upadteOrCreateUserOnOdontofyApi(uid, token, cellphone);
  }

  static Future<void> _upadteOrCreateUserOnOdontofyApi(String uid, String? token, String cellphone) async {
    final response = await http.post(
      Uri.https('odontofy.org', '/OdontoFyWebApi/api/Lead/InsertOrUpdateByPhone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer xaf23BRcO0ImjWcZB9swgpYm_Pel4gLnIU7KyDfeQFOGRaVXprglHBMavD5yLNM8k5f_2VfNoW5qK3C5wsxBNjjF-6qEY1Q8Fs48_Bs6sRNevsUiE11sC74mUArM2iOsk7SOHL6Hll33zIRyLZHGBlCSYomuVYRL_mUGSDHL1Vh_JRlfo9JIM5LOAKRebzJ3zmMXNNiFAtYw0zHdu6IDTLtCQ00kH2nGO-jQMLJmV70kLvLtdV_LsMkN-lwUnx8ZYIMXiWvJ47f5jamUnnRFxfWamoxb3okDQmoYRotix3S51ln0FnelnzEs1PoQQ3Oyhjy_9_43VbxF6m_UtTkszLb245JJMK8t2CLs_9pQsCXZvmHEr9fWLH3GScY1C2VpfDSQtWl3Qb3A7Zg4TMF_SVvWDlKgp2orNOYzRFIdYes02fWsWsM05rtLElyTl7TsEaGJBGeAA-2OW6X3NFQRrPGUQdAtCRfEwE7JtW-WEsbH_HWrTfKWXWYLrsW3D53_'
      },
      body: jsonEncode(<String, dynamic>{
        "Phone": cellphone,
        "TokenApp": token

      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Respuesta del servidor: $responseData");
      return responseData;
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
      throw Exception('Failed to update user in SQL');
    }
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
  }

  static closeStreams() {
    _messageStream.close();
  }
}

// Widget para la notificación
class NotificationWidget extends StatefulWidget {
  final RemoteMessage message;
  final VoidCallback onClose;

  NotificationWidget({required this.message, required this.onClose});

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  bool _expanded = false;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _startAutoCloseTimer();
  }

  void _startAutoCloseTimer() {
    _autoCloseTimer = Timer(Duration(seconds: 5), () {
      if (!_expanded) {
        widget.onClose();
      }
    });
  }

  void _handleTapOutside() {
    if (_expanded) {
      widget.onClose();
    }
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Detecta clics fuera de la notificación
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleTapOutside,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kFacebookColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.notification?.title ?? 'No Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.message.notification?.body ?? 'No data',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: _expanded ? null : 1,
                      overflow: _expanded ? null : TextOverflow.ellipsis,
                    ),
                    if (_expanded && widget.message.notification?.android?.imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.network(
                          widget.message.notification!.android!.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
