import 'package:odontobb/models/person_model.dart';
//import 'package:odontobb/screens/children/children_screen.dart';
import 'package:odontobb/screens/children/components/children_body.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/widgets/childen_card_swiper.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
//import 'package:provider/src/provider.dart';
import '../../../util.dart';

class PatientPageBody extends StatefulWidget {
  const PatientPageBody({super.key});

  @override
  _PatientPageBodyState createState() => _PatientPageBodyState();
}

class _PatientPageBodyState extends State<PatientPageBody> {
  ChildrenService childrenService = ChildrenService();

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
    //final firebaseUser = context.watch<User>();

    return Scaffold(
      appBar: AppBar(
          title: NormalText(
        text: Utils.translate("manage_patients"),
        textSize: kTitleFontSize,
        fontWeight: FontWeight.w400,
      )),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 30.0,
          bottom: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            DefaultButton(
              width: 170,
              buttonTitle: Utils.translate("add_beneficiary"),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ChildrenBody();
                  }),
                ).then((value) => {getInfo()});
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            NormalText(
              text: Utils.translate("the_beneficiaries"),
              textColor: Utils.getColorMode(),
              textSize: kLargeFontSize,
              fontWeight: FontWeight.w400,
            ),
            NormalText(
              text: Utils.translate("beneficiaries_description"),
              textColor: Utils.isDarkMode ? kGrayColor : kTextColorColor,
              textSize: 10.0,
            ),
            _children()
          ],
        ),
      ),
    );
  }

  Widget _children() {
    return FutureBuilder(
        future: childrenService.get(),
        builder: (context, AsyncSnapshot<List<PersonModel>> snapshot) {
          if (snapshot.hasData) {
            return ChildrenCardSwiper(items: snapshot.data!);
          } else {
            return ShimmerWidget(
                child: ChildrenCardSwiper(items: [PersonModel(name: '')]));
          }
        });
  }
}
