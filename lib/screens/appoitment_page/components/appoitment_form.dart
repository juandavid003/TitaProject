// ignore_for_file: unused_field, must_be_immutable

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:odontobb/models/appoitment_model.dart';
import 'package:odontobb/models/clinics_model.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/services/appoitment_service.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/services/clinics_service.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/services/purchases_service.dart';
import 'package:odontobb/widgets/card_widget.dart';
import 'package:odontobb/widgets/custom_elements/default_buton.dart';
import 'package:odontobb/widgets/line_widget.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AppoitmentForm extends StatefulWidget {
  @override
  _AppoitmentFormState createState() => _AppoitmentFormState();
  bool? fromHomeScreen; // Recibe la variable
  final appointmentData;
  final PersonModel? personModel;
  final Function(bool)? onChanged; // Función callback

  final ClinicsModel clinicModel;

  @override
  AppoitmentForm(
      {super.key,
      required this.clinicModel,
      this.fromHomeScreen = false,
      this.appointmentData = null,
      this.personModel,
      this.onChanged});
}

class _AppoitmentFormState extends State<AppoitmentForm> {
  final PurchasesService _purchasesService = PurchasesService();
  final AuthenticationService _authenticationService =
      AuthenticationService(FirebaseAuth.instance);
  AppoitmentService appoitmentService = AppoitmentService();
  ChildrenService childrenService = ChildrenService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNamesController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _dateController = TextEditingController();

  DateTime dateAppt = DateTime.now();
  PersonModel? _selectChildren;
  ClinicsModel _selectClinic = ClinicsModel();
  String _selectHour = '';
  int steep = 1;
  String hourMessage = '';
  DateTime? _selectedDate;
  List<PersonModel> childrens = [];

  //bool client = false;
  bool autoPlay = true;
  int? appointmentId;
  bool isStatusUpdated = false;
  String message = "";

