// ignore_for_file: unused_field

import 'dart:io';
import 'package:odontobb/helpers/showPicker.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/line_widget.dart';
import 'package:odontobb/widgets/textFileld_builder.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:provider/provider.dart';
import '../../../util.dart';

class ProfileEditBody extends StatefulWidget {
  const ProfileEditBody({super.key});

  @override
  _ProfileEditBodyState createState() => _ProfileEditBodyState();
}

class _ProfileEditBodyState extends State<ProfileEditBody> {
  AuthenticationService authenticationService =
      AuthenticationService(FirebaseAuth.instance);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late String _personId;
  double avatarHeight = 0;
  late File _image;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    await Future.delayed(Duration(seconds: Utils.loadingTime));
    if (mounted) setState(() {});
  }

  setInfo() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    _nameController.text = firebaseUser.displayName!;
    _emailController.text = firebaseUser.email!;

    return Scaffold(
      appBar: AppBar(
          title: NormalText(
        text: Utils.translate("update_profile"),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 30.0,
                      bottom: 0,
                    ),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.transparent,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 275,
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
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () async {
                                      showPicker(context, (val) {
                                        setState(() {
                                          _image = val;
                                        });
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: (50 - avatarHeight),
                                      backgroundColor: Colors.red,
                                      backgroundImage: FileImage(_image),
                                    ),
                                  ),
                                ),
                                InputTextField(
                                    placeHolder: Utils.translate("name"),
                                    icon: Icons.person,
                                    controller: _nameController),
                                LineWidget(),
                                // InputTextField(
                                //     placeHolder: Utils.translate("email"),
                                //     icon: Icons.email,
                                //     controller: _emailController),
                                // LineWidget(),
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
                                buttonTitle: Utils.translate("save"),
                                onPress: () async {
                                  await authenticationService
                                      .updateUserProfile(
                                          firebaseUser,
                                          _nameController.text,
                                          _emailController.text)
                                      .then((value) {
                                    firebaseUser.reload();
                                    print(firebaseUser.displayName);
                                    Navigator.pop(context);
                                  });
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
      ),
    );
  }
}
