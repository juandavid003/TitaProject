import 'package:odontobb/constant.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;

  const GradientButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          height: 55.0,
          width: 600.0,
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 15.0)
              ],
              borderRadius: BorderRadius.circular(10.0),
              gradient: const LinearGradient(
                  colors: <Color>[Color(0xFF222831), kAppColor])),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                letterSpacing: 0.2,
                fontFamily: "Sans",
                fontSize: 18.0,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
