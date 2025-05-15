// ignore_for_file: library_private_types_in_public_api

import 'package:odontobb/constant.dart';
import 'package:odontobb/models/bar_chart_model.dart';
import 'package:odontobb/models/bbcash_model.dart';
import 'package:odontobb/models/brushing_history_model.dart';
import 'package:odontobb/models/challenge_model.dart';
import 'package:odontobb/models/clinics_model.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/screens/appoitment_page/appoitment_screen.dart';
import 'package:odontobb/screens/appoitment_page/components/appoitment_form.dart';
import 'package:odontobb/screens/children/components/children_body.dart';
import 'package:odontobb/screens/code_user/code_user_screen.dart';
import 'package:odontobb/screens/diagnosis_page/diagnosis_screen.dart';
import 'package:odontobb/screens/item_appointment/item_appointment_screen.dart';
import 'package:odontobb/screens/stats_page/stats_screen.dart';
import 'package:odontobb/services/appoitment_service.dart';
import 'package:odontobb/services/challenge_service.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/services/clinics_service.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/bar_chart_graph.dart';
import 'package:odontobb/widgets/card_widget.dart';
import 'package:odontobb/widgets/challenge_horizontal.dart';
import 'package:odontobb/widgets/childen_card_swiper.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class StatsCardSwiper extends StatefulWidget {
  List<PersonModel> items;
  bool all = true;
  StatsCardSwiper({super.key, required this.items, required this.all});

  @override
  _StatsCardSwiperState createState() => _StatsCardSwiperState();
}

