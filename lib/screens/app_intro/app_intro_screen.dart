import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/models/app_intro_model.dart';
import 'package:odontobb/screens/main_page/main_screen.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:flutter/material.dart';

class AppIntroScreen extends StatefulWidget {
  static const routeName = "app_intro_screen";

  const AppIntroScreen({super.key});
  @override
  _AppIntroScreenState createState() => _AppIntroScreenState();
}

int currentIndex = 0;
CarouselController controllerCarousel = CarouselController();

class _AppIntroScreenState extends State<AppIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          Container(
            color: kWhiteColor,
            height: Utils.size(context).height - 100,
            width: Utils.size(context).width,
            child: CarouselSlider.builder(
              //carouselController: controllerCarousel,
              options: CarouselOptions(
                autoPlay: false,
                pauseAutoPlayInFiniteScroll: false,
                initialPage: 0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                viewportFraction: 0.9,
                aspectRatio: 0.7,
                onPageChanged: (index, c) {
                  changeIndicator(index);
                },
              ),
              itemCount: appIntroList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Column(
                  children: [
                    Flexible(
                      child: Image.asset(
                        appIntroList[index].image!,
                        fit: BoxFit.contain,
                        height: Utils.size(context).height,
                        width: Utils.size(context).width,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NormalText(
                          text: appIntroList[index].title!,
                          textColor: kAppColor,
                          fontWeight: FontWeight.w900,
                          textSize: kLargeFontSize,
                        ),
                        SizedBox(
                          width: Utils.size(context).width * 0.8,
                          child: NormalText(
                            textOverflow: TextOverflow.visible,
                            text: appIntroList[index].desc!,
                            textColor: kBlackFontColor,
                            textSize: kSmallFontSize,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: appIntroList.map((item) {
                  int index = appIntroList.indexOf(item);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
              appIntroList[currentIndex].visibleButton == false
                  ? Center(
                      child: DefaultButton(
                        width: 150,
                        onPress: () {
                          navigatorPlus.show(MainScreen());
                        },
                        color: kButtonColor,
                        buttonTitle: Utils.translate("get_started"),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  changeIndicator(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
