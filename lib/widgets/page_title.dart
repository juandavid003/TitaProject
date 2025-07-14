import 'package:flutter/material.dart';

import '../constant.dart';
import '../util.dart';
import 'custom_elements/normal_text.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 40.0,
            color: Utils.isDarkMode ? kWhiteColor : kDarkPrimaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        NormalText(
          text: title,
          textSize: kTitleFontSize,
          fontWeight: FontWeight.w400,
        )
      ],
    );
  }
}