class _StatsCardSwiperState extends State<StatsCardSwiper> {
  ChildrenService childrenService = ChildrenService();
  ChallengeService challengeService = ChallengeService();
  Map<int, dynamic> appointmentCache = {}; // Mapa para almacenar citas
  BbCashModel bbCash = BbCashModel();
  bool bbCashView = true;
  List<BbCashModel> bbCashList = [];
  List<List<BrushingHistoryModel>> brushingHistoryList = [];
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    getInfo();
    getPoints();
    bbCash.cant = 0;
    bbCash.visits = 0;
  }

  getInfo() async {
    if (widget.items.isNotEmpty) {
      appointmentCache = {};
      for (var item in widget.items) {
        int childId = item.odontofyPatientId!;
        if (!appointmentCache.containsKey(childId)) {
          var appointment = await AppoitmentService()
              .getLastScheduledAppointmentByPatientId(childId);
          appointmentCache[childId] = appointment;
          setState(() {
            appointmentCache[childId] = appointment;
          });
        }
      }
    }
  }

  getPoints() async {
    if (widget.items.isNotEmpty) {
      bbCashList.clear();
      brushingHistoryList.clear();
      for (var item in widget.items) {
        int childId = item.odontofyPatientId!;
        BbCashModel bbCashData;
        try {
          bbCashData = await childrenService.getBbCashByPerson(item.id!);
        } catch (e) {
          bbCashData = BbCashModel(personId: item.id, cant: 0);
        }
        List<BrushingHistoryModel> brushingHistoryData =
            await childrenService.brushingHistory(item.id!);
        bbCashList.add(bbCashData);
        brushingHistoryList.add(brushingHistoryData);

        brushingHistoryData.sort((a, b) => b.date!.compareTo(a.date!));
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utils.size(context).width,
      height: MediaQuery.of(context).size.height * (widget.all ? 0.92 : 0.38),
      padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
      child: widget.items.isNotEmpty
          ? _swiper(context)
          : Container(
              padding: const EdgeInsets.all(20.0),
              child: CardWidget(
                childWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NormalText(
                      text: "No existen usuarios disponibles",
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 150,
                        height: 45,
                        child: FloatingActionButton(
                          backgroundColor: kButtonColor,
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                                context, '/children_form');
                            if (result == null) {
                              setState(() {
                                hasChanges = true;
                              });
                              refreshChildren();
                            }
                          },
                          child: Text(
                            "Agregar usuarios",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void refreshChildren() async {
    List<PersonModel> updatedChildren =
        await childrenService.get(); // Método para obtener los nuevos usuarios
    setState(() {
      widget.items = updatedChildren;
    });
    getInfo();
    getPoints();
  }

  Swiper _swiper(BuildContext context) {
    return Swiper(
        itemCount: widget.items.length,
        itemWidth: Utils.size(context).width * 0.9,
        viewportFraction: 0.8,
        scale: 0.9,
        loop: true,
        layout: SwiperLayout.STACK,
        onIndexChanged: (index) async {
          int childId = widget.items[index].odontofyPatientId!;
          var appointment = await AppoitmentService()
              .getLastScheduledAppointmentByPatientId(childId);

          setState(() {
            appointmentCache[childId] = appointment;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return LayoutBuilder(
            builder: (context, constraints) {
              bool allDataLoaded = appointmentCache
                      .containsKey(widget.items[index].odontofyPatientId) &&
                  bbCashList.length == widget.items.length;
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: constraints.maxHeight,
                ),
                child: allDataLoaded
                    ? CardWidget(
                        childWidget: _body(
                          widget.items[index],
                          context,
                          brushingHistoryList[index],
                          bbCashList[index],
                        ),
                      )
                    : _loadingSwiper(constraints.maxHeight),
              );
            },
          );
        });
  }

  Widget _loadingSwiper(double height) {
    return Swiper(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: height,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
      // autoplay: true,
      // autoplayDelay: 2000,
      // loop: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget _body(PersonModel item, BuildContext context, List<BrushingHistoryModel> brushingHistory, BbCashModel bbCash) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerPerson(item, context, bbCash),
              const SizedBox(height: 10),
              _history(context, brushingHistory, item, bbCash),
              const SizedBox(height: 10),
              widget.all ? _challenge(brushingHistory, bbCash) : Container(),
              const SizedBox(height: 10),
              widget.all ? _week(brushingHistory) : Container(),
              
            ],
          ),
          widget.all ? _deleteButton(item, context) : Container(),
          widget.all ? _editButton(item, context) : Container()
        ],
      ),
    );
  }

  Row _headerPerson(PersonModel item, BuildContext context, BbCashModel bbCash) {
    bool hasAppointment = appointmentCache[item.odontofyPatientId!] != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person),
                SizedBox(width: 2),
                NormalText(
                  text: '${item.name}',
                  textSize: kNormalFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.event, size: kNormalFontSize),
                SizedBox(width: 2),
                NormalText(
                  text:
                      'Miembro desde: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                  textSize: kExtraMicroFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: kNormalFontSize),
                SizedBox(width: 2),
                NormalText(
                  text: '${bbCash.visits.toString()} visitas a la clínica',
                  textSize: kExtraMicroFontSize,
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
  

        Stack(
          alignment: Alignment
              .center, // Asegura que la columna se mantenga centrada en el Stack
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3), // Espacio a los lados del botón
                  constraints:
                      const BoxConstraints(), // Reduce el tamaño del botón
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: kDarkAppColor,
                    size: kSwiperButtonsFontSize,
                  ),
                  onPressed: hasAppointment
                      ? () async {
                          // Lógica cuando hay cita
                          bool fromHomeScreen = true;

                          var appointmentData =
                              appointmentCache[item.odontofyPatientId!];
                          ClinicsService service = ClinicsService();
                          List<ClinicsModel> clinics = await service
                              .getClinicById(appointmentData['ClinicId']);

                          ClinicsModel? selectedClinic =
                              clinics.isNotEmpty ? clinics.first : null;
                          if (selectedClinic != null) {
                            String imageUrl = await FileService.loadImage(
                                'clinics/${selectedClinic.image!}');
                            selectedClinic.imageUrl = imageUrl;
                          }

                          // final result = await Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => AppoitmentForm(
                          //       onChanged: (bool changed) {
                          //         setState(() {
                          //           hasChanges = changed;
                          //         });
                          //       },
                          //       appointmentData: appointmentData,
                          //       clinicModel: selectedClinic!,
                          //       fromHomeScreen: fromHomeScreen,
                          //     ),
                          //   ),
                          // );

                          if (hasChanges) {
                            getInfo();
                          }

                          setState(() {
                            hasAppointment = false;
                            hasChanges = false;
                          });
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppoitmentScreen(
                                personModel: item, // Pasar el objeto item
                              ),
                            ),
                          ).then((_) {
                            getInfo(); // Se ejecuta cuando el usuario regresa
                          });
                        },
                ),
                NormalText(
                  text: "Citas",
                  textSize: kExtraMicroFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            if (hasAppointment)
              Positioned(
                right: 2,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 17, 0),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 10,
                    minHeight: 10,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.symmetric(
                  horizontal: 3), // Espacio a los lados del botón
              constraints:
                  BoxConstraints(), // Reduce el tamaño del IconButton al mínimo necesario
              icon: const Icon(
                Icons.qr_code,
                color: kAppColor,
                size: kSwiperButtonsFontSize,
              ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return CodeUserScreen(
                        personId: item.id!,
                        title: '${item.name!} ${item.lastNames!}',
                      );
                    }),
                  ).then((_) {
                    setState(() {
                      getInfo();
                      getPoints();
                    });
                  });
                },
            ),
            NormalText(
              text: "Canjear",
              textSize: kExtraMicroFontSize,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      constraints: const BoxConstraints(),
      icon: Icon(
        Icons.medical_services_outlined,
        color: Utils.isDarkMode
            ? kWhiteColor
            : const Color.fromARGB(255, 255, 0, 0),
        size: kSwiperButtonsFontSize,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosisScreen(
              personModel: item, // <- Pasar al hijo seleccionado
            ),
          ),
        );
      },
    ),
    NormalText(
      text: "Historial",
      textSize: kExtraMicroFontSize,
      fontWeight: FontWeight.w600,
    ),
  ],
),

      ],
    );
  }

  Widget _history(
      BuildContext context,
      List<BrushingHistoryModel> brushingHistory,
      PersonModel item,
      BbCashModel bbCash) {
    return CardWidget(
      childWidget: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 15, horizontal: 20), // Espaciado interno
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 3, child: _balance(bbCash)), // Ocupa 3/5

            // Línea divisoria
            Container(
              width: 1.5, // Grosor de la línea
              height: 50, // Altura de la línea
              color: Colors.black12, // Color sutil
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),

            Expanded(flex: 2, child: _bbCash(bbCash)), // Ocupa 2/5
          ],
        ),
      ),
    );
  }

