import 'dart:io';
import 'package:odontobb/constant.dart';
import 'package:odontobb/services/countries_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/app_localizations.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'models/country_model.dart';

class Utils {
  static double? totalPrice;
  static BuildContext? globalContext;
  static User? globalFirebaseUser;
  static UserCredential? authResult;
  static bool isDarkMode = false;
  static Locale appLocale = const Locale("es", "EC");
  static CountryModel? selectCountry;
  static bool initGreeting = false;
  CountriesService countriesService = CountriesService();

  static bool textisRTL(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    return currentDirection == TextDirection.rtl;
  }

  static Size size(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static Color getColorMode() {
    return Utils.isDarkMode ? kWhiteColor : kBlackFontColor;
  }

  static Color getColorModeBlock() {
    return Utils.isDarkMode ? kWhiteColorBlok : kBlackFontColorBlock;
  }

  static List<CountryModel>? countryList;

  static int loadingTime = 1;
  static int currentIndex = 0;

  static Color? getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }

  static String translate(String text) {
    return ApplicationLocalizations.of(navigatorPlus.currentContext)!
        .translate(text)!;
  }

  static Future<File?> imgFromGallery() async {
    final picker = ImagePicker();
    var image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 200,
        maxWidth: 200);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  static Future<File?> imgFromCamera() async {
    final picker = ImagePicker();
    var image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 200,
        maxWidth: 200);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  String? validateMobile(String value) {
    String patttern = r'[0-9]';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  static const int tinyHeightLimit = 100;
  static const int tinyLimit = 270;
  static const int phoneLimit = 550;
  static const int tabletLimit = 810;
  static const int largeTabletLimit = 1100;

  static bool isTinyHeightLimit(BuildContext context) =>
      MediaQuery.of(context).size.height < tinyHeightLimit;

  static bool isTinyLimit(BuildContext context) =>
      MediaQuery.of(context).size.width < tinyLimit;

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneLimit &&
      MediaQuery.of(context).size.width >= tinyLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit &&
      MediaQuery.of(context).size.width >= phoneLimit;

  static bool isLargeTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < largeTabletLimit &&
      MediaQuery.of(context).size.width >= tabletLimit;

  static bool isComputer(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeTabletLimit;

//Definir todos los tamannos de pantalla
  //Crear una relacion de ancho y alto segun cada caso
  static const dps320 = 320;
  static const dps360 = 360;
  static const dps384 = 384;
  static const dps412 = 412;
  static const dps610 = 610;
  static const dps674 = 674;
  static const dps839 = 839;

//IPHONE
  static const dps375 = 375;
  static const dps414 = 414;
  static const dps390 = 390;
  static const dps428 = 428;
  static const dps393 = 393;
  static const dps430 = 430;

//PX 240 - 320 - 480
  static Size tamanoTita(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 318 &&
        MediaQuery.of(context).size.width <= dps320) {
      return Size(MediaQuery.of(context).size.width * 0.49,
          MediaQuery.of(context).size.height * 0.50);
    }
//PX 720
    if (MediaQuery.of(context).size.width >= 358 &&
        MediaQuery.of(context).size.width <= dps360) {
      return Size(MediaQuery.of(context).size.width * 0.5,
          MediaQuery.of(context).size.height * 0.5);
    }
// PX 1080 - 1440
    if (MediaQuery.of(context).size.width >= 410 &&
        MediaQuery.of(context).size.width <= dps412) {
      return Size(MediaQuery.of(context).size.width * 0.52,
          MediaQuery.of(context).size.height * 0.455);
    }
// PX 768
    if (MediaQuery.of(context).size.width >= 382 &&
        MediaQuery.of(context).size.width <= dps384) {
      return Size(MediaQuery.of(context).size.width * 0.55,
          MediaQuery.of(context).size.height * 0.55);
    }
// PX 1768
    if (MediaQuery.of(context).size.width >= 672 &&
        MediaQuery.of(context).size.width <= dps674) {
      return Size(MediaQuery.of(context).size.width * 0.5,
          MediaQuery.of(context).size.height * 0.7);
    }
// PX 2200
    if (MediaQuery.of(context).size.width >= 837 &&
        MediaQuery.of(context).size.width <= dps839) {
      return Size(MediaQuery.of(context).size.width * 0.5,
          MediaQuery.of(context).size.height * 0.75);
    }
// PX 1600
    if (MediaQuery.of(context).size.width >= 608 &&
        MediaQuery.of(context).size.width <= dps610) {
      return Size(MediaQuery.of(context).size.width * 0.5,
          MediaQuery.of(context).size.height * 0.6);
    }

// IPHONE
    if (MediaQuery.of(context).size.width >= 373 &&
        MediaQuery.of(context).size.width <= dps375) {
      return Size(MediaQuery.of(context).size.width * 0.55,
          MediaQuery.of(context).size.height * 0.55);
    }
    if (MediaQuery.of(context).size.width >= 412 &&
        MediaQuery.of(context).size.width <= dps414) {
      return Size(MediaQuery.of(context).size.width * 0.52,
          MediaQuery.of(context).size.height * 0.45);
    }
    if (MediaQuery.of(context).size.width >= 388 &&
        MediaQuery.of(context).size.width <= dps390) {
      return Size(MediaQuery.of(context).size.width * 0.6,
          MediaQuery.of(context).size.height * 0.6);
    }
    if (MediaQuery.of(context).size.width >= 426 &&
        MediaQuery.of(context).size.width <= dps428) {
      return Size(MediaQuery.of(context).size.width * 0.5,
          MediaQuery.of(context).size.height * 0.5);
    }
    if (MediaQuery.of(context).size.width >= 391 &&
        MediaQuery.of(context).size.width <= dps393) {
      return Size(MediaQuery.of(context).size.width * 0.5,
          MediaQuery.of(context).size.height * 0.5);
    }
    if (MediaQuery.of(context).size.width >= 428 &&
        MediaQuery.of(context).size.width <= dps430) {
      return Size(MediaQuery.of(context).size.width * 0.53,
          MediaQuery.of(context).size.height * 0.46);
    }
    return MediaQuery.of(context).size;
  }
}
