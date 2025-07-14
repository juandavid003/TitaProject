import 'package:odontobb/constant.dart';
import 'package:flutter/material.dart';
import '../util.dart';

// ignore: must_be_immutable
class CustomTextFromField extends StatelessWidget {
  final bool ispassword;
  final String placeHolder;
  final bool autofocus;
  final TextInputType inputType;
  final double height;
  final Color bgColor;
  final Color suffixIconColor;
  final Color placeHolderColor;
  bool isMasked = false;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final FormFieldSetter<String>? onSave;
  final FormFieldValidator<String>? validate;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final IconData suffixIcon;
  final double textSize;
  TextEditingController controller = TextEditingController();

  CustomTextFromField({
    super.key,
    required this.placeHolder,
    this.inputType = TextInputType.text,
    required this.ispassword,
    this.onChanged,
    required this.onTap,
    required this.isMasked,
    required this.validate,
    this.onFieldSubmitted,
    this.onSave,
    this.focusNode,
    required this.controller,
    required this.suffixIcon,
    this.placeHolderColor = kBlackFontColor,
    this.suffixIconColor = kWhiteColor,
    this.bgColor = kWhiteColor,
    this.autofocus = false,
    this.height = 60.0,
    this.maxLines = 1,
    this.minLines = 1,
    this.textSize = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: bgColor,
      ),
      height: height,
      child: TextFormField(
        minLines: minLines,
        maxLines: maxLines,
        controller: controller,
        autofocus: autofocus,
        focusNode: focusNode,
        validator: validate,
        onChanged: onChanged,
        onTap: onTap,
        textInputAction: TextInputAction.done,
        obscureText: ispassword,
        style: TextStyle(color: Utils.getColorMode(), fontSize: textSize),
        decoration: InputDecoration(
          suffixIcon: Icon(
            suffixIcon,
            color: Utils.isDarkMode ? kWhiteColor : suffixIconColor,
          ),
          border: InputBorder.none,
          hintText: placeHolder,
          hintStyle: TextStyle(
            color: Utils.isDarkMode ? kWhiteColor : placeHolderColor,
            fontSize: textSize,
          ),
          labelStyle: TextStyle(
              fontSize: textSize,
              letterSpacing: 0.3,
              color: Utils.isDarkMode ? kDarkTextColorColor : kBlackFontColor,
              fontWeight: FontWeight.w400),
        ),
        onSaved: onSave,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: inputType,
      ),
    );
  }
}
