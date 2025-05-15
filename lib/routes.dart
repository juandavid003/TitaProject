import 'package:flutter/material.dart';
import 'package:odontobb/screens/after_cleaning_page/after_cleaning_screen.dart';
import 'package:odontobb/screens/app_intro/app_intro_screen.dart';
import 'package:odontobb/screens/appoitment_page/appoitment_screen.dart';
import 'package:odontobb/screens/before_cleaning_page/before_cleaning_screen.dart';
import 'package:odontobb/screens/children/children_screen.dart';
import 'package:odontobb/screens/create_account_page/create_account_screen.dart';
import 'package:odontobb/screens/diagnosis_page/diagnosis_screen.dart';
import 'package:odontobb/screens/forgot_password_page/forgot_password_screen.dart';
import 'package:odontobb/screens/home_page/home_screen.dart';
import 'package:odontobb/screens/login_page/login_screen.dart';
import 'package:odontobb/screens/main_page/main_screen.dart';
import 'package:odontobb/screens/profile_edit/profile_edit_screen.dart';
import 'package:odontobb/screens/profile_page/profile_page_screen.dart';
import 'package:odontobb/screens/stats_page/stats_screen.dart';
import 'package:odontobb/screens/verification_page/verification_screen.dart';
import 'package:odontobb/widgets/bottom_navigation_bar.dart';

final Map<String, WidgetBuilder> routes = {
  AppIntroScreen.routeName: (context) => AppIntroScreen(),
  MainScreen.routeName: (context) => MainScreen(),
  CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  CustomBottomNavigationBar.routeName: (context) => CustomBottomNavigationBar(),

  HomeScreen.routeName: (context) => HomeScreen(),
  AppoitmentScreen.routeName: (context) => AppoitmentScreen(),
  BeforeCleaningScreen.routeName: (context) => BeforeCleaningScreen(),
  DiagnosisScreen.routeName: (context) => DiagnosisScreen(),
  ChildrenScreen.routeName: (context) => ChildrenScreen(),
  ProfilePageScreen.routeName: (context) => ProfilePageScreen(),
  ProfileEditScreen.routeName: (context) => ProfileEditScreen(),
  StatsScreen.routeName: (context) => StatsScreen(),
    ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  VerificationScreen.routeName: (context) => VerificationScreen('', '', ''),
};
