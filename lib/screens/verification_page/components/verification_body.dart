import 'dart:async';
import 'package:odontobb/screens/login_page/components/login_body.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/line_widget.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/textFileld_builder.dart';
import 'package:odontobb/constant.dart';
import 'package:provider/provider.dart';
import '../../../util.dart';

class VerificationBody extends StatefulWidget {
  final String verificationId;
  final String? name;
  final String? email;
  @override
  _VerificationBodyState createState() => _VerificationBodyState();
  const VerificationBody(this.verificationId, this.name, this.email,
      {super.key});
}

class _VerificationBodyState extends State<VerificationBody> {
  late Timer _timer;
  int _start = 120;
  final _codeController = TextEditingController();
  bool verifying = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: NormalText(
        text: Utils.translate("verification_code"),
        textSize: kTitleFontSize,
        fontWeight: FontWeight.w400,
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
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 30.0,
                      bottom: 0,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.transparent,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 150,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: kBlackFontColor.withOpacity(0.3),
                                        blurRadius: 20.0,
                                        spreadRadius: 1.0)
                                  ],
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Utils.isDarkMode
                                      ? kDarkBgColor
                                      : kWhiteColor,
                                ),
                                child: Column(
                                  children: [
                                    InputTextField(
                                      placeHolder: Utils.translate(
                                          "insert_verification_code"),
                                      icon: Icons.tag,
                                      controller: _codeController,
                                      textSize: kNormalFontSize,
                                      inputType: TextInputType.number,
                                      autofocus: true,
                                    ),
                                    LineWidget(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _start = 120;
                                            });
                                            startTimer();
                                          },
                                          child: NormalText(
                                            text:
                                                "${Utils.translate("expiry_time")}: $_start",
                                            textAlign: TextAlign.end,
                                            textColor: _start == 0
                                                ? kButtonColor
                                                : kBottomIconColor,
                                          ),
                                        ),
                                      ),
                                    )
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
                                    buttonTitle: _start == 0
                                        ? Utils.translate("resend")
                                        : verifying
                                            ? Utils.translate("verifying")
                                            : Utils.translate("verify"),
                                    onPress: () async {
                                      if (_start == 0) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LoginBody()),
                                        );
                                      } else {
                                        setState(() {
                                          verifying = true;
                                        });

                                        await context.read<AuthenticationService>().signUpWithCredential(
                                              verificationId: widget.verificationId,
                                              code: _codeController.text.trim(),
                                              name: widget.name,
                                              email: widget.email,
                                              context: context,
                                            );
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        verifying
                            ? Container(
                                child: CircularProgressIndicator(
                                  color: kButtonColor,
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Container(),
                      ],
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
