// ignore_for_file: unused_field, must_be_immutable, unused_import, library_private_types_in_public_api

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:odontobb/models/award_history_model.dart';
import 'package:odontobb/services/awards_service.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:styled_text/styled_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

typedef StringCallback = void Function();

class CodeUserBody extends StatefulWidget {
  @override
  _CodeUserBodyState createState() => _CodeUserBodyState();

  final String? personId;
  final String? awardId;
  final String title;
  final String? description;
  final String? imageUrl;
  final int? cantBbCash;
  final StringCallback? callback;

  @override
  const CodeUserBody(
      {super.key,
      this.personId,
      this.awardId,
      required this.title,
      this.description,
      this.imageUrl,
      this.cantBbCash,
      this.callback});
}

class _CodeUserBodyState extends State<CodeUserBody> {
  ChildrenService childrenService = ChildrenService();
  AwardsService awardsService = AwardsService();
  AwardHistoryModel awardHistoryModel = AwardHistoryModel();

  bool getProduct = false;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getInfo() async {
    await Future.delayed(Duration(seconds: Utils.loadingTime));
    if (mounted) setState(() {});
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
      appBar: AppBar(
          title: NormalText(
        text: Utils.translate("my code"),
        textSize: kTitleFontSize,
        fontWeight: FontWeight.w400,
      )),
      body: _showProductCode(context),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            backgroundColor: kButtonColor,
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.home,
              size: 40.0,
              color: kDarkBlackTextColor,
            ))
      ]),
    );
  }

  _showProductCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30.0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NormalText(
              textOverflow: TextOverflow.visible,
              text: widget.title,
              textSize: kTitleFontSize,
              fontWeight: FontWeight.w500),
          const SizedBox(
            height: 20.0,
          ),
          QrImageView(
            data:
                '{"type": "odontobb_appt", "data": {"personId":"${widget.personId!}", "created":"${Timestamp.now().toString()}"}}',
            //data: 'http://ccrecreo.odontobb.com',
            version: QrVersions.auto,
            size: Utils.size(context).width * 0.6,
            embeddedImage: const AssetImage("assets/images/odontobbIcon.png"),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(110, 40),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          NormalText(
              textOverflow: TextOverflow.visible,
              text: Utils.translate("show this code"),
              textColor:
                  Utils.isDarkMode ? kDarkTextColorColor : Colors.black54,
              textSize: kSmallFontSize),
          const SizedBox(
            height: 10.0,
          ),
          NormalText(
              textOverflow: TextOverflow.visible,
              text: Utils.translate("code duration"),
              textColor:
                  Utils.isDarkMode ? kDarkTextColorColor : Colors.black54,
              textSize: kMicroFontSize),
        ],
      ),
    );
  }
}
