import 'package:flutter/material.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/services/challenge_service.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:odontobb/widgets/stats_card_swiper.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import '../../../constant.dart';
import '../../../util.dart';

class StatsBody extends StatefulWidget {
  const StatsBody({super.key});

  @override
  _StatsBodyState createState() => _StatsBodyState();
}

class _StatsBodyState extends State<StatsBody> {
  ChildrenService childrenService = ChildrenService();
  ChallengeService challengeService = ChallengeService();
  Key statsCardSwiperKey = UniqueKey();

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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
              text: Utils.translate("statistics and challenges"),
              textSize: kTitleFontSize,
              fontWeight: FontWeight.w400,
            ),
            IconButton(
              icon: const Icon(
                Icons.person_add,
                color: kAppColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/children_form').then((value) {
                  setState(() {
                    statsCardSwiperKey = UniqueKey(); // Forzar reconstrucción
                    getInfo();
                  });
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            _statsByChildren(),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsByChildren() {
    return FutureBuilder<List<PersonModel>>(
      future: childrenService.get(),
      builder: (context, AsyncSnapshot<List<PersonModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerWidget(
            child: StatsCardSwiper(
              key: statsCardSwiperKey,
              items: [PersonModel(), PersonModel()],
              all: true,
            ),
          );
        }
        return StatsCardSwiper(
          key: statsCardSwiperKey,
          items: snapshot.data!,
          all: true,
        );
      },
    );
  }
}
