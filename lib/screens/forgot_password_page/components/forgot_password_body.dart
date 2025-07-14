import 'package:flutter/material.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/line_widget.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/textFileld_builder.dart';
import '../../../constant.dart';
import '../../../util.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  _ForgotPasswordBodyState createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
                SizedBox(
                  height: 50,
                ),
                NormalText(
                  text: Utils.translate("forgot_pass"),
                  fontWeight: FontWeight.w700,
                  textSize: kLargeFontSize,
                  textAlign: TextAlign.center,
                  textColor: kButtonColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 30.0,
                    bottom: 0,
                  ),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 125,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: kBlackFontColor.withOpacity(0.3),
                                  blurRadius: 20.0,
                                  spreadRadius: 1.0)
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                            color:
                                Utils.isDarkMode ? kDarkBgColor : kWhiteColor,
                          ),
                          child: Column(
                            children: [
                              InputTextField(
                                  placeHolder: Utils.translate("phone_number"),
                                  icon: Icons.call),
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
                              buttonTitle: Utils.translate("next"),
                              onPress: () {
                                // navigatorPlus.show(VerificationScreen(''));
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Divider buildDivider() {
    return const Divider(
      color: kBottomIconColor,
      height: 1,
      thickness: 1,
      indent: 1,
      endIndent: 0,
    );
  }
}
