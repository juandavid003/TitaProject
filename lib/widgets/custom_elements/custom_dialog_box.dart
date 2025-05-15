// ignore: unnecessary_import
import 'dart:ui';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:flutter/material.dart';
import '../../constant.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, textBtnAcept;
  final Image? img;

  const CustomDialogBox(
      {super.key,
      required this.title,
      required this.descriptions,
      required this.textBtnAcept,
      this.img});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kPadding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: kPadding,
              top: kAvatarRadius + kPadding,
              right: kPadding,
              bottom: kPadding),
          margin: EdgeInsets.only(top: kAvatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(kPadding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NormalText(
                text: widget.title,
                textSize: kTitleFontSize,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: 15,
              ),
              NormalText(
                text: widget.descriptions,
                textSize: kSmallFontSize,
                fontWeight: FontWeight.normal,
                textOverflow: TextOverflow.visible,
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: DefaultButton(
                    buttonTitle: widget.textBtnAcept,
                    onPress: () {
                      Navigator.of(context).pop(true);
                    },
                  )),
            ],
          ),
        )
      ],
    );
  }
}
