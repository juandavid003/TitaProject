// ignore_for_file: must_be_immutable, must_call_super

import 'package:odontobb/models/purchase_model.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/purchases_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
// import 'package:flutter_launch/flutter_launch.dart';
import '../../../constant.dart';
import '../../../util.dart';

class PayPage extends StatefulWidget {
  String subscriptionTitle = 'Subscripción Anual';
  double subscriptionPrice = 29.5;

  PayPage({super.key});

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  ChildrenService childrenService = ChildrenService();
  final PurchasesService _purchasesService = PurchasesService();
  AuthenticationService authenticationService =
      AuthenticationService(FirebaseAuth.instance);
  bool year = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    getInfo();
  }

  getInfo() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
      appBar: AppBar(
          title: NormalText(
        text: Utils.translate("odontobb_client"),
        textSize: kPriceFontSize,
        fontWeight: FontWeight.w600,
      )),
      body: Container(
          child: ListView(
        children: [
          _ListTilePremiumBenefits(
              title: 'Tips Ilimitados',
              subtitle: 'Puede acceder en cualquier momento a todos los tips',
              icon: Icon(Icons.question_answer_sharp)),
          Divider(),
          _ListTilePremiumBenefits(
              title: 'Consultas 24 horas',
              subtitle:
                  'Accede a todas las consultas especializadas por edades y consúltalas todas las veces que quieras.',
              icon: Icon(Icons.local_hospital)),
          Divider(),
          _ListTilePremiumBenefits(
              title: 'Asistente de cepillado, TITA.',
              subtitle:
                  'Puede acceder al asistente lúdico de cepillado, TITA. Que te ayudará con el correcto cepillado de tu niño. ',
              icon: Icon(Icons.timer)),
          Divider(),
          _ListTilePremiumBenefits(
              title: 'Premios todos los días',
              subtitle:
                  'Por cada vez que usas a TITA como ayuda para cepillarle los dientecitos a tu niño ganas premios. ',
              icon: Icon(Icons.card_giftcard)),
          Divider(),
          SizedBox(height: 50.0),
          // ListTile(
          //     selectedTileColor: kButtonColor,
          //     selected: year,
          //     title: NormalText(
          //       textOverflow: TextOverflow.ellipsis,
          //       text: 'Anual - Ahorre un 50%',
          //       textColor: Utils.getColorMode(),
          //       textSize: kNormalFontSize,
          //       fontWeight: FontWeight.w600,
          //       textAlign: TextAlign.left,
          //     ),
          //     subtitle: NormalText(
          //       textOverflow: TextOverflow.visible,
          //       text: '\$ 29,50 / anual. Antes (\$ 59,99)',
          //       textColor: Utils.getColorMode(),
          //       textSize: kTitleFontSize,
          //       textAlign: TextAlign.left,
          //     ),
          //     onTap: () async {
          //       setState(() {
          //         widget.subscriptionPrice = 0.0;
          //         year = true;
          //       });
          //       await Future.delayed(Duration(seconds: 1));
          //       setState(() {
          //         widget.subscriptionTitle = 'Subscripción Anual';
          //         widget.subscriptionPrice = 29.5;
          //       });
          //     }),
          // ListTile(
          //     selectedTileColor: kButtonColor,
          //     selected: !year,
          //     title: NormalText(
          //       textOverflow: TextOverflow.ellipsis,
          //       text: 'Mensual - gratis los primeros 3 días',
          //       textColor: Utils.getColorMode(),
          //       textSize: kNormalFontSize,
          //       fontWeight: FontWeight.w600,
          //       textAlign: TextAlign.left,
          //     ),
          //     subtitle: NormalText(
          //       textOverflow: TextOverflow.visible,
          //       text: '\$ 4,99 / mensual',
          //       textColor: Utils.getColorMode(),
          //       textSize: kTitleFontSize,
          //       textAlign: TextAlign.left,
          //     ),
          //     onTap: () async {
          //       setState(() {
          //         widget.subscriptionPrice = 0.0;
          //         year = false;
          //       });
          //       await Future.delayed(Duration(seconds: 1));
          //       setState(() {
          //         widget.subscriptionTitle = 'Subscripción Mensual';
          //         widget.subscriptionPrice = 4.99;
          //       });
          //     }),
          ListTile(
              selectedTileColor: kButtonColor,
              selected: year,
              title: NormalText(
                textOverflow: TextOverflow.ellipsis,
                text: '¿Quieres ser miembro de OdontoBb?',
                textColor: Utils.getColorMode(),
                textSize: kNormalFontSize,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
              ),
              subtitle: NormalText(
                textOverflow: TextOverflow.visible,
                text: 'Contáctanos y obten grades beneficios',
                textColor: Utils.getColorMode(),
                textSize: kTitleFontSize,
                textAlign: TextAlign.left,
              ),
              onTap: () async {
                // await FlutterLaunch.launchWhatsapp(
                //         phone: "593962635101",
                //         message: Utils.translate("whatsapp_message_contact"))
                //     .then((value) {
                //   Navigator.pop(context);
                // });
              }),
          SizedBox(height: 20.0),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.subscriptionPrice != 0.0
                  ? _btnBuyProduct(context)
                  : CircularProgressIndicator(
                      color: kButtonColor,
                    )
            ],
          )
        ],
      )),
    );
  }

  _btnBuyProduct(BuildContext context) {
    // final _paymentItems = [
    //   PaymentItem(
    //       label: widget.subscriptionTitle,
    //       amount: widget.subscriptionPrice.toString(),
    //       status: PaymentItemStatus.final_price)
    // ];
    // return Row(children: [
    //   ApplePayButton(
    //     paymentConfigurationAsset: 'applepay.json',
    //     paymentItems: _paymentItems,
    //     width: 200,
    //     height: 50,
    //     style: ApplePayButtonStyle.black,
    //     type: ApplePayButtonType.subscribe,
    //     margin: const EdgeInsets.only(top: 15.0),
    //     onPaymentResult: onPayResult,
    //     loadingIndicator: const Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   ),
    //   GooglePayButton(
    //     paymentConfigurationAsset: 'gpay.json',
    //     paymentItems: _paymentItems,
    //     style: GooglePayButtonStyle.black,
    //     type: GooglePayButtonType.pay,
    //     margin: const EdgeInsets.only(top: 15.0),
    //     onPaymentResult: onPayResult,
    //     loadingIndicator: const Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   ),
    // ]);
    return Container();
  }

  void onPayResult(paymentResult) {
    // Send the resulting Apple Pay token to your server / PSP
    PurchaseModel purchase = PurchaseModel();
    purchase.productId = widget.subscriptionTitle;
    purchase.userId = Utils.globalFirebaseUser!.uid;
    purchase.price = widget.subscriptionPrice;

    _purchasesService.save(purchase).then((value) {
      authenticationService.activeClient(true);
      Navigator.of(context).pop();
    });
  }
}

class _ListTilePremiumBenefits extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;

  const _ListTilePremiumBenefits(
      {required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: icon,
        title: NormalText(
          textOverflow: TextOverflow.ellipsis,
          text: title,
          textColor: Utils.getColorMode(),
          textSize: kSmallFontSize,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.left,
        ),
        subtitle: NormalText(
          textOverflow: TextOverflow.visible,
          text: subtitle,
          textColor: Utils.getColorMode(),
          textSize: kMicroFontSize,
          textAlign: TextAlign.left,
        ));
  }
}
