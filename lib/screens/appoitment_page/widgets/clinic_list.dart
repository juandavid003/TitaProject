import 'package:odontobb/models/clinics_model.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/util.dart';
import '../../../constant.dart';
import '../../../widgets/custom_elements/normal_text.dart';

// ignore: must_be_immutable
class ClinicList extends StatefulWidget {
  ClinicsModel clinicModel;

  @override
  // ignore: library_private_types_in_public_api
  _ClinicListState createState() => _ClinicListState();

  ClinicList(this.clinicModel, {super.key});
}

class _ClinicListState extends State<ClinicList> {
  @override
  void initState() {
    loadInit();
    super.initState();
  }

  loadInit() async {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          //color: Utils.isDarkMode ? kDarkItemColor : kWhiteColor,
          decoration: BoxDecoration(
            color: Utils.isDarkMode ? kDarkItemColor : kWhiteColor,
            boxShadow: [
              BoxShadow(
                color: Utils.isDarkMode
                    ? kDarkBgColor
                    : Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: ListTile(
            title: NormalText(
              textOverflow: TextOverflow.ellipsis,
              text: widget.clinicModel.name!,
              textColor: Utils.getColorMode(),
              textSize: kSmallFontSize,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.left,
            ),
            subtitle: NormalText(
              textOverflow: TextOverflow.visible,
              text: widget.clinicModel.address!,
              textColor: Utils.getColorMode(),
              textSize: kMicroFontSize,
              textAlign: TextAlign.left,
            ),
            leading: SizedBox(
              width: 50, // Ajusta el tamaño según tu diseño
              height: 50,
              child: _getImage(context, widget.clinicModel),
            ),
          ),
        ));
  }

  Widget _getImage(BuildContext context, ClinicsModel clinic) {
    if (clinic.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(clinic.imageUrl!,
            fit: BoxFit.fitWidth, width: 70.0, height: 70.0),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: FutureBuilder(
          future: FileService.loadImage('clinics/${clinic.image!}'),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              clinic.imageUrl = snapshot.data!;
              return Image.network(clinic.imageUrl!,
                  fit: BoxFit.fitWidth, width: 70.0, height: 70.0);
            } else {
              return ShimmerWidget(
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    color: kWhiteColor,
                  ),
                ),
              );
            }
          },
        ),
      );
    }
  }
}
