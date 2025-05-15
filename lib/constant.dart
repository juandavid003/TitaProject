import 'package:flutter/material.dart';

//Listh Colors
const kPrimaryColor = Color(0xFFFFFFFF);
const kPrimaryLightColor = Color(0xFFEB793A);
const kWhiteColor = Color(0xFFFFFFFF);
const kWhiteColorBlok = Color.fromRGBO(255, 255, 255, 0.3);
const kButtonColor = Color(0xFFF38000);
const kLightBlackTextColor = Color(0xFF727272);
const kDefaultBgColor = Color(0xFFFAFAFA);
const kItemBgColor = Color(0xFFEDEDED);
const kAppColor = Color(0xFF312DA4);
const kGrayColor = Colors.grey;
const kFacebookColor = Color(0xFF5B7BAF);
const kBlackFontColor = Color(0xFF212832);
const kBlackFontColorBlock = Color.fromRGBO(0, 0, 0, 0.3);
const kCardColorColor = Color(0xFFFFFFFF);
const kBottomIconColor = Color(0xFFC6C6C6);
const kTextColorColor = Color(0xFF727272);
const kLightCardColorColor = Color(0xFFFAFAFA);
//DarkColors
const kDarkPrimaryColor = Color(0xFF343434);
const kDarkPrimaryLightColor = Color(0xFF343434);
const kDarkColor = Color(0xFF343434);
const kDarkButtonColor = Color(0xFF7292E5);
const kDarkItemColor = Color(0xFF67697E);
const kDarkBlackTextColor = Color(0xFFFFFFFF);
const kDarkDefaultBgColor = Color(0xFF343434);
const kDarkAppColor = Color(0xFFEB793A);
const kDarkGrayColor = Color(0xFF727272);
const kDarkDarkItemColor = Color(0xFF383E47);
const kDarkFacebookColor = Color(0xFF5B7BAF);
const kDarkCardColorColor = kDarkColor;
const kDarkBottomIconColor = Colors.grey;
const kDarkBlackFontColor = kAppColor;
const kDarkTextColorColor = Color(0xFFC6C6C6);
const kDarkLightCardColorColor = Color(0xFF5B5B5B);
const kDarkBLackBgColor = Color(0xFF47495B);
const kDarkBgColor = Color(0xFF3D3F51);

//FontSizes
const kExtraExtraMicroFontSize = 8.0;
const kExtraMicroFontSize = 10.0;
const kMicroFontSize = 12.0;
const kSmallFontSize = 15.0;
const kSubTitleFontSize = 16.0;
const kTitleFontSize = 18.0;
const kNormalFontSize = 20.0;
const kPriceFontSize = 25.0;
const kLargeFontSize = 30.0;
const kSwiperButtonsFontSize = 45.0;
const kExtraLargeFontSize = 50.0;
//
const kiPhoneImg = "assets/images/iphone11.jpeg";
const kEmptyImage = "assets/images/emptyImage.gif";
//Strings

const kLoginButton = "Giriş";
const kFaceLoginButton = "Login With Facebook";
const kGoogleLoginButton = "Login With Google";
//
// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 15),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

const kPadding = 10.0;
const kAvatarRadius = 20.0;

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: kLightBlackTextColor),
  );
}
