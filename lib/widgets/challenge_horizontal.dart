// ignore_for_file: use_build_context_synchronously

import 'package:odontobb/constant.dart';
import 'package:odontobb/models/award_model.dart';
import 'package:odontobb/models/bbcash_model.dart';
import 'package:odontobb/models/brushing_history_model.dart';
import 'package:odontobb/models/challenge_model.dart';
import 'package:odontobb/models/video_model.dart';
import 'package:odontobb/screens/item_award/item_award_screen.dart';
import 'package:odontobb/services/awards_service.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/card_widget.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:flutter/material.dart';

//typedef void StringCallback();
typedef StringCallback = void Function();

class ChallengeHorizontal extends StatefulWidget {
  final List<ChallengeModel> challenges;
  final List<BrushingHistoryModel> brushingHistory;
  final BbCashModel bbCash;
  final StringCallback? callback;

  const ChallengeHorizontal(
      {super.key,
      required this.challenges,
      required this.brushingHistory,
      required this.bbCash,
      this.callback});

  @override
  _ChallengeHorizontalState createState() => _ChallengeHorizontalState();
}

class _ChallengeHorizontalState extends State<ChallengeHorizontal> {
  AwardsService awardsService = AwardsService();

  @override
  void initState() {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
    getInfo();
  }

  getInfo() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Utils.size(context).height * 0.15,
      child: PageView(
        pageSnapping: true,
        padEnds: false,
        controller: PageController(initialPage: 0, viewportFraction: 0.4),
        children: _cards(context),
      ),
    );
  }

  List<Widget> _cards(BuildContext context) {
    return widget.challenges.map((challenge) {
      return _cardAward(challenge, context);
    }).toList();
  }

  Container _cardAward(ChallengeModel challenge, BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 15.0),
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          child: CardWidget(
            childWidget: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                activeAward(widget.brushingHistory, challenge, widget.bbCash)
                    ? const Icon(Icons.verified_outlined,
                        size: 40.0, color: kButtonColor)
                    : Icon(Icons.lock_outline,
                        size: 40.0, color: Utils.getColorModeBlock()),
                const SizedBox(
                  height: 10.0,
                ),
                NormalText(
                  text: challenge.title!,
                  textSize: kExtraMicroFontSize,
                  textOverflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
                !activeAward(widget.brushingHistory, challenge, widget.bbCash)
                    ? Column(
                        children: [
                          NormalText(
                              text: _getRequirement(challenge),
                              textSize: kExtraExtraMicroFontSize,
                              textOverflow: TextOverflow.visible,
                              textColor: kButtonColor,
                              fontWeight: FontWeight.w500),
                          challenge.visits?.isFinite == true
                              ? NormalText(
                                  text:
                                      '${challenge.visits!.toString()}  ${Utils.translate("visits")}',
                                  textSize: kExtraExtraMicroFontSize,
                                  textOverflow: TextOverflow.visible,
                                  textColor: kAppColor,
                                  fontWeight: FontWeight.w500)
                              : Container()
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          onTap: () async {
            if (activeAward(widget.brushingHistory, challenge, widget.bbCash)) {
              AwardModel award = await awardsService.getByValue(challenge);

              switch (award.type) {
                case 'video':
                  VideoModel video = VideoModel(
                      award.link!,
                      Utils.translate("award-of-the-day"),
                      Utils.translate("alert"));

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Container(); //return WebViewWidget(videoModel: video);
                    }),
                  );
                  break;
                // case 'physical':
                //   //Mostrar pantalla de premio fisico con boton de lo quiero que descuenta de la base de datos la existencia

                //   award.imageUrl =
                //       await FileService.loadImage('tips/${award.image!}');

                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) {
                //       return ItemAwardScreen(
                //           personId: widget.bbCash.personId,
                //           awardId: award.id,
                //           title: challenge.title!,
                //           description: award.description,
                //           imageUrl: award.imageUrl,
                //           cantBbCash: award.bbcashQuantity);
                //     }),
                //   ).then((value) {
                //     widget.callback!();
                //   });
                //   break;
              }
            }
          },
        ));
  }

  bool activeAward(List<BrushingHistoryModel> brushingHistory,
      ChallengeModel challenge, BbCashModel bbCash) {
    List<BrushingHistoryModel> brushingHistoryFilter = [];
    if (brushingHistory.isNotEmpty) {
      switch (challenge.query) {
        case "daily":
          DateTime end = DateTime.now();
          DateTime start = DateTime.now()
              .subtract(Duration(hours: end.hour, minutes: end.minute));

          brushingHistoryFilter =
              filterBrushingHistory(brushingHistory, start, end);

          break;
        case "weekly":
          DateTime end = DateTime.now();
          DateTime start = DateTime.now().subtract(Duration(days: 7));
          brushingHistoryFilter =
              filterBrushingHistory(brushingHistory, start, end);
          break;
        case "monthly":
          DateTime end = DateTime.now();
          DateTime start = DateTime.now().subtract(Duration(days: end.day));

          brushingHistoryFilter =
              filterBrushingHistory(brushingHistory, start, end);
          break;
        case "desc":
          DateTime initDate = DateTime.now();
          for (var element in brushingHistory) {
            if ((initDate.day - element.date!.day) <= 1) {
              brushingHistoryFilter.add(element);
              initDate = element.date!;
            } else {
              continue;
            }
          }
          break;
        case "total":
          brushingHistoryFilter = brushingHistory;
          break;
        case "bbcash":
          return bbCash.cant! >= challenge.bbcash! &&
              bbCash.visits! >= challenge.visits!;
        default:
      }
    } else {
      return false;
    }
    return brushingHistoryFilter.length >= challenge.brushingQuantity!;
  }

  List<BrushingHistoryModel> filterBrushingHistory(
      List<BrushingHistoryModel> brushingHistoryFilter,
      DateTime start,
      DateTime end,
      {String? order}) {
    return brushingHistoryFilter.where((element) {
      return (element.date!.isAfter(start) && element.date!.isBefore(end));
    }).toList();
  }

  _getRequirement(ChallengeModel challenge) {
    if (challenge.bbcash != null && challenge.bbcash! > 0) {
      return "${challenge.bbcash?.toString() ?? ""} BbCash";
    } else {
      return challenge.brushingQuantity == 1
          ? "${challenge.brushingQuantity?.toString() ?? ""} Cepillado"
          : "${challenge.brushingQuantity?.toString() ?? ""} Cepillados";
    }
  }
}
