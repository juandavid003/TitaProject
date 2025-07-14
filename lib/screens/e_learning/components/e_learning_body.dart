// ignore_for_file: unused_field, unnecessary_import, library_private_types_in_public_api, prefer_final_fields

import 'package:odontobb/models/product_model.dart';
import 'package:odontobb/models/tip.dart';
import 'package:odontobb/delegates/search_delegate.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/products_service.dart';
import 'package:odontobb/services/tips_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/product_slider.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:provider/provider.dart';
import '../../../util.dart';

class ELearningBody extends StatefulWidget {
  const ELearningBody({super.key});

  @override
  _ELearningBodyState createState() => _ELearningBodyState();
}

class _ELearningBodyState extends State<ELearningBody> {
  List<TipModel> _tipList = [];
  final TipsService tipsService = TipsService();
  final AuthenticationService _authenticationService =
      AuthenticationService(FirebaseAuth.instance);
  bool client = false;
  final ProductsService productsService = ProductsService();

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    try {
      await Future.delayed(Duration(seconds: Utils.loadingTime));
      client = await _authenticationService.isClient();
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
              text: Utils.translate("e_learning"),
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
      body: Column(
        children: [
          Expanded(
            child: _productSlider(),
          ),
        ],
      ),
    );
  }

  Widget _productSlider() {
    return FutureBuilder(
      future: productsService.get(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerWidget(
            child: ProductSlider(
              products: List.generate(
                  6, (_) => ProductModel(title: '', category: '')),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return ProductSlider(products: [...snapshot.data!]);
        } else {
          return const Center(
            child: Text('No hay productos disponibles'),
          );
        }
      },
    );
  }
}
