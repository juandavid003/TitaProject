import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/line_widget.dart';
import 'package:odontobb/widgets/textFileld_builder.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/models/country_model.dart';
import 'package:provider/src/provider.dart';

class CreateAccountBody extends StatefulWidget {
  const CreateAccountBody({super.key});

  @override
  _CreateAccountBodyState createState() => _CreateAccountBodyState();
}

class _CreateAccountBodyState extends State<CreateAccountBody> {
  List<CountryModel> countryList = [];
  CountryModel? selectCountry;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool sending = false;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    await Future.delayed(Duration(seconds: Utils.loadingTime));
    if (mounted) {
      setState(() {
        countryList = Utils.countryList!;
        selectCountry =
            countryList.firstWhere((element) => element.code == "EC");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: NormalText(
        text: Utils.translate("create_account"),
        textSize: kPriceFontSize,
        fontWeight: FontWeight.w600,
      )),
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
                        ? Container(
                            height: 360,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.transparent,
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 335,
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              kBlackFontColor.withOpacity(0.3),
                                          blurRadius: 20.0,
                                          spreadRadius: 1.0)
                                    ],
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Utils.isDarkMode
                                        ? kDarkBgColor
                                        : kWhiteColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InputTextField(
                                        placeHolder: Utils.translate("name"),
                                        icon: Icons.person,
                                        controller: _nameController,
                                        textSize: kNormalFontSize,
                                        autofocus: true,
                                      ),
                                      LineWidget(),
                                      InputTextField(
                                        placeHolder: Utils.translate("email"),
                                        icon: Icons.email,
                                        controller: _emailController,
                                        textSize: kNormalFontSize,
                                      ),
                                      LineWidget(),
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
                                              }
                                            });
                                          },
                                          items: countryList
                                              .map<DropdownMenuItem<CountryModel>>(
                                                  (CountryModel value) {
                                            return DropdownMenuItem<CountryModel>(
                                              value: value,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  NormalText(
                                                    text: value.emoji!,
                                                    textColor: kBlackFontColor,
                                                    textSize: kNormalFontSize,
                                                  ),
                                                  const SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  NormalText(
                                                    text: value.name!,
                                                    textColor: Utils.isDarkMode
                                                        ? kWhiteColor
                                                        : kBlackFontColor,
                                                    textSize: kNormalFontSize,
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
                                                        .phoneCode!.isNotEmpty
                                                    ? selectCountry!.phoneCode!
                                                    : '',
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
                                                controller: _phoneController,
                                                textSize: kNormalFontSize,
                                                inputType: TextInputType.phone,
                                                validate: (value) {
                                                  return Utils()
                                                      .validateMobile(value!);
                                                },
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
                                          ? Utils.translate("creating_account")
                                          : Utils.translate("sign_up"),
                                      onPress: () async {
                                        setState(() {
                                          sending = true;
                                        });
                                        await context
                                            .read<AuthenticationService>()
                                            .verifyPhoneNumber(
                                                phone:
                                                    '${selectCountry!.phoneCode!}${_phoneController.text}',
                                                name: _nameController.text,
                                                email: _emailController.text,
                                                context: context);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : ShimmerWidget(
                            child: Container(
                              width: Utils.size(context).width,
                              height: 360,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                  ),
                  sending
                      ? const CircularProgressIndicator(
                          color: kButtonColor,
                          strokeWidth: 2.0,
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
