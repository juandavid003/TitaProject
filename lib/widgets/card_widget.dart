import 'package:odontobb/constant.dart';
import 'package:flutter/material.dart';
import '../util.dart';

class CardWidget extends StatefulWidget {
  final Widget childWidget;
  final double height;
  final Color? color; // Agrega un parámetro para el color


  const CardWidget({super.key, required this.childWidget, this.height = 60.0, this.color});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: widget.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: widget.color ?? (Utils.isDarkMode ? kDarkItemColor : const Color.fromARGB(255, 255, 255, 255)), // Usar el color pasado o el predeterminado
          boxShadow: [BoxShadow(blurRadius: 5.0, color: Colors.black12)]),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
      child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: widget.childWidget),
    );
  }
}
