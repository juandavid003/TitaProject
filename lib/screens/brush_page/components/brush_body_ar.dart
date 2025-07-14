// import 'dart:async';
// import 'package:odontobb/screens/pay_page/pay_screen.dart';
// import 'package:odontobb/services/authentication_service.dart';
// import 'package:odontobb/widgets/navigator_plus.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:arkit_plugin/arkit_plugin.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
// import 'package:intl/intl.dart';
// import 'package:odontobb/models/person_model.dart';
// import 'package:odontobb/services/children_service.dart';
// import 'package:odontobb/widgets/children_horizontal.dart';
// import 'package:odontobb/widgets/custom_elements/custom_dialog_box.dart';
// import 'package:odontobb/widgets/custom_elements/normal_text.dart';
// import 'package:odontobb/widgets/shimmer_widger.dart';
// import 'package:just_audio/just_audio.dart';
// import '../../../constant.dart';
// import '../../../util.dart';

// class ArBrushPage extends StatefulWidget {
//   @override
//   _ArBrushPageState createState() => _ArBrushPageState();
// }

// class _ArBrushPageState extends State<ArBrushPage> {
//   ChildrenService childrenService = new ChildrenService();
//   AuthenticationService authenticationService =
//       new AuthenticationService(FirebaseAuth.instance);

//   late ARKitController arkitController;
//   ARKitReferenceNode node = new ARKitReferenceNode(url: '');
//   late ARKitAnchor aRKitAnchor;
//   AudioPlayer player = AudioPlayer();
//   String anchorId = '';
//   bool play = false;
//   Timer _timer = new Timer(const Duration(seconds: 0), () {});
//   int _start = 78;
//   int _totalTime = 78;
//   final DateFormat formatter = DateFormat('m:ss');
//   List<PersonModel> _childrensSelected = [];
//   List<PersonModel> _allChildrens = [];

//   @override
//   void initState() {
//     this._allChildrens = [];
//     this._childrensSelected = [];
//     super.initState();
//   }

//   @override
//   void dispose() {
//     arkitController.dispose();
//     player.dispose();
//     super.dispose();
//     getInfo();
//   }

//   getInfo() async {
//     //final client = await authenticationService.isClient();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Utils.isDarkMode ? kDarkBgColor : kDefaultBgColor,
//       appBar: AppBar(
//           title: NormalText(
//         text: Utils.translate("brush"),
//         textSize: kPriceFontSize,
//         fontWeight: FontWeight.w600,
//       )),
//       floatingActionButton:
//           Column(mainAxisAlignment: MainAxisAlignment.end, children: [
//         // FloatingActionButton(
//         //   child: Icon(Icons.map),
//         //   onPressed: () async {
//         //     _addScene(this.arkitController);
//         //   },
//         //   heroTag: null,
//         // ),
//         SizedBox(
//           height: 10,
//         ),
//         FloatingActionButton(
//           child: Icon(
//             play ? Icons.pause : Icons.play_arrow,
//             size: 40.0,
//           ),
//           backgroundColor: kButtonColor,
//           onPressed: () async {
//             if (_allChildrens.isEmpty) {
//               Navigator.pushNamed(context, '/children_form')
//                   .then((value) => {getInfo()});
//             } else {
//               setState(() => play = !play);
//               if (play) {
//                 startTimer(context);

//                 if (_start == _totalTime && play) {
//                   if (_childrensSelected.isEmpty) {
//                     _childrensSelected = _allChildrens.map((e) {
//                       e.check = true;
//                       return e;
//                     }).toList();
//                   }
//                   _startBrushing(context).then((value) async {
//                     if (value && node.url.isNotEmpty) {
//                       await player.setAsset('assets/audio/brushing.mp3');

//                       node = ARKitReferenceNode(
//                           name: 'tita',
//                           url: 'models.scnassets/Tita_Anim_Cepillado.dae',
//                           position: vector.Vector3(0, 0, 0),
//                           scale: vector.Vector3(0.01, 0.01, 0.01));

//                       arkitController.add(node,
//                           parentNodeName: aRKitAnchor.nodeName);

//                       player.play();
//                       arkitController.remove('tita-idle');

//                       await Future.delayed(Duration(seconds: _totalTime));
//                       player.stop();
//                     }
//                   });
//                 }
//                 // await arkitController?.playAnimation
//                 //     key: 'tita',
//                 //     sceneName: 'models.scnassets/TitaAnimTest02',
//                 //     animationIdentifier: 'keyframedAnimations1');
//               } else {
//                 _timer.cancel();
//                 //_timer = null;
//                 //await arkitController?.stopAnimation(key: 'tita');
//                 //arkitController?.remove('tita');
//               }
//             }
//           },
//           heroTag: null,
//         )
//       ]),
//       body: Container(
//         child: Stack(children: [
//           ARKitSceneView(
//             key: Key('tita'),
//             showFeaturePoints: true,
//             forceUserTapOnCenter: true,
//             planeDetection: ARPlaneDetection.horizontal,
//             onARKitViewCreated: onARKitViewCreated,
//           ),
//           _initClock(),
//           Row(
//             children: [
//               _addChildren(),
//               _loadChildens(),
//             ],
//           )
//         ]),
//       ),
//     );
//   }

//   void onARKitViewCreated(ARKitController arkitController) async {
//     this.arkitController = arkitController;

//     this.arkitController.onAddNodeForAnchor = _handleAddAnchor;

//     //show OdontoBb virtual tour
//     //_addScene(this.arkitController);

//     bool client = await authenticationService.isClient();
//     int countBrush = await childrenService.seeBrush();

