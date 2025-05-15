import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/services/clinics_service.dart';
import 'package:odontobb/screens/appoitment_page/widgets/clinic_builder.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/models/clinics_model.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constant.dart';
import '../../../util.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class AppoitmentBody extends StatefulWidget {

  final PersonModel? personModel;

  const AppoitmentBody({super.key, this.personModel});

  @override
  _AppoitmentBodyState createState() => _AppoitmentBodyState();
}

class _AppoitmentBodyState extends State<AppoitmentBody> {
  ClinicsService clinicsService = ClinicsService();
  ChildrenService childrenService = ChildrenService();
  final storage = const FlutterSecureStorage();
   
  List<ClinicsModel> _clinicsList = List.empty();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    loadInit();
    super.initState();
  }

  loadInit() async {
    final clinicsList = await clinicsService.get();
    if (mounted) {
      setState(() {
        _clinicsList = clinicsList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    //_phoneController.text = firebaseUser.phoneNumber!;

    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
      key: key,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
              text: Utils.translate("appoitment"),
              textSize: kTitleFontSize,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          NormalText(
            text: Utils.translate("clinic-appt"),
            textSize: kNormalFontSize,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: Stack(
              children: [
                ClinicBuilder(
                  clinicList: _clinicsList,
                  limit: 10,
                  isScroll: true,
                  personModel:widget.personModel
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
