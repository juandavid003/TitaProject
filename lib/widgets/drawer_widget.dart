import 'package:odontobb/screens/bbcash_use_policy/bbcash_use_policy_screen.dart';
import 'package:odontobb/screens/patient_page/patient_page_screen.dart';
import 'package:odontobb/screens/profile_page/profile_page_screen.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odontobb/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/screens/privacy_policy_page/privacy_policy_screen.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';
import '../constant.dart';
import '../util.dart';
import 'app_builder.dart';
import 'custom_elements/custom_dialog_box.dart';
import 'custom_elements/normal_text.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late LanguageModel currentLang;
  bool switchValue = Utils.isDarkMode;
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    getInfo();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        appVersion = packageInfo.version;
      });
    }
  }

  getInfo() async {
    if (mounted) {
      setState(() {
        currentLang = languages.firstWhere(
            (element) => element.lanCode == Utils.appLocale.languageCode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User firebaseUser = context.watch<User>();

    return Container(
      color: Utils.isDarkMode ? kDarkBgColor : kWhiteColor,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          _buildUserInfo(firebaseUser),
          _buildMenuItems(context),
          Spacer(),
          _buildDeleteAccountButton(context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUserInfo(User firebaseUser) {
    final bool hasProfileInfo = (firebaseUser.displayName != null &&
            firebaseUser.displayName!.isNotEmpty) ||
        (firebaseUser.email != null && firebaseUser.email!.isNotEmpty);

    return Padding(
      padding: const EdgeInsets.only(top: 60.0, left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasProfileInfo) ...[
            // Mostrar información del perfil si existe
            NormalText(
              text: firebaseUser.displayName ?? '',
              textColor: Utils.getColorMode(),
              fontWeight: FontWeight.w600,
              textSize: kTitleFontSize,
            ),
            NormalText(
              text: firebaseUser.email ?? '',
              textColor: Utils.getColorMode(),
              textSize: kMicroFontSize,
            ),
          ] else ...[
            // Mostrar mensaje para completar perfil si no hay información
            Container()
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: Utils.isDarkMode
            //         ? kDarkItemColor
            //         : Colors.blue.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(
            //       color: kAppColor.withOpacity(0.5),
            //       width: 1,
            //     ),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.person_outline,
            //             color: kAppColor,
            //             size: 20,
            //           ),
            //           SizedBox(width: 8),
            //           NormalText(
            //             text:
            //                 "Completar perfil", // Texto directo en lugar de traducción
            //             textColor: kAppColor,
            //             fontWeight: FontWeight.w600,
            //             textSize: kSmallFontSize,
            //           ),
            //         ],
            //       ),
            //       SizedBox(height: 8),
            //       NormalText(
            //         text:
            //             "Por favor, completa tu información de perfil para una mejor experiencia.",
            //         textColor: Utils.getColorMode(),
            //         textSize: kMicroFontSize,
            //         maxLines: 3,
            //       ),
            //       SizedBox(height: 8),
            //       Align(
            //         alignment: Alignment.centerRight,
            //         child: TextButton(
            //           onPressed: () {
            //             // Cerrar el drawer y navegar a la pantalla de perfil
            //             Navigator.pop(context);
            //             navigatorPlus.show(ProfilePageScreen());
            //           },
            //           style: TextButton.styleFrom(
            //             backgroundColor: kAppColor,
            //             padding:
            //                 EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20),
            //             ),
            //           ),
            //           child: NormalText(
            //             text: "Editar perfil",
            //             textColor: Colors.white,
            //             textSize: kMicroFontSize,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
          Divider(color: Colors.grey.withOpacity(0.7)),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _drawerItem(context, Utils.translate("manage_patients"),
        //     onTap: () => navigatorPlus.show(PatientPageScreen())),
        _drawerItem(context, Utils.translate("privacy_policy"),
            onTap: () => navigatorPlus.show(PrivacyPolicyPage())),
        _drawerItem(context, Utils.translate("bbcash_use_policy"),
            onTap: () => navigatorPlus.show(BbCashPolicyPage())),
        _drawerItem(context, Utils.translate("logout"),
            onTap: () => context.read<AuthenticationService>().signOut()),
        _buildLanguageSelector(),
      ],
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: Utils.translate("delete_acount"),
                    descriptions: Utils.translate("delete_acount_description"),
                    textBtnAcept: Utils.translate("delete"),
                  );
                },
              ).then((value) {
                if (value) {
                  context.read<AuthenticationService>().signOut();
                }
              });
            },
            child: NormalText(
              text: Utils.translate("delete_acount"),
              textColor: Colors.red,
              textSize: kMicroFontSize,
            ),
          ),
          NormalText(
            text: 'v$appVersion',
            textColor: Colors.grey,
            textSize: kMicroFontSize,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: NormalText(
          text: title,
          textColor: Utils.getColorMode(),
          textSize: kSmallFontSize,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NormalText(
            text: Utils.translate("languages"),
            textColor: Utils.getColorMode(),
            textSize: kSmallFontSize,
          ),
          DropdownButton<LanguageModel>(
            value: currentLang,
            icon: const Icon(Icons.arrow_drop_down, color: kAppColor),
            iconSize: 30,
            underline: Container(),
            onChanged: (newValue) {
              if (newValue != null && currentLang.lanCode != newValue.lanCode) {
                setState(() {
                  currentLang = newValue;
                  Utils.appLocale =
                      Locale(newValue.lanCode!, newValue.lanCountry);
                  ApplicationLocalizations.of(context)!.appLocale =
                      Utils.appLocale;
                  ApplicationLocalizations.of(context)!.load();
                  AppBuilder.of(context)!.rebuild();
                });
              }
            },
            items: languages.map((value) {
              return DropdownMenuItem<LanguageModel>(
                value: value,
                child: Row(
                  children: [
                    NormalText(
                      text: value.langName!,
                      textColor: Utils.getColorMode(),
                    ),
                    SizedBox(width: 10.0),
                    NormalText(text: value.emoji!, textSize: 20.0),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
