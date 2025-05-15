import 'package:odontobb/models/clinics_model.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/screens/appoitment_page/components/appoitment_form.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/clinics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/screens/appoitment_page/widgets/clinic_list.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import '../../../constant.dart';

class ClinicBuilder extends StatefulWidget {
  @override
  _ClinicBuilderState createState() => _ClinicBuilderState();
  final List<ClinicsModel> clinicList;
  final int limit;
  final bool isScroll;
  final PersonModel? personModel;

  const ClinicBuilder(
      {super.key,
      required this.clinicList,
      required this.limit,
      required this.isScroll,
      this.personModel});
}

class _ClinicBuilderState extends State<ClinicBuilder> {
  ClinicsService clinicService = ClinicsService();
  final ScrollController _scrollController = ScrollController();
  AuthenticationService authenticationService =
      AuthenticationService(FirebaseAuth.instance);
  bool _isLoading = false;
  bool client = true; //default false

  @override
  void initState() {
    super.initState();
    getInfo();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadClinics(widget.clinicList.last, widget.clinicList.length >= 2);
      }
    });
  }

  getInfo() async {
    //client = await authenticationService.isClient();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.clinicList.isNotEmpty
        ? Stack(children: [
            _listItems(context),
            _createLoading(),
          ])
        : ShimmerWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_itemShimmerClinic(context)],
            ),
          );
  }

  ListView _listItems(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: widget.isScroll != true
          ? NeverScrollableScrollPhysics()
          : AlwaysScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClinicList(widget.clinicList[index]),
          ),
          // onTap: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) {
          //       ClinicsModel clinic = widget.clinicList[index];
          //       return AppoitmentForm(clinicModel: clinic, personModel: widget.personModel);
          //     }),
          //   );
          // },
        );
      },
      itemCount: widget.clinicList.isNotEmpty
          ? widget.clinicList.length
          : widget.limit,
    );
  }

  Widget _createLoading() {
    if (_isLoading) {
      return Container(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: kButtonColor,
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _loadClinics(ClinicsModel lastClinic, bool checkClient) async {
    // client = await authenticationService.isClient();
    // if (checkClient && !client) {
    //   navigatorPlus.showModal(PayScreen());
    // } else {
    List<ClinicsModel> newClinics = [];
    do {
      _isLoading = true;
      setState(() {});
      newClinics = await clinicService.get(); //clinic(10, lastClinic);
      widget.clinicList.addAll(newClinics);
      if (newClinics.isNotEmpty) {
        _scrollController.animateTo(_scrollController.position.pixels + 250,
            duration: Duration(milliseconds: 250), curve: Curves.fastOutSlowIn);
      }
      newClinics = [];
      _isLoading = false;
      setState(() {});
    } while (newClinics.isNotEmpty);
    //}
  }

  Widget _itemShimmerClinic(BuildContext context) {
    ClinicsModel clinicShimmer = ClinicsModel();
    clinicShimmer.name = "Loading...";
    clinicShimmer.address = "Loading...";
    clinicShimmer.imageUrl = null;
    clinicShimmer.image = "";
    clinicShimmer.phones = ["000-000-0000"];

    return SizedBox(
      height: MediaQuery.of(context).size.height *
          0.6, // Ajuste de altura si es necesario
      child: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(2.0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ClinicList(clinicShimmer),
          );
        },
      ),
    );
  }
}
