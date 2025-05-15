// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:odontobb/models/info_model.dart';
import 'package:odontobb/routes.dart';
import 'package:odontobb/screens/app_intro/app_intro_screen.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/info_service.dart';
import 'package:odontobb/services/push_notification_service.dart';
import 'package:odontobb/theme.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/app_builder.dart';
import 'package:odontobb/widgets/bottom_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:odontobb/widgets/custom_elements/custom_dialog_box.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
import 'delegates/app_localizations_delegate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  try {
    // Inicialización de Firebase
    await Firebase.initializeApp();

    // Inicialización de App Check con reCAPTCHA y Play Integrity
    await FirebaseAppCheck.instance.activate(
      androidProvider:
          AndroidProvider.playIntegrity, // Recomendado en Android
      appleProvider: AppleProvider.deviceCheck, // Recomendado en iOS
      webProvider: ReCaptchaV3Provider('43rginfV3wUpcMT7TAWl90AEK'),
    );

    // Inicialización opcional de notificaciones push
      await PushNotificationService.initializeApp();
    //  await FirebaseApi().initNotifications();
    runApp(MainApp());
  } catch (e) {
    print('🔥 Error inicializando Firebase: $e');
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
child: AppBuilder(
        builder: (context) {
          return OverlaySupport( // Aquí se envuelve el MaterialApp
            child: MaterialApp(
              navigatorKey: navigatorPlus.key,
              debugShowCheckedModeBanner: false,
              routes: routes,
              theme: theme(),
              supportedLocales: [
                const Locale('es', ''),
              ],
              locale: Utils.appLocale,
              localizationsDelegates: [
                const AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocaleLanguage in supportedLocales) {
                  if (supportedLocaleLanguage.languageCode ==
                          locale!.languageCode &&
                      supportedLocaleLanguage.countryCode ==
                          locale.countryCode) {
                    return supportedLocaleLanguage;
                  }
                }
                return supportedLocales.first;
              },
              title: 'OdontoBb',
              home: const AuthenticationWrapper(),
            ),
          );
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    //appInfo(context); activar
    Utils.initGreeting = true;
    if (firebaseUser != null) {
      return CustomBottomNavigationBar();
    } else {
      return AppIntroScreen();
    }
  }
}

appInfo(BuildContext context) async {
  //Version de la app instalada
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;

  //Version publicada en las tiendas
  InfoService infoService = InfoService();
  InfoModel info = await infoService.get();

  if ((Platform.isAndroid && version != info.androidVersion) ||
      (Platform.isIOS && version != info.iosVersion)) {
    await _showUpdateDialog(context);
  }
}

_showUpdateDialog(BuildContext context) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: Utils.translate("update_aviable"),
          descriptions: Utils.translate("update_aviable_description"),
          textBtnAcept: Utils.translate("update"),
        );
      }).then((value) async {
    if (Platform.isAndroid) {
      !await launchUrl(
        Uri.parse(
            'https://play.google.com/store/apps/details?id=com.odontobb.athome'),
        mode: LaunchMode.externalApplication,
      );
    } else if (Platform.isIOS) {
      !await launchUrl(
        Uri.parse('https://apps.apple.com/ec/app/odontobb/id1598003877'),
        mode: LaunchMode.externalApplication,
      );
    }
  });
}
