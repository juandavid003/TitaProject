import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:odontobb/models/award_model.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/models/product_model.dart';
import 'package:odontobb/screens/after_cleaning_page/after_cleaning_screen.dart';
import 'package:odontobb/screens/appoitment_page/appoitment_screen.dart';
import 'package:odontobb/screens/before_cleaning_page/before_cleaning_screen.dart';
import 'package:odontobb/screens/brush_page/brush_screen.dart';
import 'package:odontobb/screens/did_you_know_page/did_you_know_screen.dart';
import 'package:odontobb/screens/stats_page/stats_screen.dart';
import 'package:odontobb/services/awards_service.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/services/clinics_service.dart';
import 'package:odontobb/services/news_service.dart';
import 'package:odontobb/services/products_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:odontobb/widgets/product_slider.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/stats_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  NewsService newsService = NewsService();
  ProductsService productsService = ProductsService();
  ChildrenService childrenService = ChildrenService();
  late VideoPlayerController _controller;
  bool play = false;
  Key statsCardSwiperKey = UniqueKey();
  Future<List<PersonModel>> _futureChildren = Future.value([]);
  bool isFetching = false; 
  ClinicsService clinicsService = ClinicsService();
  List<String> scannedQRCodes = [];


  String scannedCode =
      "Nada escaneado aún"; // Variable para almacenar el código escaneado

  @override
  void initState() {
    super.initState();
    getInfo();
    initGreeting();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

getInfo() async {
  if (mounted) {
    if (!isFetching) {
      setState(() {
        isFetching = true;
      });
      _futureChildren = childrenService.get();
      setState(() {
        isFetching = false;
      });
    }
  }
}


  initGreeting() async {
    _controller = VideoPlayerController.asset(
        'assets/audio/TitaAnimRender_Cepillado.mov');

    _controller.addListener(() {
      if (mounted) {
        if (!isFetching) { 
          setState(() {
            isFetching = true;
            _futureChildren = childrenService.get();
          });
        }
      }
    });

    _controller.setLooping(false);

    await _controller.initialize();
    if (mounted) {
      setState(
          () {}); // Asegura que la UI se actualice solo si el widget sigue montado
    }

    if (Utils.initGreeting) {
      _controller.play();
      Utils.initGreeting = false;
    }

    await Future.delayed(const Duration(seconds: 6));

    if (mounted && !play) {
      _controller.pause();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoading');
    await prefs.setString('isLoading', "false");
  }

void startScanning() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ScannerView(
        scannedQRCodes: scannedQRCodes, // Asegúrate de tener esta variable en tu widget padre
      ),
    ),
  );

  if (result != null) {
    setState(() {
      scannedCode = result;
    });
  }
}


  @override
 Widget build(BuildContext context) {
  Utils.globalFirebaseUser = context.watch<User>();
  final String _countryCode = 'EC';
  final String phoneNumber = Utils.globalFirebaseUser!.phoneNumber!;

  return Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: Utils.isDarkMode ? kWhiteColor : kAppColor,
              size: kLargeFontSize,
            ),
          ),
          NormalText(
            text: Utils.translate("hello"),
            textSize: kTitleFontSize,
            fontWeight: FontWeight.w400,
          ),
          FutureBuilder<bool>(
            future: clinicsService.isClinicPhone(_countryCode, phoneNumber),
            builder: (context, snapshot) {

              if (snapshot.hasData && snapshot.data == true) {
                return GestureDetector(
                  onTap: startScanning,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: Utils.isDarkMode ? kWhiteColor : kAppColor,
                        size: kLargeFontSize,
                      ),
                      NormalText(
                        text: Utils.translate("scan"),
                        textSize: kExtraMicroFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                );
              }

              return SizedBox.shrink();
            },
          ),
        ],
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Row(children: [
                Expanded(flex: 6, child: _initTita(context)),
                Expanded(flex: 4, child: _infoHome(context)),
              ]),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFFF38000),
                  onPressed: () async {
                    final result = await navigatorPlus.showModal(BrushScreen());
                    if (result == null) {
                      setState(() {
                        statsCardSwiperKey = UniqueKey(); // Forzar reconstrucción
                      });
                    }
                  },
                  heroTag: null,
                  tooltip: Utils.translate("brush"),
                  child: Icon(
                    play ? Icons.pause : Icons.play_arrow,
                    size: 40.0,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          _statsByChildren(),
        ],
      ),
    ),
  );
}

  Widget _infoHome(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<Widget>(
          future: _getDiagnosticDestination(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _cardInfoHome(
                  context,
                  kPrimaryLightColor,
                  Icons.search_outlined,
                  'Diagnóstico en Casa',
                  Container()); // Placeholder mientras carga
            }
            return _cardInfoHome(
                context,
                kPrimaryLightColor,
                Icons.search_outlined,
                'Diagnóstico en Casa',
                snapshot.data ?? BeforeCleaningScreen());
          },
        ),
        const SizedBox(height: 20),
        _cardInfoHome(context, kAppColor, Icons.calendar_month,
            'Agenda una cita', AppoitmentScreen()),
        const SizedBox(height: 20),
        _cardInfoHome(context, kDarkFacebookColor,
            Icons.family_restroom_outlined, 'Perfil Familiar', StatsScreen()),
      ],
    );
  }

  Future<Widget> _getDiagnosticDestination() async {
    final prefs = await SharedPreferences.getInstance();
    String? isLoading = prefs.getString('isLoading');
    if (isLoading == null) {
      await prefs.setString('isLoading', "true");
      isLoading = "false";
    }
    return isLoading == "true" ? AfterCleaningScreen() : BeforeCleaningScreen();
  }

  ClipRRect _cardInfoHome(BuildContext context, Color cardColor,
      IconData iconData, String textData, Widget destination) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: GestureDetector(
                      onTap: () async {
                        if (textData == 'Diagnóstico en Casa') {
                          Widget targetScreen = await _getDiagnosticDestination();
                          navigatorPlus.showModal(targetScreen);
                        } else if (textData == 'Agenda una cita') {
                          await navigatorPlus.showModal(AppoitmentScreen());
                        } else if (textData == 'Perfil Familiar') {
                          await navigatorPlus.showModal(StatsScreen());
                        } else {
                          navigatorPlus.showModal(destination);
                        }
                        setState(() {
                          _futureChildren = childrenService.get(); 
                          statsCardSwiperKey = UniqueKey(); // Forzar la reconstrucción
                        });
                      },
          child: Container(
              height: Utils.size(context).height * 0.135,
              width: Utils.size(context).width * 0.36,
              color: cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(iconData, size: 60.0, color: kPrimaryColor),
                  NormalText(
                      text: textData,
                      textSize: kMicroFontSize,
                      textOverflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      textColor: kPrimaryColor),
                ],
              )),
        ));
  }

  ClipRRect _initTita(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0)),
      child: AspectRatio(
        aspectRatio: Platform.isIOS
            ? _controller.value.aspectRatio
            : _controller.value.aspectRatio * 1.1,
        child: _controller.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  navigatorPlus.showModal(BrushScreen());
                  // navigatorPlus.showModal(BeforeCleaningScreen());
                },
                child: VideoPlayer(_controller))
            : Container(),
      ),
    );
  }
  // FutureBuilder<List<NewsModel>> _newsCardSwiper() {
  //   return FutureBuilder(
  //     future: newsService.get(),
  //     builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
  //       if (snapshot.hasData)
  //         return NewsCardSwiper(
  //           news: snapshot.data!,
  //         );
  //       else
  //         return ShimmerWidget(
  //             child: NewsCardSwiper(
  //           news: [new NewsModel(title: '')],
  //         ));
  //     },
  //   );
  // }

  // Future _startBrushing(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CustomDialogBox(
  //           title: Utils.translate("remember"),
  //           descriptions: Utils.translate("father_brush"),
  //           textBtnAcept: Utils.translate("begin"),
  //         );
  //       });
  // }



