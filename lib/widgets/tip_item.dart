import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/models/tip.dart';
import 'package:odontobb/util.dart';
import '../constant.dart';
import 'custom_elements/normal_text.dart';

// ignore: must_be_immutable
class TipItem extends StatefulWidget {
  TipModel tipModel;

  @override
  // ignore: library_private_types_in_public_api
  _TipItemState createState() => _TipItemState();

  TipItem(this.tipModel, {super.key});
}

class _TipItemState extends State<TipItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Utils.size(context).height * 0.25,
            width: Utils.size(context).width,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              child: Hero(
                  tag: widget.tipModel.title!,
                  child: _getImage(context, widget.tipModel.image!)),
            ),
          ),
          _body(context)
        ],
      ),
    );
  }

  Widget _getImage(BuildContext context, String imageName) {
    if (widget.tipModel.imageUrl != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomEnd,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          Positioned.fill(
              child: CachedNetworkImage(
                  imageUrl: widget.tipModel.imageUrl!, fit: BoxFit.fitWidth)),
          Image.asset("assets/images/odontobbIcon.png", height: 30),
        ],
      );
    } else {
      return FutureBuilder(
        future: FileService.loadImage('tips/$imageName'),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            widget.tipModel.imageUrl = snapshot.data!;
            return Stack(
              alignment: AlignmentDirectional.bottomEnd,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                Positioned.fill(
                  child: Image.network(widget.tipModel.imageUrl!,
                      fit: BoxFit.fitWidth),
                ),
                Image.asset("assets/images/odontobbIcon.png", height: 30),
              ],
            );
          } else {
            return Stack(
              alignment: AlignmentDirectional.bottomEnd,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                Positioned.fill(
                  child: ShimmerWidget(
                    child: Container(
                      width: Utils.size(context).width * 0.5,
                      height: Utils.size(context).height * 0.6,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
                Image.asset("assets/images/odontobbIcon.png", height: 30),
              ],
            );
          }
        },
      );
    }
  }

  Container _body(BuildContext context) {
    return Container(
      width: Utils.size(context).width,
      decoration: BoxDecoration(
        color: Utils.isDarkMode ? kDarkItemColor : kWhiteColor,
        boxShadow: [
          BoxShadow(
            color:
                Utils.isDarkMode ? kDarkBgColor : Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text: widget.tipModel.category!,
              textColor: Utils.getColorMode(),
              textSize: kSmallFontSize,
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 10.0,
            ),
            NormalText(
                textOverflow: TextOverflow.ellipsis,
                text: widget.tipModel.title!,
                textColor: Utils.getColorMode(),
                textSize: kSubTitleFontSize,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
                maxLines: 4),
            const SizedBox(
              height: 10.0,
            ),
            NormalText(
                text: widget.tipModel.description!,
                textColor: Utils.getColorMode(),
                textSize: kSmallFontSize,
                textAlign: TextAlign.left,
                textOverflow: TextOverflow.ellipsis,
                maxLines: 4),
            // Expanded(child: Container()),
            // _status(),
          ],
        ),
      ),
    );
  }

  // Column _status() {
  //   return Column(
  //     children: [
  //       LineWidget(),
  //       Row(
  //         children: [
  //           Icon(Icons.star),
  //           NormalText(
  //             text: '5',
  //             textColor: Utils.getColorMode(),
  //             textSize: kSmallFontSize,
  //             textAlign: TextAlign.left,
  //           ),
  //           SizedBox(
  //             width: 20.0,
  //           ),
  //           Icon(Icons.remove_red_eye),
  //           NormalText(
  //             text: '555',
  //             textColor: Utils.getColorMode(),
  //             textSize: kSmallFontSize,
  //             textAlign: TextAlign.left,
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
