// ignore_for_file: library_private_types_in_public_api

import 'package:odontobb/constant.dart';
import 'package:odontobb/models/news_model.dart';
import 'package:odontobb/screens/item_detail_page/item_detail_screen.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'custom_elements/normal_text.dart';

class NewsCardSwiper extends StatefulWidget {
  final List<NewsModel> news;
  const NewsCardSwiper({super.key, required this.news});

  @override
  _NewsCardSwiperState createState() => _NewsCardSwiperState();
}

class _NewsCardSwiperState extends State<NewsCardSwiper> {
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Utils.size(context).width,
        height: Utils.size(context).height * 0.5,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return _body(widget.news[index], context);
          },
          onIndexChanged: (index) async {
            setState(() {});
          },
          onTap: (index) {
            NewsModel news = widget.news[index];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ItemDetailScreen(
                    title: news.title!,
                    description: news.description,
                    imageUrl: news.imageUrl);
              }),
            );
          },
          itemCount: widget.news.length,
          itemWidth: Utils.size(context).width * 0.8,
          itemHeight: Utils.size(context).height * 0.45,
          viewportFraction: 0.8,
          scale: 0.9,
          loop: true,
          layout: SwiperLayout.STACK,
        ));
  }

  Widget _body(NewsModel item, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: item.imageUrl?.isNotEmpty == true
          ? _imagenNews(item)
          : FutureBuilder(
              future: FileService.loadImage('news/${item.image}'),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  item.imageUrl = snapshot.data!;
                  return _imagenNews(item);
                } else {
                  return ShimmerWidget(
                      child: ShimmerWidget(
                    child: Container(
                      width: Utils.size(context).width * 0.8,
                      height: Utils.size(context).height * 0.4,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        color: kWhiteColor,
                      ),
                    ),
                  ));
                }
              }),
    );
  }

  Widget _imagenNews(NewsModel item) {
    return Container(
      color: Colors.white70,
      child: Stack(
        children: [
          Hero(
            tag: item.title!,
            // child: FadeInImage.assetNetwork(
            //     placeholder: kEmptyImage,
            //     image: item.imageUrl!,
            //     fit: BoxFit.cover),
            child:
                CachedNetworkImage(imageUrl: item.imageUrl!, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 40.0,
              width: Utils.size(context).width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.orange,
              child: NormalText(
                text: item.title!,
                textSize: kNormalFontSize,
                fontWeight: FontWeight.w600,
                textColor: kWhiteColor,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
