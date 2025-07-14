import 'dart:io';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:flutter/material.dart';

typedef StringCallback = void Function(File val);
showPicker(context, StringCallback callback) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.photo_library,
                      color: Utils.getColorMode(),
                    ),
                    title: NormalText(
                      text: Utils.translate("gallery"),
                      textColor: Utils.getColorMode(),
                    ),
                    onTap: () async {
                      var image = await Utils.imgFromGallery();
                      callback(image!);
                    }),
                ListTile(
                  leading: Icon(
                    Icons.photo_camera,
                    color: Utils.getColorMode(),
                  ),
                  title: NormalText(
                    text: Utils.translate("camera"),
                    textColor: Utils.getColorMode(),
                  ),
                  onTap: () async {
                    var image = await Utils.imgFromCamera();
                    navigatorPlus.back();
                    callback(image!);
                  },
                ),
              ],
            ),
          ),
        );
      });
}
