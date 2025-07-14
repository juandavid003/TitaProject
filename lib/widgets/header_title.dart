// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../constant.dart';
import '../util.dart';

// ignore: must_be_immutable
class HeaderTitle extends StatefulWidget {
  String bigTitle;
  String subTitle;
  Color color = kBlackFontColor;
  GestureTapCallback onTap;

  HeaderTitle(
      {super.key,
      required this.bigTitle,
      required this.subTitle,
      required this.color,
      required this.onTap});

  @override
  _HeaderTitleState createState() => _HeaderTitleState();
}

class _HeaderTitleState extends State<HeaderTitle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.bigTitle,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Utils.isDarkMode ? kWhiteColor : widget.color,
              fontWeight: FontWeight.w600,
              fontSize: kTitleFontSize),
        ),
        InkWell(
          onTap: widget.onTap,
          child: Text(
            widget.subTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
                color:
                    Utils.isDarkMode ? kGrayColor : kGrayColor.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: kSmallFontSize),
          ),
        ),
      ],
    );
  }
}
