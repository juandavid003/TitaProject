import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:odontobb/screens/brush_page/components/brush_body.dart';
import 'package:odontobb/screens/brush_page/components/brush_body_ios.dart';
import 'package:odontobb/widgets/base_scaffold.dart';

class BrushScreen extends StatefulWidget {
  const BrushScreen({super.key});

  @override
  State<BrushScreen> createState() => _BrushScreenState();
}

class _BrushScreenState extends State<BrushScreen> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_dialogShown) {
          _dialogShown = true;
          _showChoiceDialog(context);
        }
      });
    }
  }

  void _showChoiceDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      "Selecciona una opción",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '¿Cómo deseas cepillarte?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ArBrushPageIos(),
                              ),
                            );
                          },
                          child: const Text('RA'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BrushPage(),
                              ),
                            );
                          },
                          child: const Text('Video'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BaseScaffold(body: BrushPage());
    }
    // iOS muestra un loader mientras se espera la selección
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}