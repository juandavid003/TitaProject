// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_import

import 'dart:async';
import 'package:odontobb/screens/home_page/home_screen.dart';
import 'package:odontobb/screens/pay_page/pay_screen.dart';
import 'package:odontobb/services/authentication_service.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:odontobb/widgets/custom_elements/custom_dialog_box.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/widgets/children_horizontal.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:just_audio/just_audio.dart';
import '../../../constant.dart';
import '../../../util.dart';

class ArBrushPageIos extends StatefulWidget {
  const ArBrushPageIos({super.key});

  @override
  _ArBrushPageIosState createState() => _ArBrushPageIosState();
}

class _ArBrushPageIosState extends State<ArBrushPageIos> {
  ChildrenService childrenService = ChildrenService();
  AuthenticationService authenticationService =
      AuthenticationService(FirebaseAuth.instance);

  AudioPlayer player = AudioPlayer();
  bool play = false;
  Timer _timer = Timer(const Duration(seconds: 0), () {});
  int _start = 60;
  final int _totalTime = 60;

  List<PersonModel> _childrensSelected = [];
  List<PersonModel> _allChildrens = [];
  
  // AR related variables
  late ARKitController arkitController;
  ARKitReferenceNode node = ARKitReferenceNode(url: '');
  ARKitAnchor? aRKitAnchor;
  String anchorId = '';

  bool showCircularCountDownTimer = false;
  late final CountDownController _controllerCount = CountDownController();
  int _durationCountDownTimer = 3;
  bool _hasConfirmedSelection = false;

  @override
  void initState() {
    _allChildrens = [];
    _childrensSelected = [];
    super.initState();
    initGreeting();
    showChildrenSelectionDialog();
  }

  @override
  void dispose() {
    if (mounted) {
      arkitController.dispose();
    }
    player.dispose();
    _timer.cancel();
    super.dispose();
  }

  getInfo() async {
    _controllerCount.start();
    setState(() {});
  }

