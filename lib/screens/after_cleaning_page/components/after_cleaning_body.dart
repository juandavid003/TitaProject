import 'package:flutter/material.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/tita_prediction_assistant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AfterCleaningBody extends StatefulWidget {
  final bool cameFromBrushing;
  final dynamic selectedChild;

  const AfterCleaningBody(
      {super.key, this.cameFromBrushing = false, this.selectedChild});

  @override
  _AfterCleaningBodyState createState() => _AfterCleaningBodyState();
}

class _AfterCleaningBodyState extends State<AfterCleaningBody> {
  String? imageUrl;
  bool isLoading = true;
  String assistantResponse = "";

  @override
  void initState() {
    super.initState();
    _loadImageUntilAvailable();
  }

  Future<void> _loadImageUntilAvailable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    while (isLoading) {
      String? savedImageUrl = prefs.getString('imageUrl');
      String? savedAssistantResponse = prefs.getString('assistantResponse');

      if (savedImageUrl != null && savedImageUrl != "No disponible") {
        setState(() {
          imageUrl = savedImageUrl;
          assistantResponse = savedAssistantResponse ?? "";
          isLoading = false;
        });

        await prefs.setString('isLoading', "false");

        if (widget.cameFromBrushing) {
          Future.delayed(Duration(seconds: 7), () {
            _finishBrush(context);
          });
        }

        break;
      } else {
        await Future.delayed(Duration(seconds: 1));
      }

      if (savedImageUrl == "No disponible") {
        setState(() {
          isLoading = false;
          imageUrl = null;
          assistantResponse = "No disponible";
          prefs.setString('isLoading', "false");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && !isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Este es solo un diagnóstico de referencia, para un análisis a mayor profundidad le recomendamos agendar una cita.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Zonas de atención")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : imageUrl == null
                ? Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      "Error al diagnosticar su imagen, vuelve a intentarlo",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        imageUrl!,
                        // fit: BoxFit.cover,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.black,
                            alignment: Alignment.center,
                            child: Text(
                              "Error al diagnosticar su imagen, vuelve a intentarlo",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 20,
                        left: 110,
                        right: 0,
                        child: SizedBox(
                          width: 300,
                          child: TitaPredictionAssistantWidget(
                            text: assistantResponse,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  final ChildrenService childrenService = ChildrenService();

  void _finishBrush(BuildContext context) async {
    final PersonModel selected = widget.selectedChild;

    // Agregar solo el niño seleccionado
    await childrenService.addBrushing([selected]);

    // Verificar disponibilidad para acumular puntos
    List<PersonModel> availableChildren =
        await childrenService.childrenBrushingAvailable([selected]);

    if (availableChildren.isNotEmpty) {
      await childrenService.addBBbCashBulk(availableChildren, "tita_brush");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Utils.translate('add_bbcash'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Utils.translate('limited_bbcash_day'))),
      );
    }

    Navigator.pushNamed(context, '/stats_page').then((value) {
      Navigator.pop(context);
    });
  }
}
