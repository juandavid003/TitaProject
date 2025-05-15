import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

class ArBrushPageAndroid extends StatefulWidget {
  @override
  _ArBrushPageAndroidState createState() => _ArBrushPageAndroidState();
}

class _ArBrushPageAndroidState extends State<ArBrushPageAndroid> {
  ArCoreController? arCoreController;

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AR Brush')),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    // Cargar el modelo GLTF desde los activos locales
    _loadGLTFModel();
  }

  Future<void> _loadGLTFModel() async {
    final modelPath = 'assets/AnimatedCube.gltf';  // Ruta de tu archivo GLTF en los activos

    // Crear un nodo de referencia ARCore para cargar el modelo GLTF
    final node = ArCoreReferenceNode(
      name: 'gltf_model',
      objectUrl: modelPath, // Se usa la ruta del archivo en los activos locales
    );

    arCoreController?.addArCoreNodeWithAnchor(node);
  }
}