  Future<void> initGreeting() async {
    if (!play) {
      showCircularCountDownTimer = true;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
      appBar: AppBar(
          title: NormalText(
        text: Utils.translate("brush"),
        textSize: kTitleFontSize,
        fontWeight: FontWeight.w400,
      )),
      body: Container(
        color: Colors.white,
        child: Stack(children: [
          ARKitSceneView(
            key: const Key('tita'),
            showFeaturePoints: true, 
            forceUserTapOnCenter: true,
            planeDetection: ARPlaneDetection.horizontal,
            onARKitViewCreated: onARKitViewCreated,
          ),
          _initClock(),
          _circularTimer(context),
          Row(
            children: [
              _loadChildens(),
            ],
          )
        ]),
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
            backgroundColor: kButtonColor,
            onPressed: () async {
              _brushingBtn(context);
            },
            child: Icon(
              play ? Icons.pause : Icons.play_arrow,
              size: 40.0,
              color: kPrimaryColor,
            ))
      ]),
    );
  }

  void onARKitViewCreated(ARKitController controller) async {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
    
    bool client = await authenticationService.isClient();
    int countBrush = await childrenService.seeBrush();

    if (!client && countBrush > 2) {
      navigatorPlus.showModal(PayScreen());
    } else {
      _showDialogFindModel(context);
    }
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    _addPlane(anchor);
  }

  void _addPlane(ARKitPlaneAnchor anchor) {
    aRKitAnchor = anchor;
    anchorId = anchor.identifier;
    if (node.url.isEmpty) {
      node = ARKitReferenceNode(
        name: 'tita',
        url: 'models.scnassets/Tita_Anim_Saludo.dae',
        position: vector.Vector3(0, 0, 0),
        scale: vector.Vector3(0.01, 0.01, 0.01),
      );

      arkitController.add(node, parentNodeName: anchor.nodeName);
      arkitController.snapshot().then((value) async {
        await player.setAsset('assets/audio/greeting.mp3');
        player.play();

        await Future.delayed(const Duration(seconds: 7));

        if (!play) {
          node = ARKitReferenceNode(
              name: 'tita-idle',
              url: 'models.scnassets/Tita_Anim_Idle.dae',
              position: vector.Vector3(0, 0, 0),
              scale: vector.Vector3(0.01, 0.01, 0.01));

          arkitController.add(node, parentNodeName: anchor.nodeName);
          arkitController.remove('tita');
        }
      });
    }
  }

  void _showDialogFindModel(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: Utils.translate("find_tita"),
            descriptions: Utils.translate("find_tita_description"),
            textBtnAcept: Utils.translate("agreed"),
          );
        }).then((value) async {
      if (value) {
        // Iniciar búsqueda de superficie
      }
    });
  }

  Widget _circularTimer(BuildContext context) {
    return showCircularCountDownTimer
        ? Container(
            padding: EdgeInsets.only(
                left: Utils.size(context).width * 0.8, top: 80.0),
            margin: const EdgeInsets.all(0.0),
            child: CircularCountDownTimer(
              duration: _durationCountDownTimer,
              initialDuration: 1,
              controller: _controllerCount,
              width: Utils.size(context).width * 0.16,
              height: Utils.size(context).height * 0.16,
              ringColor: kDarkAppColor,
              ringGradient: null,
              fillColor: kBottomIconColor,
              fillGradient: null,
              backgroundColor: kWhiteColor,
              backgroundGradient: null,
              strokeWidth: 10.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                  fontSize: 33.0,
                  color: kButtonColor,
                  fontWeight: FontWeight.bold),
              textFormat: CountdownTextFormat.S,
              isReverse: false,
              isReverseAnimation: false,
              isTimerTextShown: true,
              autoStart: false,
              onStart: () {},
              onComplete: () {
                _controllerCount.pause();
                _brushingBtn(context);
                showCircularCountDownTimer = false;
                _durationCountDownTimer = 3;
              },
            ))
        : Container();
  }

  Widget _initClock() {
    return _start < _totalTime && _start != 0 && play
        ? Container(
            padding: EdgeInsets.only(
                left: Utils.size(context).width * 0.8, top: 80.0),
            margin: const EdgeInsets.all(0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60.0),
              child: Container(
                color: Colors.white,
                width: 80,
                height: 80,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/reloj-de-arena.gif"),
                      height: 70.0,
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

   void _brushingBtn(BuildContext context) async {
  //   bool isClient = await _isClient();

  //   if (isClient) {
      if (_allChildrens.isEmpty) {
        Navigator.pushNamed(context, '/children_form')
            .then((value) => {getInfo()});
      } else {
        setState(() => play = !play);
        if (play) {
          startTimer(context);

          if (_start == _totalTime && play) {
            if (_childrensSelected.isEmpty) {
              _childrensSelected = _allChildrens.map((e) {
                e.check = true;
                return e;
              }).toList();
            }
            
            _startBrushing(context).then((value) async {
              if (value && aRKitAnchor != null) {
                await player.setAsset('assets/audio/brushing.mp3');

                node = ARKitReferenceNode(
                    name: 'tita',
                    url: 'models.scnassets/Tita_Anim_Cepillado.dae',
                    position: vector.Vector3(0, 0, 0),
                    scale: vector.Vector3(0.01, 0.01, 0.01));

                arkitController.add(node,
                    parentNodeName: aRKitAnchor!.nodeName);

                player.play();
                arkitController.remove('tita-idle');
              }
            });
          }
        } else {
          _timer.cancel();
          player.pause();
        }
      }
    }
// }

  Future<bool> _isClient() async {
    bool client = await authenticationService.isClient();
    int countBrush = await childrenService.seeBrush();

    //Cantidad de veces permitidas para usuarios que no son clientes
    if (!client && countBrush > 2) {
      navigatorPlus.showModal(PayScreen());
      return false;
    } else {
      return true;
    }
  }

  Future _startBrushing(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: Utils.translate("remember"),
            descriptions: Utils.translate("father_brush"),
            textBtnAcept: Utils.translate("begin"),
          );
        });
  }

