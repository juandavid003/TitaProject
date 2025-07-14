import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:odontobb/constant.dart';
import '../util.dart';

class TitaPredictionAssistantWidget extends StatefulWidget {
  final String text;

  const TitaPredictionAssistantWidget({super.key, required this.text});

  @override
  _TitaPredictionAssistantWidgetState createState() =>
      _TitaPredictionAssistantWidgetState();
}

class _TitaPredictionAssistantWidgetState
    extends State<TitaPredictionAssistantWidget> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    if (widget.text.isNotEmpty) {
      _setLanguageToSpanish();
      _speak();
    }
  }

  Future<void> _setLanguageToSpanish() async {
    await flutterTts.setLanguage('es-ES');
  }

  Future<void> _speak() async {
    await flutterTts.speak(widget.text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.0),
          bottomLeft: Radius.circular(14.0),
        ),
        color: Utils.isDarkMode ? kDarkItemColor : kDarkFacebookColor,
        boxShadow: [BoxShadow(blurRadius: 5.0, color: Colors.black12)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              widget.text,
              style: TextStyle(fontSize: 15, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 10),
          Image.asset('assets/images/tita_face_only.png', width: 60),
        ],
      ),
    );
  }
}
