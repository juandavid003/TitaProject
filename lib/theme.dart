import 'package:odontobb/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: kDefaultBgColor,
    fontFamily: "Poppins",
    canvasColor: Utils.isDarkMode ? kDarkDefaultBgColor : kDefaultBgColor,
    appBarTheme: appBarTheme(),
    primaryColor: Utils.isDarkMode ? kDarkPrimaryColor : kPrimaryColor,
    primaryColorLight:
        Utils.isDarkMode ? kDarkBlackTextColor : kPrimaryLightColor,
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Colors.transparent),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyLarge: TextStyle(color: kWhiteColor),
    bodyMedium: TextStyle(color: kWhiteColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: kPrimaryColor,
    elevation: 0,
    systemOverlayStyle:
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
    iconTheme: IconThemeData(color: Colors.black),
    toolbarTextStyle: TextStyle(color: kWhiteColor, fontSize: 18),
    // textTheme: TextTheme(
    //   headline6: TextStyle(color: kWhiteColor, fontSize: 18),
    // ),
  );
}
