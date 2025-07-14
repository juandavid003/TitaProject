// ignore_for_file: unused_field, must_be_immutable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odontobb/models/award_history_model.dart';
import 'package:odontobb/services/awards_service.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:styled_text/styled_text.dart';

typedef StringCallback = void Function();

class ItemAwardScreen extends StatefulWidget {
  @override
  _ItemAwardScreenState createState() => _ItemAwardScreenState();

  final String? personId;
  final String? awardId;
  final String title;
  final String? description;
  final String? imageUrl;
  final int? cantBbCash;
  final StringCallback? callback;

  @override
  const ItemAwardScreen(
      {super.key,
      this.personId,
      this.awardId,
      required this.title,
      this.description,
      this.imageUrl,
      this.cantBbCash,
      this.callback});
}

class _ItemAwardScreenState extends State<ItemAwardScreen> {
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
    final hero = Hero(
      tag: widget.title,
      child: Material(
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: widget.imageUrl!.isNotEmpty
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.imageUrl!),
                  )
                : const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(kEmptyImage),
                  ),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            margin: EdgeInsets.only(top: 320.0),
            height: 30.0,
            decoration: BoxDecoration(
              color: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
      key: _key,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
            iconTheme: const IconThemeData(color: kBlackFontColor, size: 23.0),
            expandedHeight: 300.0,
            elevation: 5,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Material(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      Positioned.fill(
                        child: hero,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          "assets/images/odontobbIcon.png",
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      NormalText(
                        textOverflow: TextOverflow.visible,
                        text: widget.title,
                        textColor: Utils.isDarkMode
                            ? kDarkTextColorColor
                            : Colors.black54,
                        textSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      widget.description?.isNotEmpty == true
                          ? StyledText(
                              text: "<p>${widget.description!}</p>",
                              newLineAsBreaks: true,
                              tags: {
                                'b': StyledTextTag(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                'p': StyledTextTag(
                                  style: TextStyle(
                                    color: Utils.isDarkMode
                                        ? kDarkTextColorColor
                                        : Colors.black54,
                                    fontSize: kSubTitleFontSize,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              },
                              textAlign: TextAlign.justify,
                            )
                          : Container(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      getProduct
                          ? _showProductCode(context)
                          : _getProduct(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getProduct(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40.0,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: DefaultButton(
              buttonTitle: Utils.translate("i_want_product"),
              width: double.infinity,
              onPress: () async {
                setState(() {
                  getProduct = true;
                });
                //widget.callback!();
              },
            )),
      ],
    );
  }

  _showProductCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30.0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [



          QrImageView(
            data:
                '{"type": "award", "data": {"personId":"${widget.personId!}","awardId":"${widget.awardId!}","created":"${Timestamp.now().toString()}"}}',
            //'https://odontobb.com/#/?downloadApp=true&clinic=2',
            size: Utils.size(context).width * 0.6,
            embeddedImage: const AssetImage("assets/images/odontobbIcon.png"),
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
          const SizedBox(
            height: 30.0,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: DefaultButton(
                buttonTitle: Utils.translate("ok"),
                width: double.infinity,
                onPress: () async {
                  Navigator.pop(context);
                  widget.callback!();
                },
              )),
        ],
      ),
    );
  }
}