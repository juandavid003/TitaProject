import 'package:flutter/material.dart';
import 'package:odontobb/screens/brush_page/brush_screen.dart';
import 'package:odontobb/screens/e_learning/e_learning.dart';
import 'package:odontobb/screens/did_you_know_page/did_you_know_screen.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/screens/appoitment_page/appoitment_screen.dart';
import 'package:odontobb/screens/home_page/home_screen.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import '../util.dart';
import 'fab_bottom_appbar.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  static const String routeName = "/bottom_nav_bar";
  @override
  _customBottomNavigationBarState createState() =>
      _customBottomNavigationBarState();

  const CustomBottomNavigationBar({super.key});
}

class _customBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  // Set a type current number a layout class
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return HomeScreen();
      case 1:
        return AppoitmentScreen();
      case 2:
        return ELearningScreen(); // StatsScreen();
      case 3:
        return DidYouKnowScreen();
      default:
        return HomeScreen();
    }
  }

  /// Build BottomNavigationBar Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Utils.isDarkMode ? kDarkBgColor.withOpacity(0.8) : Color(0xFFF1F1F1),
      body: callPage(Utils.currentIndex),
      bottomNavigationBar: Container(
        color: Utils.isDarkMode ? kDarkBgColor : kWhiteColor,
        height: 80,
        child: FABBottomAppBar(
          notchedShape: const CircularNotchedRectangle(),
          iconSize: 22,
          backgroundColor:
              Utils.isDarkMode ? kDarkItemColor : const Color(0xFFF1F1F1),
          color: Utils.isDarkMode ? kGrayColor : kBottomIconColor,
          selectedColor: Utils.isDarkMode ? kWhiteColor : kAppColor,
          onTabSelected: (index) {
            setState(() {
              Utils.currentIndex = index;
            });
          },
          items: [
            FABBottomAppBarItem(iconData: "assets/icons/home.svg", text: ''),
            FABBottomAppBarItem(
                iconData: "assets/icons/insert_invitation_black_24dp.svg",
                text: ''),
            FABBottomAppBarItem(
                iconData: "assets/icons/bookmark.svg", text: 'Padres'),
            FABBottomAppBarItem(
                iconData: "assets/icons/quiz_black_24dp.svg", text: ''),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kButtonColor,
        onPressed: () {
          navigatorPlus.showModal(BrushScreen());
          // navigatorPlus.showModal(BeforeCleaningBody());
        },
        elevation: 5.0,
        child: const Icon(
          Icons.history_toggle_off,
          size: 50,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
