// ignore_for_file: use_build_context_synchronously

import 'package:odontobb/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/line_widget.dart';
import 'package:odontobb/widgets/textFileld_builder.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/models/country_model.dart';
import 'package:odontobb/util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/src/provider.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  _CreateAccountBodyState createState() => _CreateAccountBodyState();
}

class _CreateAccountBodyState extends State<LoginBody> {
  List<CountryModel>? countryList = [];
  CountryModel? selectCountry;
  final _phoneController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool sending = false;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    //await Future.delayed(Duration(seconds: Utils.loadingTime));
    if (mounted)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        countryList = Utils.countryList;
        // selectCountry = countryList![0];
        // selectCountry = countryList!
        //     .where((element) => element.code == Utils.appLocale.countryCode)
        //     .first;

        selectCountry =
            countryList!.firstWhere((element) => element.code == "EC");
        Utils.selectCountry = selectCountry!;
      });
  }

  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: NormalText(
              text: Utils.translate("login"),
              textSize: kTitleFontSize,
              fontWeight: FontWeight.w400)),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/main_bg_two.png",
                height: Utils.size(context).height,
                width: Utils.size(context).width,
                fit: BoxFit.fill,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 30.0,
                      bottom: 0,
                    ),
                    child: selectCountry != null
                        ? Column(
                            children: [
                              Container(
                                height: 210,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.transparent,
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 185,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: kBlackFontColor
                                                  .withOpacity(0.3),
                                              blurRadius: 20.0,
                                              spreadRadius: 1.0)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Utils.isDarkMode
                                            ? kDarkBgColor
                                            : kWhiteColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 5.0,
                                                top: 0.0,
                                                bottom: 0),
                                            child: DropdownButton<CountryModel>(
                                              value: selectCountry,
                                              icon: Container(),
                                              iconSize: kLargeFontSize,
                                              style: TextStyle(
                                                color: Utils.isDarkMode
                                                    ? kWhiteColor
                                                    : kBlackFontColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              underline: Container(),
                                              onChanged: (newValue) async {
                                                setState(() {
                                                  if (selectCountry!.code !=
                                                      newValue!.code) {
                                                    selectCountry = newValue;
                                                    Utils.selectCountry =
                                                        selectCountry!;
                                                  }
                                                });
                                              },
                                              items: countryList!.map<
                                                      DropdownMenuItem<
                                                          CountryModel>>(
                                                  (CountryModel value) {
                                                return DropdownMenuItem<
                                                    CountryModel>(
                                                  value: value,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      NormalText(
                                                        text: value.emoji!,
                                                        textColor:
                                                            kBlackFontColor,
                                                        textSize:
                                                            kNormalFontSize,
                                                      ),
                                                      const SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      NormalText(
                                                        text: value.name!,
                                                        textColor: Utils
                                                                .isDarkMode
                                                            ? kWhiteColor
                                                            : kBlackFontColor,
                                                        textSize:
                                                            kNormalFontSize,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          LineWidget(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 5.0,
                                                top: 0.0,
                                                bottom: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: NormalText(
                                                    text: selectCountry!
                                                        .phoneCode!,
                                                    textColor: Utils.isDarkMode
                                                        ? kWhiteColor
                                                        : kBlackFontColor,
                                                    textSize: kNormalFontSize,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 8,
                                                  child: InputTextField(
                                                    placeHolder: Utils.translate(
                                                        "enter_phone_number"),
                                                    icon: Icons.phone_android,
                                                    controller:
                                                        _phoneController,
                                                    textSize: kNormalFontSize,
                                                    inputType:
                                                        TextInputType.phone,
                                                    autofocus: true,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          LineWidget()
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      right: 0.0,
                                      left: 0.0,
                                      child: Center(
                                        child: DefaultButton(
                                          width: 170,
                                          buttonTitle: sending
                                              ? Utils.translate("sending")
                                              : Utils.translate("login"),
                                          onPress: () async {
                                            setState(() {
                                              sending = true;
                                            });
                                            await storage.write(
                                                key: 'countryCode',
                                                value: selectCountry!.code
                                                    .toString());

                                            await context
                                                .read<AuthenticationService>()
                                                .verifyPhoneNumber(
                                                  phone:
                                                      '${selectCountry!.phoneCode!}${_phoneController.text}',
                                                  context: context,
                                                );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              sending
                                  ? const CircularProgressIndicator(
                                      color: kButtonColor,
                                      strokeWidth: 2.0,
                                    )
                                  : Container(),
                            ],
                          )
                        : ShimmerWidget(
                            child: Container(
                              width: Utils.size(context).width,
                              height: 185,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