// Widget _appointmentHistory(BuildContext context, PersonModel item) {
//     int childId = item.odontofyPatientId!;
//     var appointmentData = appointmentCache[childId];

//     if (appointmentData == null) {
//       return SizedBox();
//     }

//     String appointmentStatus = appointmentData['Status'] ?? '';
//     String appointmentDate = appointmentData['StartDate'] ?? '';
//     String clinicName = appointmentData['Clinic']?['Name'] ?? 'No disponible';
//     Color cardColor = (appointmentStatus == 'CONFIRMED') ? kAppColor : kPrimaryLightColor;
//     // Color cardColor = (appointmentStatus == 'CONFIRMED') ? const Color.fromARGB(255, 0, 192, 3) : kPrimaryLightColor;

//     String translatedStatus = _translateAppointmentStatus(appointmentStatus);
//     return GestureDetector(
//       onTap: () async {
//         bool fromHomeScreen = true;

//         ClinicsService service = ClinicsService();
//         List<Clinic> clinics = await service.getClinicById(appointmentData['ClinicId']);

//         if (clinics.isNotEmpty) {
//           String imageUrl = await FileService.loadImage('clinics/${clinics[0].image!}');

//           Clinic? selectedClinic = clinics.first;
//           selectedClinic.imageUrl = imageUrl;
//         }

