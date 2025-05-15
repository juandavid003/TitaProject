import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:odontobb/screens/brush_page/components/brush_body_ar.dart';
import 'package:odontobb/screens/brush_page/components/brush_body_ar_all.dart';
import 'package:odontobb/screens/brush_page/components/brush_body_ar_android.dart';
import 'package:odontobb/screens/brush_page/components/brush_body_ios.dart';
import 'package:odontobb/widgets/base_scaffold.dart';

import 'components/brush_body.dart';

class BrushScreen extends StatelessWidget {
  const BrushScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget body;

     if (Platform.isIOS) {
      body = ArBrushPageIos();
    } else {
      // body = BrushPage();
      // body = ArBrushPageAndroid();
    //return BaseScaffold(body: ArBrushPage());
    //return BaseScaffold(body: ArBrushPageAll());
   return BaseScaffold(body: BrushPage());
    }
    return BaseScaffold(body: body);
  }
}







