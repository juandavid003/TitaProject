import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/models/diagnosis_model.dart';
import 'package:odontobb/screens/diagnosis_page/components/diagnosis_form.dart'; // Importa la pantalla de destino

class DiagnosisBuilder extends StatefulWidget {
  final List<DiagnosisModel> diagnosisList;
  final int limit;
  final bool isScroll;

  const DiagnosisBuilder({
    super.key,
    required this.diagnosisList,
    required this.limit,
    required this.isScroll,
  });

  @override
  _DiagnosisBuilderState createState() => _DiagnosisBuilderState();
}

class _DiagnosisBuilderState extends State<DiagnosisBuilder> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return widget.diagnosisList.isNotEmpty
        ? Stack(
            children: [
              _listItems(context),
              _createLoading(),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  ListView _listItems(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: widget.isScroll
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      itemCount: widget.diagnosisList.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: _diagnosisCard(widget.diagnosisList[index]),
          ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return DiagnosisForm(
                        diagnosis: widget.diagnosisList[index],
                        diagnosisList: widget.diagnosisList,
                      );
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
                      return FadeTransition(opacity: opacityAnimation, child: child);
                    },
                  ),
                );
              }
        );
      },
    );
  }

  Widget _createLoading() {
    return _isLoading
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CircularProgressIndicator()],
            ),
          )
        : Container();
  }

  Widget _diagnosisCard(DiagnosisModel diagnosis) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      color: kPrimaryLightColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Hero(
          tag: 'image_${diagnosis.predictionDate}', // Hero tag para la imagen
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              diagnosis.imageUrl!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Hero(
          tag: 'title_${diagnosis.predictionDate}', // Hero tag para el título
          child: Text(
            diagnosis.predictionDate ?? "No date available",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        subtitle: Hero(
          tag:
              'subtitle_${diagnosis.predictionDate}', // Hero tag para el subtitle
          child: Text(
            diagnosis.assistantResponse ?? "No assistant response",
            maxLines: 2,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
