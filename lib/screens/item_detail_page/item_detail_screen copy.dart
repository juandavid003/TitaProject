// ignore_for_file: unused_field, must_be_immutable

import 'dart:async';
import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/purchases_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
// import 'package:flutter/services.dart';
import 'package:styled_text/styled_text.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ItemDetailScreen extends StatefulWidget {
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
  final String? id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? linkDemo;
  final String? linkProduct;
  final String? category;
  final double? price;
  final bool? forClients;
  bool? paid;

  @override
  ItemDetailScreen({
    super.key,
    this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.linkDemo = '',
    this.linkProduct,
    this.category,
    this.price,
    this.forClients,
    this.paid = false,
  });
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final PurchasesService _purchasesService = PurchasesService();
  final AuthenticationService _authenticationService =
      AuthenticationService(FirebaseAuth.instance);

  bool client = true; //default false
  bool autoPlay = true;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    getInfo();

    // _controller = YoutubePlayerController(
    //   params: const YoutubePlayerParams(
    //     showControls: true,
    //     mute: false,
    //     showFullscreenButton: true,
    //     loop: false,
    //   ),
    // )
    // ..onInit = () {
    //   _controller.loadPlaylist(
    //     list: [
    //       'tcodrIK2P_I',
    //       'nPt8bK2gbaU',
    //       'K18cpp_-gP8',
    //       'iLnmTe5Q2Qw',
    //       '_WoCV4c6XOE',
    //       'KmzdUe0RSJo',
    //       '6jZDSSZZxjQ',
    //       'p2lYr3vM_1w',
    //       '7QUtEmBT_-w',
    //       '34_PXCzGw1M',
    //     ],
    //     listType: ListType.playlist,
    //     startSeconds: 136,
    //   );
    // }
    // ..onFullscreenChange = (isFullScreen) {
    //   print('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
    // };

    // if (widget.linkDemo?.isNotEmpty == true) {
    //   _controller = YoutubePlayerController(
    //     initialVideoId: YoutubePlayer.convertUrlToId(widget.linkDemo!)!,
    //     flags: const YoutubePlayerFlags(
    //       mute: false,
    //       autoPlay: false,
    //       disableDragSeek: false,
    //       loop: true,
    //       isLive: false,
    //       forceHD: false,
    //       enableCaption: true,
    //     ),
    //   )..addListener(listener);
    // }

    //_videoMetaData = const YoutubeMetaData();
    //_playerState = PlayerState.unknown;
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    //_controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  void listener() {
    // if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
    //   setState(() {
    //     _playerState = _controller.value.playerState;
    //     _videoMetaData = _controller.metadata;
    //   });
    // }
  }

  getInfo() async {
    await Future.delayed(Duration(seconds: Utils.loadingTime));
    //client = await _authenticationService.isClient();
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
            margin: const EdgeInsets.only(top: 320.0),
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
            iconTheme:
                IconThemeData(color: kPrimaryColor, size: kLargeFontSize),
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
                      widget.linkDemo?.isNotEmpty == true
                          ? _showVideoDemo(context)
                          : Container(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      widget.price?.isFinite == true
                          ? _checkPayProduct(client)
                          : Container(),
                      const SizedBox(
                        height: 20.0,
                      ),
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

 _showVideoDemo(BuildContext context) {
  final videoId = YoutubePlayerController.convertUrlToId(widget.linkDemo!);

  if (videoId == null) return Container();

  _controller = YoutubePlayerController.fromVideoId(
    videoId: videoId,
    params: YoutubePlayerParams(
      showControls: true,
      showFullscreenButton: true,
      mute: false,
    ),
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      NormalText(
        text: "Demo",
        textColor: Utils.isDarkMode ? kDarkTextColorColor : Colors.black54,
        textSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      const SizedBox(height: 10),
      YoutubePlayerScaffold(
        controller: _controller,
        builder: (context, player) {
          return player;
        },
      ),
    ],
  );
}

  Widget _checkPayProduct(bool client) {
    return Container();
    // return FutureBuilder(
    //     future: _purchasesService.get(widget.id!),
    //     builder:
    //         (BuildContext context, AsyncSnapshot<List<PurchaseModel>> snapshot) {
    //       if ((snapshot.hasData && snapshot.data!.length > 0) ||
    //           client && widget.forClients!) {
    //         return _getProduct(context);
    //       } else {
    //         return _buyRegion(context);
    //       }
    //     });
  }

  // _getProduct(BuildContext context) {
  //   return Align(
  //       alignment: Alignment.bottomRight,
  //       child: DefaultButton(
  //         buttonTitle: Utils.translate("view_content"),
  //         width: double.infinity,
  //         onPress: () {
  //           VideoModel video = new VideoModel(
  //               widget.linkProduct!, widget.category!, widget.title);

  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) {
  //               return WebViewWidget(videoModel: video);
  //             }),
  //           );
  //         },
  //       ));
  // }

  // _buyRegion(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.only(top: 15.0),
  //         child: NormalText(
  //           textOverflow: TextOverflow.visible,
  //           text: '\$ ${widget.price.toString()}',
  //           textColor: Utils.isDarkMode ? kDarkTextColorColor : Colors.black,
  //           textSize: kLargeFontSize,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       _btnBuyProduct(context)
  //     ],
  //   );
  // }

  // _btnBuyProduct(BuildContext context) {
  //   // final _paymentItems = [
  //   //   PaymentItem(
  //   //     label: '${widget.category} - ${widget.title}',
  //   //     amount: widget.price.toString(),
  //   //     status: PaymentItemStatus.final_price,
  //   //   )
  //   // ];
  //   // return Row(children: [
  //   //   ApplePayButton(
  //   //     paymentConfigurationAsset: 'applepay.json',
  //   //     paymentItems: _paymentItems,
  //   //     width: 200,
  //   //     height: 50,
  //   //     style: ApplePayButtonStyle.black,
  //   //     type: ApplePayButtonType.buy,
  //   //     margin: const EdgeInsets.only(top: 15.0),
  //   //     onPaymentResult: onPayResult,
  //   //     loadingIndicator: const Center(
  //   //       child: CircularProgressIndicator(),
  //   //     ),
  //   //   ),
  //   //   GooglePayButton(
  //   //     paymentConfigurationAsset: 'gpay.json',
  //   //     paymentItems: _paymentItems,
  //   //     style: GooglePayButtonStyle.black,
  //   //     type: GooglePayButtonType.pay,
  //   //     margin: const EdgeInsets.only(top: 15.0),
  //   //     onPaymentResult: onPayResult,
  //   //     loadingIndicator: const Center(
  //   //       child: CircularProgressIndicator(),
  //   //     ),
  //   //   ),
  //   // ]);
  // }

  // void onPayResult(paymentResult) {
  //   // Send the resulting Apple Pay token to your server / PSP
  //   PurchaseModel purchase = new PurchaseModel();
  //   purchase.productId = widget.id;
  //   purchase.userId = Utils.globalFirebaseUser!.uid;
  //   purchase.price = widget.price;

  //   _purchasesService.save(purchase).then((value) {
  //     _authenticationService.activeClient(true);
  //     setState(() {
  //       widget.paid = true;
  //     });
  //   });
  // }
// }
}