//         Clinic? selectedClinic = clinics.isNotEmpty ? clinics.first : null;

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AppoitmentForm(
//               appointmentData: appointmentData,
//               clinicModel: selectedClinic!,
//               fromHomeScreen: fromHomeScreen,
//             ),
//           ),
//         );
//       },
//       child: _animatedEntry(
//         CardWidget(
//           color: cardColor,
//           childWidget: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(child: _appointmentInfo(appointmentDate, clinicName, translatedStatus)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
// }

// String _translateAppointmentStatus(String status) {
//   switch (status) {
//     case 'CONFIRMED':
//       return 'Confirmado';
//     case 'SCHEDULED':
//       return 'Agendado';
//     default:
//       return 'Estado desconocido';
//   }
// }

// Widget _animatedEntry(Widget child) {
//   return TweenAnimationBuilder(
//     duration: Duration(milliseconds: 500),
//     curve: Curves.easeOutBack,
//     tween: Tween<double>(begin: 0.0, end: 1.0),
//     builder: (context, double value, child) {
//       double safeOpacity = value.clamp(0.0, 1.0);
//       return Transform.scale(
//         scale: value,
//         child: Opacity(
//           opacity: safeOpacity,
//           child: child,
//         ),
//       );
//     },
//     child: child,
//   );
// }

// _appointmentInfo(String appointmentDate, String clinicName, String appointmentStatus) {
//   // Parse la fecha de la cita
//   DateTime parsedDate = DateTime.parse(appointmentDate);

//   // Formatea la fecha y hora de forma separada
//   String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate); // Día de la cita
//   String formattedTime = DateFormat('HH:mm').format(parsedDate); // Hora de la cita

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Center(
//         child: NormalText(
//           text: "Proxima Cita:",
//           textSize: kTitleFontSize,
//           fontWeight: FontWeight.w600,
//           textColor: Colors.white,
//         ),
//       ),
//       const SizedBox(height: 5),

//       // Día de la cita
//       Center(
//         child: NormalText(
//           text: "Día de la cita: $formattedDate",
//           textSize: kMicroFontSize,
//           fontWeight: FontWeight.w500,
//           textColor: Colors.white,
//         ),
//       ),
//       const SizedBox(height: 2),

//       // Hora de la cita
//       Center(
//         child: NormalText(
//           text: "Hora: $formattedTime",
//           textSize: kMicroFontSize,
//           fontWeight: FontWeight.w500,
//           textColor: Colors.white,
//         ),
//       ),
//       const SizedBox(height: 2),

//       // Lugar
//       Center(
//         child: NormalText(
//           text: "Lugar: $clinicName",
//           textSize: kMicroFontSize,
//           fontWeight: FontWeight.w500,
//           textColor: Colors.white,
//         ),
//       ),
//       const SizedBox(height: 2),

//       // Estado de la cita
//       Center(
//         child: NormalText(
//           text: "Estado de la cita: $appointmentStatus", // Estado de la cita
//           textSize: kMicroFontSize,
//           fontWeight: FontWeight.w500,
//           textColor: Colors.white,
//         ),
//       ),
//     ],
//   );
// }

  _balance(BbCashModel bbCash) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saldo Total
        NormalText(
          text: "Saldo Total",
          textSize: kTitleFontSize,
          fontWeight: FontWeight.w500,
        ),
        Row(
          children: [
            Icon(
              Icons.attach_money,
              size: kTitleFontSize,
              color: kDarkAppColor,
            ),
            const SizedBox(width: 2),
            NormalText(
              text: ((bbCash.depositedBalance ?? 0.0) +
                      (bbCash.rewardsBalance ?? 0.0))
                  .toString(),
              textSize: kTitleFontSize,
              fontWeight: FontWeight.w500,
              textColor: kDarkAppColor,
            ),
          ],
        ),
        const SizedBox(height: 10),
        //Saldo Prepago y Saldo Ganado
        
        
        
        // Row(
        //   children: [
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         NormalText(
        //           text: "Saldo\nPrepago",
        //           textSize: kExtraMicroFontSize,
        //         ),
        //         Row(
        //           children: [
        //             Icon(Icons.attach_money, size: kTitleFontSize),
        //             NormalText(
        //                 text: bbCash.depositedBalance.toString(),
        //                 textSize: kMicroFontSize),
        //           ],
        //         ),
        //       ],
        //     ),
        //     const SizedBox(width: 20),
        //     NormalText(
        //       text: "+",
        //       textSize: kTitleFontSize,
        //       fontWeight: FontWeight.w600,
        //     ),
        //     const SizedBox(width: 20),
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         NormalText(
        //           text: "Saldo\nGanado",
        //           textSize: kExtraMicroFontSize,
        //         ),
        //         Row(
        //           children: [
        //             Icon(Icons.attach_money, size: kTitleFontSize),
        //             NormalText(
        //                 text: bbCash.rewardsBalance.toString(),
        //                 textSize: kMicroFontSize),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ],
        // ),




    Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                  text: "¡Tu saldo acumulado\n listo para ser canjeado!",
                    textSize: kExtraMicroFontSize,
                  ),
                  // Row(
                  //   children: [
                  //     Icon(Icons.attach_money, size: kTitleFontSize),
                  //     NormalText(
                  //         text: bbCash.depositedBalance.toString(),
                  //         textSize: kMicroFontSize),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        
      ],
    );
  }

  _bbCash(BbCashModel bbCash) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            text: "BbCash",
            textSize: kTitleFontSize,
            fontWeight: FontWeight.w500,
          ),
          Row(
            children: [
              Icon(Icons.currency_exchange_outlined,
                  color: kAppColor, size: kTitleFontSize),
              const SizedBox(width: 2),
              NormalText(
                text: bbCash.cant.toString(),
                textSize: kTitleFontSize,
                fontWeight: FontWeight.w500,
                textColor: kAppColor,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 Información sobre conversión
          NormalText(
              text: "Cada 100\n BBcash ganas\n \$1 dólar",
              textSize: kExtraMicroFontSize),
        ],
      ),
    );
  }

  Widget _challenge(List<BrushingHistoryModel> brushingHistory, BbCashModel bbCash) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        NormalText(
          text: 'Premios disponibles',
          textSize: kSubTitleFontSize,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(
          height: 5.0,
        ),
        FutureBuilder(
            future: challengeService.get(),
            builder: (context, AsyncSnapshot<List<ChallengeModel>> snapshot) {
              if (snapshot.hasData) {
                return ChallengeHorizontal(
                  challenges: snapshot.data!,
                  brushingHistory: brushingHistory,
                  bbCash: bbCash,
                  callback: () {
                    setState(() {
                        getInfo();
                        getPoints();
                    });
                  },
                );
              } else {
                return ShimmerWidget(
                  child: ChallengeHorizontal(
                    challenges: [
                      ChallengeModel(title: ''),
                      ChallengeModel(title: ''),
                      ChallengeModel(title: '')
                    ],
                    brushingHistory: brushingHistory,
                    bbCash: bbCash,
                  ),
                );
              }

            })
      ],
    );
  }

  int _cantPerDay(List<BrushingHistoryModel> brushingHistoryWeek, int weekDay) {
    DateTime start = DateTime.now().subtract(Duration(
        days: DateTime.now().weekday,
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second));

    List<BrushingHistoryModel> brushingHistoryDay = [];

    if (brushingHistoryWeek.isNotEmpty && DateTime.now().weekday >= weekDay) {
      start = start.add(Duration(days: weekDay));

      brushingHistoryDay = brushingHistoryWeek.where((element) {
        return (element.date!.isAfter(start) &&
            element.date!.isBefore(start.add(const Duration(days: 1))));
      }).toList();
    }
    return brushingHistoryDay.length;
  }

  Widget _deleteButton(PersonModel item, BuildContext context) {
    return Positioned(
      bottom: 5.0,
      right: -5.0,
      child: Container(
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _deletePerson(item, context);
          },
        ),
      ),
    );
  }