//     if (!client && countBrush > 2)
//       navigatorPlus
//           .showModal(PayScreen())!
//           .then((value) => Navigator.pop(context));
//     else
//       this._showDialogFindModel(context);
//   }

//   void _handleAddAnchor(ARKitAnchor anchor) {
//     if (!(anchor is ARKitPlaneAnchor)) {
//       return;
//     }
//     _addPlane(anchor);
//   }

//   void _addPlane(ARKitPlaneAnchor anchor) {
//     aRKitAnchor = anchor;
//     anchorId = anchor.identifier;
//     if (node.url.isEmpty) {
//       node = ARKitReferenceNode(
//         name: 'tita',
//         url: 'models.scnassets/Tita_Anim_Saludo.dae',
//         position: vector.Vector3(0, 0, 0),
//         scale: vector.Vector3(0.01, 0.01, 0.01),
//       );

//       arkitController.add(node, parentNodeName: anchor.nodeName);
//       arkitController.snapshot().then((value) async {
//         await player.setAsset('assets/audio/greeting.mp3');
//         player.play();

//         await Future.delayed(Duration(seconds: 7));

//         if (!play) {
//           node = ARKitReferenceNode(
//               name: 'tita-idle',
//               url: 'models.scnassets/Tita_Anim_Idle.dae',
//               position: vector.Vector3(0, 0, 0),
//               scale: vector.Vector3(0.01, 0.01, 0.01));

//           arkitController.add(node, parentNodeName: anchor.nodeName);

//           arkitController.remove('tita');
//         }
//       });
//     }
//   }

//   Future _startBrushing(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CustomDialogBox(
//             title: Utils.translate("remember"),
//             descriptions: Utils.translate("father_brush"),
//             textBtnAcept: Utils.translate("begin"),
//           );
//         });
//   }

//   Widget _initClock() {
//     return _start < _totalTime && _start != 0 && play
//         ? Container(
//             padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
//             margin: EdgeInsets.all(0.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(70.0),
//                   child: Container(
//                     color: Colors.white,
//                     width: 100.0,
//                     height: 100.0,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image(
//                           image: AssetImage("assets/images/reloj-de-arena.gif"),
//                           height: 50.0,
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )
//         : Container();
//   }

//   Widget _loadChildens() {
//     if (_childrensSelected.isEmpty) {
//       return FutureBuilder(
//           future: childrenService.get(),
//           builder: (context, AsyncSnapshot<List<PersonModel>> snapshot) {
//             if (snapshot.hasData) {
//               _allChildrens = snapshot.data!;
//               return ChildrenHorizontal(
//                   items: snapshot.data!,
//                   callback: (val) => _childrensSelected = val);
//             } else {
//               return ShimmerWidget(
//                   child: ChildrenHorizontal(items: [
//                 new PersonModel(name: ''),
//                 new PersonModel(name: ''),
//                 new PersonModel(name: '')
//               ]));
//             }
//           });
//     } else {
//       return ChildrenHorizontal(items: _childrensSelected);
//     }
//   }

//   // void _addScene(ARKitController controller) {
//   //   final material = ARKitMaterial(
//   //     diffuse: ARKitMaterialProperty(image: 'assets/images/quito-out.jpg'),
//   //     doubleSided: true,
//   //   );
//   //   final sphere = ARKitSphere(
//   //     materials: [material],
//   //     radius: 1,
//   //   );

//   //   final node = ARKitNode(
//   //     geometry: sphere,
//   //     position: vector.Vector3.zero(),
//   //     eulerAngles: vector.Vector3.zero(),
//   //   );
//   //   controller.add(node);
//   // }

//   void startTimer(BuildContext context) {
//     if (_timer.isActive) {
//       _timer.cancel();
//     } else {
//       _timer = new Timer.periodic(
//         const Duration(seconds: 1),
//         (Timer timer) => setState(
//           () {
//             if (_start < 1) {
//               timer.cancel();
//               _finishBrush(context);
//               _start = _totalTime;
//             } else {
//               _start = _start - 1;
//             }
//           },
//         ),
//       );
//     }
//   }

//   void _finishBrush(BuildContext context) async {
//     await childrenService.addBrushing(_childrensSelected);
//     _childrensSelected = [];

//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CustomDialogBox(
//             title: Utils.translate("congratulations"),
//             descriptions: Utils.translate("congratulations_description"),
//             textBtnAcept: Utils.translate("exit"),
//           );
//         }).then((value) async {
//       if (value) {
//         Navigator.pop(context);
//         Navigator.pushNamed(context, '/stats_page')
//             .then((value) => Navigator.pop(context));
//       }
//     });

//     await Future.delayed(Duration(seconds: 1));
//     Navigator.pushNamed(context, '/stats_page');
//   }

//   _addChildren() {
//     return Container(
//         height: 70.0,
//         width: Utils.size(context).width * 0.25,
//         child: GestureDetector(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Icon(
//                 Icons.person_add,
//                 size: 40.0,
//                 color: kWhiteColor,
//               ),
//               NormalText(
//                 text: Utils.translate("add"),
//                 textSize: kSubTitleFontSize,
//                 fontWeight: FontWeight.w500,
//                 textColor: kWhiteColor,
//               ),
//             ],
//           ),
//           onTap: () {
//             Navigator.pushNamed(context, '/children_form')
//                 .then((value) => {getInfo()});
//           },
//         ));
//   }

//   void _showDialogFindModel(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CustomDialogBox(
//             title: Utils.translate("find_tita"),
//             descriptions: Utils.translate("find_tita_description"),
//             textBtnAcept: Utils.translate("agreed"),
//           );
//         }).then((value) async {
//       if (value) {
//         print('buscar');
//       }
//     });
//   }
// }
