import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:flutter/material.dart';
import '../../constant.dart';
import '../../util.dart';
import '../card_widget.dart';

// ignore: must_be_immutable
class CustomDropDownButton extends StatefulWidget {
  List<String> dropDownButtonItems = [];
  String placeHolder;
  CustomDropDownButton(
      {super.key,
      required this.dropDownButtonItems,
      required this.placeHolder});

  @override
  _CustomDropDownButtonState createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  var dropdownvalue;
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      childWidget: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Utils.isDarkMode ? kDarkGrayColor : kWhiteColor,
          value: dropdownvalue,
          hint: NormalText(
              text: widget.placeHolder,
              textColor: Utils.isDarkMode
                  ? kDarkTextColorColor
                  : kLightBlackTextColor),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: kAppColor,
            size: 25,
          ),
          iconSize: 28,
          elevation: 20,
          onChanged: (String? newval) {
            setState(() {
              dropdownvalue = newval;
            });
          },
          items: widget.dropDownButtonItems
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: TextStyle(
                      color: Utils.isDarkMode
                          ? kDarkBlackTextColor
                          : kLightBlackTextColor,
                      fontSize: kSmallFontSize)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
