// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../constant.dart';

class LineWidget extends StatefulWidget {
  const LineWidget({super.key});

  @override
  _LineWidgetState createState() => _LineWidgetState();
}

class _LineWidgetState extends State<LineWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: kGrayColor,
        height: 0.5,
        width: double.infinity,
      ),
    );
  }
}
