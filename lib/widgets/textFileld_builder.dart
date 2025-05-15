// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:odontobb/widgets/default_texfromfield.dart';
import '../constant.dart';
import '../util.dart';

// ignore: must_be_immutable
class InputTextField extends StatefulWidget {
  IconData icon;
  String placeHolder;
  Color? bgColor;
  TextEditingController? controller;
  GestureTapCallback? onTap;
  double? textSize;
  TextInputType? inputType;
  FormFieldValidator<String>? validate;
  bool autofocus;

  InputTextField(
      {super.key,
      required this.icon,
      required this.placeHolder,
      this.bgColor,
      this.controller,
      this.onTap,
      this.textSize = 15.0,
      this.inputType = TextInputType.text,
      this.validate,
      this.autofocus = false});

  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  @override
  Widget build(BuildContext context) {
    widget.bgColor ??= Utils.isDarkMode ? kDarkBgColor : kWhiteColor;
    return CustomTextFromField(
      autofocus: widget.autofocus,
      suffixIcon: widget.icon,
      suffixIconColor: kAppColor,
      isMasked: false,
      bgColor: widget.bgColor!,
      ispassword: false,
      placeHolder: widget.placeHolder,
      inputType: widget.inputType!,
      controller: widget.controller!,
      onTap: widget.onTap,
      textSize: widget.textSize!,
      validate: widget.validate,
    );
  }
}
