import 'package:odontobb/app_localizations.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import '../util.dart';

class AppIntroModel {
 String? title;
  String? desc;
  bool? visibleButton;
  String? image; 

  AppIntroModel({this.title, this.desc, this.visibleButton, this.image});
}

List<AppIntroModel> appIntroList = [
  AppIntroModel(
      title: Utils.translate("step1"),
      desc: ApplicationLocalizations.of(navigatorPlus.currentContext)!
          .translate("step1_description"),
      visibleButton: true,
      image: "assets/images/App_Educar.png"),
  AppIntroModel(
      title: Utils.translate("step2"),
      desc: ApplicationLocalizations.of(navigatorPlus.currentContext)!
          .translate("step2_description"),
      visibleButton: true,
      image: "assets/images/App_Prevenir.png"),
  AppIntroModel(
      title: Utils.translate("step3"),
      desc: ApplicationLocalizations.of(navigatorPlus.currentContext)!
          .translate("step3_description"),
      visibleButton: false,
      image: "assets/images/App_Divertise.png")
];
