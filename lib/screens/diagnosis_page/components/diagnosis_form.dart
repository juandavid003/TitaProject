import 'package:flutter/material.dart';
import 'package:odontobb/models/diagnosis_model.dart';
import 'package:odontobb/screens/after_cleaning_page/after_cleaning_screen.dart';
import 'package:odontobb/screens/appoitment_page/appoitment_screen.dart';
import 'package:odontobb/screens/diagnosis_page/widgets/diagnosis_bar_chart.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';

class DiagnosisForm extends StatefulWidget {
  final DiagnosisModel diagnosis;
  final List<DiagnosisModel> diagnosisList;

  const DiagnosisForm({
    super.key,
    required this.diagnosis,
    required this.diagnosisList,
  });

  @override
  _DiagnosisFormState createState() => _DiagnosisFormState();
}

class _DiagnosisFormState extends State<DiagnosisForm> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Este es solo un diagnóstico de referencia, para un análisis a mayor profundidad le recomendamos agendar una cita.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: InteractiveViewer(
                          panEnabled: true,
                          scaleEnabled: true,
                          child: Image.network(
                            widget.diagnosis.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(kEmptyImage, fit: BoxFit.contain),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Hero(
                  tag: 'image_${widget.diagnosis.predictionDate}',
                  child: Image.network(
                    widget.diagnosis.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(kEmptyImage, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'title_${widget.diagnosis.predictionDate}',
                    child: Align(
                      alignment: Alignment.center,
                      child: NormalText(
                        text: widget.diagnosis.predictionDate ?? "No date available",
                        textSize: kPriceFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Hero(
                    tag: 'subtitle_${widget.diagnosis.predictionDate}',
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.diagnosis.assistantResponse ?? "No assistant response",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: kTitleFontSize,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                
                  SizedBox(
                  height: MediaQuery.of(context).size.height * 0.44, 
                  child: DiagnosisLineChart(
                    diagnosisList: widget.diagnosisList,
                  ),
                ),

                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 45,
                      child: FloatingActionButton(
                        backgroundColor: kButtonColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AppoitmentScreen()),
                          );
                        },
                        child: Text(
                          'Agendar una cita',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

List<Map<String, dynamic>> getAllPredictions(List<DiagnosisModel> diagnosisList) {
  return diagnosisList.expand((d) => d.predictions!).toList();
}

}