void showChildrenSelectionDialog() async {
  List<PersonModel> children = await childrenService.get();
  if (children.isEmpty) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      List<PersonModel> selectedChildren = List.from(_childrensSelected);




       return StatefulBuilder(
        builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).popUntil((route) => route.isFirst);
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Selecciona un usuario",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: double.maxFinite,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      final child = children[index];
                      bool isSelected = selectedChildren.contains(child);

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.face, color: Colors.blueAccent),
                          title: Text(
                            '${child.name ?? "Sin nombre"} ${child.lastNames ?? ""}',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : Icon(Icons.check_circle_outline, color: Colors.grey),
                          onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedChildren.remove(child);
                                } else {
                                  selectedChildren
                                    ..clear()
                                    ..add(child);
                                }
                              });
                            },
                        ),
                      );
                    },
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.grey,
                      ),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1),                
                      ElevatedButton(
                      onPressed: selectedChildren.isNotEmpty
                          ? () {
                              setState(() {
                                _childrensSelected = selectedChildren.map((child) {
                                  child.check = true;
                                  return child;
                                }).toList();
                                _hasConfirmedSelection = true;
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_hasConfirmedSelection && !_controllerCount.isStarted.value) {
                                  _controllerCount.start();
                                }
                              });
                              Navigator.pop(context, selectedChildren);
                            }
                          : null,
                      child: Text("Continuar"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

      
      // return StatefulBuilder(
      //   builder: (context, setState) {
      //     return WillPopScope(
      //       onWillPop: () async {
      //         Navigator.of(context).popUntil((route) => route.isFirst);
      //         return false;
      //       },
      //       child: AlertDialog(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(16),
      //         ),
      //         title: Text(
      //           "Selecciona uno o más usuarios",
      //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      //           textAlign: TextAlign.center,
      //         ),
      //         content: Container(
      //           width: double.maxFinite,
      //           child: ConstrainedBox(
      //             constraints: BoxConstraints(
      //               maxHeight: MediaQuery.of(context).size.height * 0.5,
      //             ),
      //             child: ListView.builder(
      //               shrinkWrap: true,
      //               itemCount: children.length,
      //               itemBuilder: (context, index) {
      //                 final child = children[index];
      //                 bool isSelected = selectedChildren.contains(child);

      //                 return Card(
      //                   elevation: 4,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(12),
      //                   ),
      //                   child: ListTile(
      //                     leading: Icon(Icons.face, color: Colors.blueAccent),
      //                     title: Text(
      //                       '${child.name ?? "Sin nombre"} ${child.lastNames ?? ""}',
      //                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      //                     ),
      //                     trailing: isSelected
      //                         ? Icon(Icons.check_circle, color: Colors.green)
      //                         : Icon(Icons.check_circle_outline, color: Colors.grey),
      //                     onTap: () {
      //                       setState(() {
      //                         if (isSelected) {
      //                           selectedChildren.remove(child);
      //                         } else {
      //                           selectedChildren.add(child);
      //                         }
      //                       });
      //                     },
      //                   ),
      //                 );
      //               },
      //             ),
      //           ),
      //         ),
      //         actions: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.of(context).popUntil((route) => route.isFirst);
      //                 },
      //                 style: ElevatedButton.styleFrom(
      //                   iconColor: Colors.grey,
      //                 ),
      //                 child: Text(
      //                   "Cancelar",
      //                   style: TextStyle(
      //                     color: Colors.black,
      //                     fontWeight: FontWeight.w400,
      //                     fontSize: 14,
      //                   ),
      //                 ),
      //               ),
      //                 SizedBox(
      //                   width: MediaQuery.of(context).size.width * 0.1),                
      //                 ElevatedButton(
      //                 onPressed: selectedChildren.isNotEmpty
      //                     ? () {
      //                         setState(() {
      //                           _childrensSelected = selectedChildren.map((child) {
      //                             child.check = true;
      //                             return child;
      //                           }).toList();
      //                           _hasConfirmedSelection = true;
      //                         });
      //                         WidgetsBinding.instance.addPostFrameCallback((_) {
      //                           if (_hasConfirmedSelection && !_controllerCount.isStarted.value) {
      //                             _controllerCount.start();
      //                           }
      //                         });
      //                         Navigator.pop(context, selectedChildren);
      //                       }
      //                     : null,
      //                 child: Text("Continuar"),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );
    },
  );
}

  Widget _loadChildens() {
    if (_childrensSelected.isEmpty) {
      return FutureBuilder<List<PersonModel>>(
        future: childrenService.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerWidget(
              child: ChildrenHorizontal(items: [
                PersonModel(name: ''),
                PersonModel(name: ''),
                PersonModel(name: '')
              ]),
            );
          } else if (snapshot.hasData) {
            _allChildrens = snapshot.data!;
            return ChildrenHorizontal(
              items: _allChildrens,
            );
          } else {
            return Text("Error al cargar los datos");
          }
        },
      );
    } else {
      return ChildrenHorizontal(items: _childrensSelected);
    }
  }


  void startTimer(BuildContext context) {
    if (_timer.isActive) {
      _timer.cancel();
    } else {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
              _finishBrush(context);
              _start = _totalTime;
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }


  void _finishBrush(BuildContext context) async {
  final selectedChild = _childrensSelected.first;

  await childrenService.addBrushing([selectedChild]);

  Navigator.pushNamed(
    context,
    '/beforeCleaning_page',
    arguments: {
      'fromBrushing': true,
      'child': selectedChild,
    },
  );
}



  // void _finishBrush(BuildContext context) async {
  //   await childrenService.addBrushing(_childrensSelected);

  //   List<PersonModel> childrensSelectedAvailableCount =
  //       await childrenService.childrenBrushingAvailable(_childrensSelected);

  //   if (childrensSelectedAvailableCount.isNotEmpty) {
  //     await childrenService.addBBbCashBulk(
  //         childrensSelectedAvailableCount, "tita_brush");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(Utils.translate('add_bbcash'))),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(Utils.translate('limited_bbcash_day'))),
  //     );
  //   }

  //   _childrensSelected = [];

  //   Navigator.pushNamed(context, '/stats_page').then((value) {
  //     Navigator.pop(context);
  //   });
  // }
}