import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/widgets/childen_card_swiper.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/parallax_page.dart';
import 'package:provider/provider.dart';
import '../../../util.dart';

class ProfilePageBody extends StatefulWidget {
  const ProfilePageBody({super.key});

  @override
  _ProfilePageBodyState createState() => _ProfilePageBodyState();
}

class _ProfilePageBodyState extends State<ProfilePageBody> {
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
    final firebaseUser = context.watch<User>();

    return Scaffold(
      appBar: AppBar(
          title: NormalText(
        text: "Actualizar perfil", // Texto directo en lugar de traducción
        textSize: kPriceFontSize,
        fontWeight: FontWeight.w600,
      )),
      body: ParallaxPage(
        image: AssetImage("assets/images/main_bg_two.png"),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 10.0,
              ),
              NormalText(
                text: firebaseUser.displayName ?? "Sin nombre",
                textColor: Utils.getColorMode(),
                textSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
              NormalText(
                text: firebaseUser.email ?? "Sin correo electrónico",
                textColor: Utils.isDarkMode ? kGrayColor : kTextColorColor,
                textSize: 10.0,
              ),
              SizedBox(
                height: 50.0,
              ),
              DefaultButton(
                width: 170,
                buttonTitle:
                    "Agregar beneficiario", // Texto directo en lugar de traducción
                onPress: () {
                  Navigator.pushNamed(context, '/children_form')
                      .then((value) => {getInfo()});
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              NormalText(
                text:
                    "Los beneficiarios", // Texto directo en lugar de traducción
                textColor: Utils.getColorMode(),
                textSize: kLargeFontSize,
                fontWeight: FontWeight.w400,
              ),
              NormalText(
                text:
                    "Aquí puedes ver y gestionar tus beneficiarios", // Texto directo en lugar de traducción
                textColor: Utils.isDarkMode ? kGrayColor : kTextColorColor,
                textSize: 10.0,
              ),
              _children()
            ],
          ),
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