Widget _statsByChildren() {
    return FutureBuilder<List<PersonModel>>(
      future: _futureChildren,
      builder: (context, AsyncSnapshot<List<PersonModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerWidget(
            child: StatsCardSwiper(
              key: statsCardSwiperKey,
              items: [PersonModel(), PersonModel()],
              all: false,
            ),
          );
        }

        return StatsCardSwiper(
          key: statsCardSwiperKey,
          items: snapshot.data ?? [],
          all: false,
        );
      },
    );
  }
}



class ScannerView extends StatefulWidget {
  final List<String> scannedQRCodes; // <-- mantener historial al volver

  ScannerView({Key? key, required this.scannedQRCodes}) : super(key: key);

  @override
  _ScannerViewState createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final MobileScannerController _controller = MobileScannerController();
  final AwardsService awardsService = AwardsService();
  final ChildrenService childrenService = ChildrenService();
  final ClinicsService clinicsService = ClinicsService();
  final String _countryCode = 'EC';

  String _scanResult = '';
  bool _isScanning = false;
  bool _showActionButton = false;
  bool _buttonPressed = false;
  DateTime _lastDetectionTime = DateTime.now();
  Timer? _hideButtonTimer;

  Map<String, DateTime> _lastScanTimes = {};

  @override
  void initState() {
    super.initState();

    // Revisa cada segundo si ha pasado tiempo desde la última detección
    _hideButtonTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_showActionButton &&
          DateTime.now().difference(_lastDetectionTime).inSeconds > 2) {
        setState(() {
          _showActionButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _hideButtonTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear Código QR")),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (barcode) async {
              final bool hasBarcode = barcode.barcodes.isNotEmpty;
              if (hasBarcode) {
                _lastDetectionTime = DateTime.now(); // actualiza cada vez que ve un QR

                final String barcodeScanRes = barcode.barcodes.first.rawValue ?? "No se pudo leer el código";
                if (barcodeScanRes != "-1" && !_isScanning && !_showActionButton) {
                  setState(() {
                    _scanResult = barcodeScanRes;
                    _showActionButton = true;
                    _buttonPressed = false;
                  });
                }
              }
            },
          ),
        ],
      ),
      floatingActionButton: _showActionButton
          ? FloatingActionButton.extended(
              onPressed: _buttonPressed
                  ? null
                  : () async {
                      setState(() {
                        _isScanning = true;
                        _buttonPressed = true;
                      });

                      await _processQR(_scanResult);

                      setState(() {
                        _showActionButton = false;
                      });

                      Navigator.pop(context, widget.scannedQRCodes); // ← retorna la lista actualizada
                    },
              label: Text("Realizar acción"),
              icon: Icon(Icons.check),
            )
          : null,
    );
  }

  Future<void> _processQR(String barcodeScanRes) async {
    try {
      if (widget.scannedQRCodes.contains(barcodeScanRes)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Este código QR ya ha sido escaneado anteriormente.")),
        );
        return;
      }

      Map<String, dynamic> json = jsonDecode(barcodeScanRes);
      final firstItem = json['type'];
      final data = json['data'];
      final String phoneNumber = Utils.globalFirebaseUser!.phoneNumber!;
      bool isClinicPhone = await clinicsService.isClinicPhone(_countryCode, phoneNumber);

      if (!isClinicPhone) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Acción no permitida: Solo la clínica puede modificar los puntos.")),
        );
        return;
      }

      String personId = data['personId'];

      if (firstItem == 'odontobb_appt') {
        final now = DateTime.now();
        if (_lastScanTimes.containsKey(personId)) {
          final lastScan = _lastScanTimes[personId]!;
          final difference = now.difference(lastScan).inMinutes;

          if (difference < 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Espera ${10 - difference} minutos antes de volver a escanear para este niño.")),
            );
            return;
          }
        }

        _lastScanTimes[personId] = now;

        await childrenService.addBBbCash(personId, firstItem).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Utils.translate('add_bbcashs'))),
          );
        });
      } else {
        switch (firstItem) {
          case 'award':
            String awardId = data['awardId'];
            AwardModel award = await awardsService.get(awardId);
            await awardsService.registreAward(personId, awardId);
            await childrenService.subtractBbCash(personId, award).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(Utils.translate('i_want_product_confirmed'))),
              );
            });
            break;

          default:
            List<PersonModel> childrens = await childrenService.get();
            await childrenService.addBBbCashBulk(childrens, firstItem).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(Utils.translate('add_bbcashs'))),
              );
            });
            break;
        }
      }

      widget.scannedQRCodes.add(barcodeScanRes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al procesar el QR: $e")),
      );
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }
}