Widget _editButton(PersonModel item, BuildContext context) {
  return Positioned(
    bottom: 5.0,
    left: -5.0,
    child: Container(
      child: IconButton(
        icon: Icon(Icons.edit_outlined),
                    onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ChildrenBody(personData: item);
                        }),
                      ).then((value) => {_loadChildrensOnEdit()});
                    },
      ),
    ),
  );
}


  void _deletePerson(PersonModel item, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "¿Está seguro que desea eliminar este usuario?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
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
                    backgroundColor: Colors.grey,
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
                  onPressed: () async {
                    await childrenService.delete(item);

                    await _loadChildrensOnDelete();

                    setState(() {
                      int indexToRemove = widget.items.indexOf(item);
                      if (indexToRemove != -1) {
                        widget.items.removeAt(indexToRemove);
                        bbCashList.removeAt(indexToRemove);
                      }
                    });

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

  _loadChildrensOnEdit() async {
    widget.items = await childrenService.get();
    setState(() {});
  }

    _loadChildrensOnDelete() async {
    setState(() {});
  }

  Widget _week(List<BrushingHistoryModel> brushingHistory) {
    final List<BarChartModel> data = [
      BarChartModel(
        weekday: "L",
        cant: _cantPerDay(brushingHistory, 1),
        color: (kButtonColor),
      ),
      BarChartModel(
        weekday: "M",
        cant: _cantPerDay(brushingHistory, 2),
        color: (kButtonColor),
      ),
      BarChartModel(
        weekday: "X",
        cant: _cantPerDay(brushingHistory, 3),
        color: (kButtonColor),
      ),
      BarChartModel(
        weekday: "J",
        cant: _cantPerDay(brushingHistory, 4),
        color: (kButtonColor),
      ),
      BarChartModel(
        weekday: "V",
        cant: _cantPerDay(brushingHistory, 5),
        color: (kButtonColor),
      ),
      BarChartModel(
        weekday: "S",
        cant: _cantPerDay(brushingHistory, 6),
        color: (kButtonColor),
      ),
      BarChartModel(
        weekday: "D",
        cant: _cantPerDay(brushingHistory, 0),
        color: (kButtonColor),
      ),
    ];

    return Column(
      children: [
        NormalText(
          text: 'Cepillados de la semana',
          textSize: kSubTitleFontSize,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(
          height: 5.0,
        ),
        CardWidget(
          height: Utils.size(context).height * 0.15,
          childWidget: BarChartGraph(data: data),
        )
      ],
    );
  }

  //Método reutilizable para mostrar cada bloque de saldo
  Widget _buildBalanceItem(String title1, String title2, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NormalText(
          text: title1,
          textSize: kMicroFontSize,
          fontWeight: FontWeight.w500,
        ),
        NormalText(
          text: title2,
          textSize: kMicroFontSize,
          fontWeight: FontWeight.w500,
        ),
        NormalText(
          text: value,
          textSize: kNormalFontSize,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
