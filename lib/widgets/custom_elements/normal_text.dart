// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NormalText extends StatefulWidget {
  String text;
  Color textColor;
  double textSize;
  FontWeight fontWeight;
  TextDecoration textDecoration;
  TextAlign textAlign;
  TextOverflow textOverflow;
  int? maxLines;
  NormalText(
      {super.key,
      this.text = '',
      this.textSize = 15,
      this.textColor = Colors.black,
      this.textOverflow = TextOverflow.ellipsis,
      this.textDecoration = TextDecoration.none,
      this.fontWeight = FontWeight.w400,
      this.textAlign = TextAlign.start,
      this.maxLines});

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<NormalText> {
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    //widget.textColor = Utils.isDarkMode ? kWhiteColor : kWhiteColor;
    return Text(
      widget.text,
      overflow: widget.textOverflow,
      style: TextStyle(
          fontFamily: "Popins",
          decoration: widget.textDecoration,
          color: widget.textColor,
          fontSize: widget.textSize,
          fontWeight: widget.fontWeight),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
    );
  }
}
