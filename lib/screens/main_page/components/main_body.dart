import 'package:odontobb/models/country_model.dart';
import 'package:odontobb/services/countries_service.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/screens/create_account_page/create_account_screen.dart';
import 'package:odontobb/screens/login_page/login_screen.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import '../../../util.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  CountriesService countriesService = CountriesService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: Utils.size(context).height,
          width: Utils.size(context).width,
          child: Image.asset(
            "assets/images/main_bg_two.png",
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/images/odontobbIcon.png",
                  height: 200,
                  width: 200,
                ),
                _accessMethods(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _accessMethods() {
    return FutureBuilder(
        future: countriesService.get(),
        builder: (context, AsyncSnapshot<List<CountryModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return Column(
                children: [
                  DefaultButton(
                    width: Utils.size(context).width * 0.8,
                    buttonTitle: Utils.translate("login"),
                    onPress: () {
                      Navigator.of(context).pop();
                      navigatorPlus.show(LoginScreen());
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  DefaultButton(
                    width: Utils.size(context).width * 0.8,
                    buttonTitle: Utils.translate("create_account"),
                    onPress: () {
                      Navigator.of(context).pop();
                      navigatorPlus.show(CreateAccountScreen());
                    },
                  )
                ],
              );
            } else {
              return Container();
            }
          } else {
            return ShimmerWidget(
                child: Column(
              children: [
                DefaultButton(
                  width: Utils.size(context).width * 0.8,
                  buttonTitle: Utils.translate("login"),
                  onPress: () {},
                ),
                const SizedBox(
                  height: 15.0,
                ),
                DefaultButton(
                  width: Utils.size(context).width * 0.8,
                  buttonTitle: Utils.translate("create_account"),
                  onPress: () {},
                )
              ],
            ));
          }
        });
  }
}