  final YoutubePlayerController _controller = YoutubePlayerController();

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

getInfo() async {
  childrens = await childrenService.get();
  if (childrens.isNotEmpty) {
    _selectChildren = childrens.first;
  } else {
    _selectChildren = null;
  }
  await Future.delayed(Duration(seconds: Utils.loadingTime));
  if (mounted) setState(() {});
}


  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final headerResume = Hero(
      tag: widget.clinicModel.name ?? "defaultTag",
      child: Material(
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: (widget.clinicModel.imageUrl != null &&
                    widget.clinicModel.imageUrl!.isNotEmpty)
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.clinicModel.imageUrl!),
                  )
                : const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(kEmptyImage),
                  ),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 320.0),
            height: 30.0,
            decoration: BoxDecoration(
              color: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
      key: _key,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
            iconTheme:
                IconThemeData(color: kPrimaryColor, size: kLargeFontSize),
            expandedHeight: 200.0,
            elevation: 5,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Material(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      Positioned.fill(
                        child: headerResume,
                      ),
                      Positioned(
                        bottom: 1,
                        child: ClipRRect(
                          child: Container(
                            height: 30.0,
                            width: Utils.size(context).width,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.black26,
                            child: NormalText(
                              text: widget.clinicModel.name!,
                              textSize: kNormalFontSize,
                              fontWeight: FontWeight.w500,
                              textColor: kWhiteColor,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      // Verificar si fromHomeScreen es true y omitir los pasos
                      if (widget.fromHomeScreen == false) ...[
                        if (_dateController.text != '' && steep != 4)
                          _showSelectDate(),
                        if (_selectHour != '' && steep != 4) _showSelectHour(),
                        if (steep == 1) _selectDate(),
                        if (steep == 2) _getHours(),
                        if (steep == 3) _userForm(),
                        if (steep == 4) _apptResume(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Aquí agregamos los botones
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                if (!isStatusUpdated) ...[
                  if (widget.fromHomeScreen == true) ...[
                    Column(
                      children: [
                        Container(
                          child: _appointmentHistory(context,
                              widget.appointmentData, widget.clinicModel),
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width * 0.85,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05),
                        if (widget.appointmentData['Status'] ==
                            "SCHEDULED") ...[
                          NormalText(
                            text: ("Modifica tu cita"),
                            textSize: kPriceFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: FloatingActionButton(
                                  backgroundColor: kButtonColor,
                                  onPressed: () {
                                    appoitmentService
                                        .setAppointmentStatus("CONFIRMED",
                                            widget.appointmentData['Id']!)
                                        .then((response) {
                                      if (response != null) {
                                        setState(() {
                                          isStatusUpdated = true;
                                          message =
                                              "Su cita ha sido confirmada exitosamente, te esperamos";
                                        });
                                        widget.onChanged!(
                                            true); // Indicas que hubo cambios.
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Confirmar',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ))),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05),
                        ],
                        Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: MediaQuery.of(context).size.width * 0.12,
                            child: FloatingActionButton(
                                backgroundColor: kButtonColor,
                                onPressed: () {
                                  setState(() {
                                    confirmationDialog(context);
                                  });
                                },
                                child: Text(
                                  'Cancelar',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ))),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: MediaQuery.of(context).size.width * 0.12,
                            child: FloatingActionButton(
                                backgroundColor: kButtonColor,
                                onPressed: () {
                                  setState(() {
                                    widget.fromHomeScreen =
                                        false; // Oculta los botones
                                    steep = 1; // Regresa al paso 1
                                    appointmentId = widget
                                        .appointmentData['Id']; // Guarda el ID
                                  });
                                },
                                child: Text(
                                  'Reagendar',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ))),
                      ],
                    ),
                  ],
                ] else ...[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  Center(
                      child: Icon(Icons.check_circle,
                          color: Colors.green, size: 50)),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: MediaQuery.of(context).size.height *
                        0.10, // Ajusta la altura según necesites
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: kPriceFontSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          maxLines: null,
                          textAlign: TextAlign
                              .center, // Asegura que el texto esté centrado
                        ),
                      ],
                    ),
                  )
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void confirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "¿Está seguro que desea cancelar la cita?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: kSubTitleFontSize,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    widget.onChanged!(true);
                    _cancelarCita(context);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _cancelarCita(BuildContext context) {
    appoitmentService
        .setAppointmentStatus("CANCELLED", widget.appointmentData['Id']!)
        .then((response) {
      if (response != null) {
        setState(() {
          isStatusUpdated = true;
          message = "Su cita ha sido cancelada exitosamente";
        });
        widget.onChanged!(true); // Indicas que hubo cambios.
      }
    });
  }

  Widget _appointmentHistory(
      BuildContext context, appointmentData, clinicModel) {
    String appointmentStatus = appointmentData['Status'] ?? '';
    String appointmentDate = appointmentData['StartDate'] ?? '';
    String clinicName = clinicModel.name ?? 'No disponible';
    String directionUrl = clinicModel.googleMapsUrl;
    Color cardColor =
        (appointmentStatus == 'CONFIRMED') ? kAppColor : kPrimaryLightColor;
    // Color cardColor = (appointmentStatus == 'CONFIRMED') ? const Color.fromARGB(255, 0, 192, 3) : kPrimaryLightColor;

    String translatedStatus = _translateAppointmentStatus(appointmentStatus);
    return GestureDetector(
      child: _animatedEntry(
        CardWidget(
          color: cardColor,
          childWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _appointmentInfo(
                  appointmentDate,
                  clinicName,
                  translatedStatus,
                  directionUrl,
                  cardColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _translateAppointmentStatus(String status) {
    switch (status) {
      case 'CONFIRMED':
        return 'Confirmado';
      case 'SCHEDULED':
        return 'Agendado';
      default:
        return 'Estado desconocido';
    }
  }

  Widget _animatedEntry(Widget child) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        double safeOpacity = value.clamp(0.0, 1.0);
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: safeOpacity,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _appointmentInfo(String appointmentDate, String clinicName,
      String appointmentStatus, String locationUrl, buttonColor) {
    // Parsear la fecha de la cita
    DateTime parsedDate = DateTime.parse(appointmentDate);

    // Formatear la fecha y la hora
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    String formattedTime = DateFormat('HH:mm').format(parsedDate);

  // Espacio dinámico
  double spacing = MediaQuery.of(context).size.height * 0.001;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: NormalText(
          text: "Próxima Cita:",
          textSize: kTitleFontSize,
          fontWeight: FontWeight.w600,
          textColor: Colors.white,
        ),
      ),
       const SizedBox(height: 10),
      SizedBox(height: spacing),
      _appointmentDetail("Día de la cita:", formattedDate),
      SizedBox(height: spacing),
      _appointmentDetail("Hora:", formattedTime),
      SizedBox(height: spacing),
      _appointmentDetail("Estado de la cita:", appointmentStatus),
      SizedBox(height: spacing),
      _appointmentDetail("Lugar:", clinicName),
      SizedBox(height: spacing),
       const SizedBox(height: 10),

        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.05,
            child: ElevatedButton.icon(
              onPressed: () async {
                // Verificar que locationUrl no sea nula o vacía
                if (locationUrl.isNotEmpty) {
                  try {
                    final Uri url = Uri.parse(locationUrl);
                    if (!await launchUrl(url,
                        mode: LaunchMode.externalApplication)) {
                      print("No se pudo abrir la ubicación.");
                    }
                  } catch (e) {
                    print("Error al parsear la URL: $e");
                  }
                } else {
                  print("URL de ubicación no disponible");
                }
              },

              icon: Icon(Icons.location_pin,
                  color: buttonColor), // Icono con color dinámico
              label: Text(
                "Cómo llegar",
                style:
                    TextStyle(color: buttonColor), // Texto con color dinámico
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor:
                    buttonColor, // Color del texto cuando se presiona
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _appointmentDetail(String label, String value) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.005),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: NormalText(
                text: label,
                textSize: kSmallFontSize,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: NormalText(
              text: value,
              textSize: kSmallFontSize,
              fontWeight: FontWeight.w400,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getHours() {
    return FutureBuilder(
        future: appoitmentService.getHours(
            DateTime.parse(_dateController.text), widget.clinicModel.value!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            hourMessage = Utils.translate("select-hours");
            final listHours = snapshot.data;
            List<String> hours = List<String>.empty();
            if (listHours is Map &&
                listHours.containsKey('Succeeded') &&
                listHours['Succeeded'] == false) {
              List errors = listHours['Errors'];
              hourMessage = errors[0];
            } else {
              hours = List.from(listHours as List);
              if (hours.isEmpty) {
                hourMessage = Utils.translate("other-hour");
              }
            }
            return Container(
                padding: const EdgeInsets.all(2.0),
                child: _listHoursWidget(hours));
          } else {
            return _defaultLoadHours(context);
          }
        });
  }

  Widget _showSelectDate() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.start, // Alinea los elementos a la izquierda
      children: [
        const Icon(Icons.calendar_month_outlined),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: NormalText(
            text: _selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                : '',
            textSize: kTitleFontSize,
          ),
        ),
        const Spacer(), // Empuja el botón hacia la derecha
        IconButton(
            icon: const Icon(
              Icons.edit_calendar_outlined,
              color: kButtonColor,
            ),
            onPressed: () => {
                  setState(() {
                    steep = 1;
                    _selectHour = '';
                  })
                }),
      ],
    );
  }

  Widget _showSelectHour() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.start, // Alinea los elementos a la izquierda
      children: [
        const Icon(Icons.timelapse_outlined),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: NormalText(
            text: _selectHour.isNotEmpty ? _selectHour : '',
            textSize: kTitleFontSize,
          ),
        ),
        const Spacer(), // Empuja el botón hacia la derecha
        IconButton(
            icon: const Icon(
              Icons.edit_calendar_outlined,
              color: kButtonColor,
            ),
            onPressed: () => {
                  setState(() {
                    steep = 2;
                  })
                }),
      ],
    );
  }

  Widget _userForm() {
    bool hideInformationAndButton = widget.appointmentData != null &&
            (widget.appointmentData!['Status'] == "SCHEDULED" ||
                widget.appointmentData!['Status'] == "CONFIRMED") ||
        widget.personModel != null;

    return Padding(
      padding: const EdgeInsets.only(
        left: 0.0,
        right: 0.0,
        top: 30.0,
        bottom: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            text: Utils.translate("patient-data"),
            textSize: kPriceFontSize,
            fontWeight: FontWeight.w400,
          ),
          if (!hideInformationAndButton)
            NormalText(
              text: Utils.translate("information"),
              textSize: 15,
              fontWeight: FontWeight.w100,
              textOverflow: TextOverflow.visible,
            ),
          const SizedBox(
            height: 10.0,
          ),
Row(
  children: [
    Expanded(
      child: _dropdownButton(),
    ),
    if (!hideInformationAndButton && childrens.isEmpty)
      Container(
        padding: const EdgeInsets.only(left: 50.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/children_form').then((value) {
              setState(() {
                getInfo();
              });
            });
          },
          child: Icon(
            Icons.person_add_alt,
            color: Utils.isDarkMode ? kWhiteColor : kAppColor,
          ),
        ),
      ),
  ],
),
        LineWidget(),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: DefaultButton(
              buttonTitle: Utils.translate("schedule"),
              onPress: () async {
                createOrUpdateAppoitment();
              },
            ),
          ),
        ],
      ),
    );
  }

DropdownButton<PersonModel> _dropdownButton() {
  if (childrens.isEmpty) {
    return DropdownButton<PersonModel>(
      value: null,
      items: [],
      onChanged: null,
      hint: Text('No hay hijos registrados'),
    );
  }

  if (widget.personModel != null) {
    List<PersonModel> filteredChildren = childrens
        .where((child) =>
            child.id == widget.personModel?.id)
        .toList();

    if (filteredChildren.isNotEmpty) {
      _selectChildren = filteredChildren.first;
    } else {
      _selectChildren = null;
    }

    return _buildDropdown(filteredChildren);
  }

  if (widget.appointmentData != null &&
      (widget.appointmentData!['Status'] == "SCHEDULED" ||
          widget.appointmentData!['Status'] == "CONFIRMED")) {
    List<PersonModel> filteredChildren = childrens
        .where((child) =>
            child.odontofyPatientId == widget.appointmentData!['PatientId'])
        .toList();

    if (filteredChildren.isNotEmpty) {
      _selectChildren = filteredChildren.first;
    } else {
      _selectChildren = null;
    }
    return _buildDropdown(filteredChildren);
  }

  if (_selectChildren == null || !childrens.contains(_selectChildren)) {
    _selectChildren = childrens.first;
  }
  return _buildDropdown(childrens);
}


DropdownButton<PersonModel> _buildDropdown(List<PersonModel> children) {
  return DropdownButton<PersonModel>(
    value: children.contains(_selectChildren) ? _selectChildren : null,
    icon: Icon(Icons.arrow_drop_down, color: Utils.getColorMode()),
    iconSize: 30,
    style: TextStyle(
        color: Utils.getColorMode(),
        fontWeight: FontWeight.w400,
        fontSize: 18.0),
    underline: Container(),
    isExpanded: true,
    onChanged: (PersonModel? newValue) {
      setState(() {
        _selectChildren = newValue;
      });
    },
    items: children.map<DropdownMenuItem<PersonModel>>((PersonModel value) {
      return DropdownMenuItem<PersonModel>(
        value: value,
        child: Text('${value.name} ${value.lastNames}'),
      );
    }).toList(),
    hint: Text('Selecciona un hijo'),
  );
}

  Widget _listHoursWidget(List<String> hours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: Utils.translate("hour-appt"),
          textSize: kPriceFontSize,
          fontWeight: FontWeight.w400,
        ),
        NormalText(
          text: hourMessage,
          textSize: 18,
          fontWeight: FontWeight.w100,
          textOverflow: TextOverflow.visible,
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: hours.map((hour) {
            bool isSelected = _selectHour == hour;
            return GestureDetector(
              onTap: () {
                setState(() {
                  steep = 3;
                  _selectHour = hour;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? kDarkFacebookColor : kButtonColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: NormalText(
                  text: hour,
                  textSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: kPrimaryColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  ShimmerWidget _defaultLoadHours(BuildContext context) {
    return ShimmerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            text: Utils.translate("hour-appt"),
            textSize: kPriceFontSize,
            fontWeight: FontWeight.w400,
          ),
          NormalText(
            text: Utils.translate("loading"),
            textSize: 18,
            fontWeight: FontWeight.w100,
            textOverflow: TextOverflow.visible,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Generamos 10 elementos
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: DefaultButton(
                    width: 80,
                    color: kDarkBLackBgColor,
                    buttonTitle: '',
                    onPress: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectDate() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      NormalText(
        text: Utils.translate("day-appt"),
        textSize: kPriceFontSize,
        fontWeight: FontWeight.w400,
      ),
      DatePicker(
          centerLeadingDate: true,
          minDate: DateTime.now(),
          maxDate: DateTime(2100),
          initialDate: DateTime.now(),
          disabledDayPredicate: (date) {
            return date.weekday == DateTime.sunday;
          },
          disabledCellsDecoration: const BoxDecoration(
            color: kDarkTextColorColor,
          ),
          onDateSelected: (val) {
            setState(() {
              _selectedDate = val;
              _dateController.text = val.toString();
              steep = 2;
            });
          })
    ]);
  }

  void createOrUpdateAppoitment() {
    List<String> time = _selectHour.split(':');
    int hours = int.parse(time[0]);
    int minutes = int.parse(time[1]);

    AppoitmentModel appt = AppoitmentModel();
    appt.id = appointmentId;
    appt.clinicId = widget.clinicModel.value;
    appt.startDate = DateTime.parse(_dateController.text).toUtc();
    appt.startDate =
        appt.startDate!.add(Duration(hours: hours, minutes: minutes));
    appt.endDate = DateTime.parse(_dateController.text).toUtc();
    appt.endDate =
        appt.endDate!.add(Duration(hours: hours, minutes: minutes + 45));

    dateAppt = appt.startDate!;

    if (appt.id != null) {
      appoitmentService
          .updateAppointment(appt, _selectChildren!)
          .then((value) => {
                setState(() {
                  steep = 4;
                  // isStatusUpdated = true;
                }),
                widget.onChanged!(true) // Indicas que hubo cambios.
              })
          .catchError((onError) => {print(onError)});
    } else {
      appoitmentService
          .createAppoitment(appt, _selectChildren!)
          .then((value) => {
                setState(() {
                  steep = 4;
                  // isStatusUpdated = true;
                }),
                widget.onChanged!(true) // Indicas que hubo cambios.
              })
          .catchError((onError) => {print(onError)});
    }
  }

  Widget _apptResume() {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return Column(
      children: [
        NormalText(
          text: Utils.translate("successful-appt"),
          textSize: kTitleFontSize,
          fontWeight: FontWeight.w500, // Mayor peso para destacar
        ),
        const SizedBox(height: 20.0),
        NormalText(
          text: Utils.translate("appt-data"),
          textSize: kNormalFontSize,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(height: 15.0),

        // Tarjeta de resumen de la cita
        CardWidget(
          childWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Utils.translate("patients:"),
                    '${_nameController.text} ${_selectChildren!.name} ${_selectChildren!.lastNames}'),
                _infoRow(Utils.translate("dateAndTime:"),
                    formatter.format(dateAppt.toLocal())),
                _infoRow(
                    Utils.translate("branchOffice:"), widget.clinicModel.name!),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40.0),

        // Botón de reagendar con un diseño más elegante
        Center(
          child: DefaultButton(
            color: kButtonColor,
            buttonTitle: Utils.translate("schedule-again"),
            onPress: () async {
              setState(() {
                steep = 1;
              });
            },
          ),
        ),
      ],
    );
  }

// Función auxiliar para crear filas de información
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: NormalText(
              text: label,
              textSize: kSmallFontSize,
              fontWeight: FontWeight.w500, // Texto más resaltado
            ),
          ),
          Expanded(
            flex: 5,
            child: NormalText(
              text: value,
              textSize: kSmallFontSize,
              fontWeight: FontWeight.w300, // Texto más ligero
            ),
          ),
        ],
      ),
    );
  }
}
