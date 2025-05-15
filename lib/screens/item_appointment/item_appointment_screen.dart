import 'package:flutter/material.dart';
import 'package:odontobb/screens/item_appointment/components/item_appointment_body.dart';
import 'package:odontobb/widgets/drawer_widget.dart';

import '../../constant.dart';
import '../../util.dart';

class ItemAppointmentScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  const ItemAppointmentScreen({super.key});

  @override
  _ItemAppointmentScreenState createState() => _ItemAppointmentScreenState();
}

class _ItemAppointmentScreenState extends State<ItemAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kWhiteColor,
      body: ItemAppointmentBody(),
      drawer: DrawerWidget(),
    );
  }
}
