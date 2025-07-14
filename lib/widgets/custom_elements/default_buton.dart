import 'package:odontobb/constant.dart';
import 'package:flutter/material.dart';
import 'normal_text.dart';

// ignore: must_be_immutable
class DefaultButton extends StatefulWidget {
  VoidCallback onPress;
  final String buttonTitle;
  final double width;
  final Color color;
  final double height;

  DefaultButton(
      {super.key,
      required this.onPress,
      required this.buttonTitle,
      this.height = 70,
      this.width = 200,
      this.color = kButtonColor});

  @override
  _DefaultButtonState createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: widget.width,
        height: widget.height,
        child: ElevatedButton(
          onPressed: widget.onPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.height / 4),
              side: BorderSide(color: widget.color),
            ),
            elevation: 2, // Sombra ligera para resaltar
          ),
          child: NormalText(
            text: widget.buttonTitle,
            textColor: Colors.white,
            fontWeight: FontWeight.w400,
            textSize: kNormalFontSize,
          ),
        ));
  }
}
