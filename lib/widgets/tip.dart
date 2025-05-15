import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/tips_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/models/tip.dart';
import 'package:odontobb/screens/item_detail_page/item_detail_screen.dart';
import 'package:odontobb/widgets/tip_item.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import '../constant.dart';
import '../util.dart';

class TipBuilder extends StatefulWidget {
  @override
  _TipBuilderState createState() => _TipBuilderState();
  final List<TipModel> tipList;
  final int limit;
  final bool isScroll;

  const TipBuilder(
      {super.key,
      required this.tipList,
      required this.limit,
      required this.isScroll});
}

class _TipBuilderState extends State<TipBuilder> {
  TipsService tipsService = TipsService();
  final ScrollController _scrollController = ScrollController();
  AuthenticationService authenticationService =
      AuthenticationService(FirebaseAuth.instance);
  bool _isLoading = false;
  bool client = true; //default false

  @override
  void initState() {
    super.initState();
    getInfo();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadTips(widget.tipList.last, widget.tipList.length >= 2);
      }
    });
  }

  getInfo() async {
    //client = await authenticationService.isClient();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.tipList.isNotEmpty
        ? Stack(children: [
            _listItems(context),
            _createLoading(),
          ])
        : ShimmerWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_itemShimmerTip(context)],
            ),
          );
  }

  ListView _listItems(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: widget.isScroll != true
          ? NeverScrollableScrollPhysics()
          : AlwaysScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                TipModel tip = widget.tipList[index];
                return ItemDetailScreen(
                    title: tip.title!,
                    description: tip.description,
                    imageUrl: tip.imageUrl,
                    imageName: tip.image,
                    from:'DidYouKnow',
                    bibliographicalCitation: tip.bibliographicalCitation);
              }),
            );
          },
          child: TipItem(widget.tipList[index]),
        );
      },
      itemCount:
          widget.tipList.isNotEmpty ? widget.tipList.length : widget.limit,
    );
  }

  Widget _createLoading() {
    if (_isLoading) {
      return Container(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: kButtonColor,
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _loadTips(TipModel lastTip, bool checkClient) async {
    // client = await authenticationService.isClient();
    // if (checkClient && !client) {
    //   navigatorPlus.showModal(PayScreen());
    // } else {
    List<TipModel> newTips = [];
    do {
      _isLoading = true;
      setState(() {});
      newTips = await tipsService.tips(10, lastTip);
      widget.tipList.addAll(newTips);
      if (newTips.isNotEmpty) {
        _scrollController.animateTo(_scrollController.position.pixels + 250,
            duration: Duration(milliseconds: 250), curve: Curves.fastOutSlowIn);
      }
      newTips = [];
      _isLoading = false;
      setState(() {});
    } while (newTips.isNotEmpty);
    //}
  }

  Widget _itemShimmerTip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Utils.size(context).height * 0.25,
            width: Utils.size(context).width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
              color: kWhiteColor,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Container(
                    height: 20.0,
                    width: Utils.size(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.zero),
                      color: kWhiteColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: Utils.size(context).height * 0.1,
                    width: Utils.size(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.zero),
                      color: kWhiteColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: Utils.size(context).height * 0.2,
                    width: Utils.size(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.zero),
                      color: kWhiteColor,
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: Utils.size(context).height * 0.2,
            width: Utils.size(context).width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
              color: kWhiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
