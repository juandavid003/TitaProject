import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:odontobb/widgets/page_title.dart';
import 'package:odontobb/widgets/textFileld_builder.dart';
import '../../../util.dart';

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({super.key});

  @override
  _ChangePasswordBodyState createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            PageTitle(Utils.translate("change_pass")),
            SizedBox(
              height: 30.0,
            ),
            InputTextField(
                bgColor: Utils.isDarkMode ? kDarkItemColor : kItemBgColor,
                placeHolder: Utils.translate("password"),
                icon: Icons.vpn_key_rounded),
            SizedBox(
              height: 20.0,
            ),
            InputTextField(
                bgColor: Utils.isDarkMode ? kDarkItemColor : kItemBgColor,
                placeHolder: Utils.translate("confirm_password"),
                icon: Icons.vpn_key_rounded),
            SizedBox(
              height: 20.0,
            ),
            DefaultButton(
              buttonTitle: Utils.translate("save"),
              onPress: () {
                navigatorPlus.back();
              },
            )
          ],
        ),
      ),
    );
  }
}
