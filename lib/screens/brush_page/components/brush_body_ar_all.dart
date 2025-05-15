// import 'package:ar_flutter_plugin/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin/models/ar_node.dart';
// import 'package:flutter/material.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:vector_math/vector_math_64.dart';

// class ArBrushPageAll extends StatefulWidget {
//   const ArBrushPageAll({super.key});

//   @override
//   State<ArBrushPageAll> createState() => _ArBrushPageAllState();
// }

// class _ArBrushPageAllState extends State<ArBrushPageAll> {
//   late ARSessionManager arSessionManager;
//   late ARObjectManager arObjectManager;
//   ARNode? modelNode;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("AR con Animación")),
//       body: ARView(
//         onARViewCreated: onARViewCreated,
//       ),
//     );
//   }

//   void onARViewCreated(ARSessionManager sessionManager, ARObjectManager objectManager, ARAnchorManager anchorManager, ARLocationManager locationManager) {
//     arSessionManager = sessionManager;
//     arObjectManager = objectManager;

//     arSessionManager.onInitialize(
//       showFeaturePoints: false,
//       showPlanes: true,
//       showWorldOrigin: true,
//     );

//     arObjectManager.onInitialize();

//     // Llama al método para cargar el modelo
//     _addAnimatedModel();
//   }

//   Future<void> _addAnimatedModel() async {
// final node = ARNode(
//   type: NodeType.webGLB,
//   uri: "https://firebasestorage.googleapis.com/v0/b/odontobbapp.appspot.com/o/glb%2FUntitled.glb?alt=media&token=8f45f6fa-17e5-471d-88df-7337494442a5",
//   scale: Vector3(1.0, 1.0, 1.0),
//   position: Vector3(0.0, 0.0, -0.5),
// );
// await arObjectManager.addNode(node);

//   bool didAddNode = (await arObjectManager.addNode(node)) ?? false;
//     if (didAddNode) {
//       modelNode = node;
//       print("Modelo animado agregado");
//     } else {
//       print("Error al agregar el modelo");
//     }
//   }

//   @override
//   void dispose() {
//     arSessionManager.dispose();
//     super.dispose();
//   }
// }
