// ignore_for_file: unused_field, unnecessary_import, library_private_types_in_public_api, prefer_final_fields

import 'package:odontobb/models/tip.dart';
import 'package:odontobb/delegates/search_delegate.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/tips_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/tip.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:provider/provider.dart';
import '../../../util.dart';

class DidYouKnowBody extends StatefulWidget {
  const DidYouKnowBody({super.key});

  @override
  _DidYouKnowBodyState createState() => _DidYouKnowBodyState();
}

class _DidYouKnowBodyState extends State<DidYouKnowBody> {
  List<TipModel> _tipList = List.empty();
  TipsService tipsService = TipsService();
  AuthenticationService _authenticationService =
      AuthenticationService(FirebaseAuth.instance);
  bool client = true; //default false

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    try {
      await Future.delayed(Duration(seconds: Utils.loadingTime));
      //client = await _authenticationService.isClient();
      final tipList = await tipsService.tips(2, null);
      if (mounted) {
        setState(() {
          _tipList = tipList;
        });
      }
    } catch (e) {
      debugPrint('Error cargando información: $e');
      // Aquí podrías mostrar un mensaje de error al usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observar el usuario actual sin asignar a variable global
    final currentUser = context.watch<User?>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
              text: Utils.translate("did_you_know"),
              textSize: kTitleFontSize,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => showSearch(
                  context: context,
                  delegate: TipsSearchDelegate(client: client)))
        ],
      ),
      body: Stack(
        children: [
          TipBuilder(
            tipList: _tipList,
            limit: 2,
            isScroll: true,
          ),
        ],
      ),
    );
  }
}
