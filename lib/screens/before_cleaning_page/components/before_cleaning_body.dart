import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/models/person_model.dart';
import 'package:odontobb/screens/after_cleaning_page/after_cleaning_screen.dart';
import 'package:odontobb/screens/after_cleaning_page/components/after_cleaning_body.dart';
import 'package:odontobb/screens/diagnosis_page/diagnosis_screen.dart';
import 'package:odontobb/screens/home_page/home_screen.dart';
import 'package:odontobb/services/children_service.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/children_horizontal.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/navigator_plus.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart'
    as img; // Asegúrate de tener esta librería importada

class BeforeCleaningBody extends StatefulWidget {
  final bool cameFromBrushing;
  final PersonModel? selectedChild;

  const BeforeCleaningBody({
    super.key,
    this.cameFromBrushing = false,
    this.selectedChild,
  });

  @override
  _BeforeCleaningBodyState createState() => _BeforeCleaningBodyState();
}


class HolePainter extends CustomPainter {
  final Offset position; // Permite mover el rectángulo
  HolePainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.black.withOpacity(0.4);
    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    RRect transparentRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: position, width: 300, height: 200),
      Radius.circular(20),
    );
    canvas.drawPath(
      Path.combine(
          PathOperation.difference, path, Path()..addRRect(transparentRRect)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BeforeCleaningBodyState extends State<BeforeCleaningBody> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  XFile? _imageFile;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex =
      0; // Índice para alternar cámaras (1 por defecto para frontal)
  double _currentZoomLevel = 1.0;
  List<PersonModel> _childrensSelected = [];
  List<PersonModel> _allChildrens = [];
  ChildrenService childrenService = ChildrenService();
  final CountDownController _controllerCount = CountDownController();

@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (widget.selectedChild != null) {
      // Ya viene seleccionado desde el flujo de cepillado
      setState(() {
        _childrensSelected = [widget.selectedChild!];
      });
    } else {
      // Mostrar el diálogo para seleccionar el niño
      final selectedPerson = await showChildrenSelectionDialog();
      if (selectedPerson != null) {
        setState(() {
          _childrensSelected = [selectedPerson];
        });
      }
    }
  });

  _initializeCamera();
}


  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera(
      {CameraLensDirection direction = CameraLensDirection.back}) async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      // Seleccionar la cámara según la dirección especificada
      _selectedCameraIndex =
          _cameras.indexWhere((camera) => camera.lensDirection == direction);
      if (_selectedCameraIndex == -1) {
        _selectedCameraIndex =
            0; // En caso de no encontrar la dirección deseada, usar la primera disponible
      }

      _cameraController = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await _cameraController?.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error al inicializar la cámara: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Utils.translate("home_diagnosis"),
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          GestureDetector(
onTap: () async {
  await disposeCameraAfterDelay();


  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DiagnosisScreen(
        personModel: _childrensSelected[0], // Aquí pasas el PersonModel seleccionado
      ),
    ),
  ).then((_) async {
    _initializeCamera();
              final selectedPerson = await showChildrenSelectionDialog();
              if (selectedPerson != null) {
                setState(() {
                  _childrensSelected = [selectedPerson];
                });
              }  });
},



            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    color: Utils.isDarkMode
                        ? kWhiteColor
                        : const Color.fromARGB(255, 255, 0, 0),
                    size: kLargeFontSize,
                  ),
                  NormalText(
                    text: "Historial",
                    textSize: kExtraMicroFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_imageFile != null)
            Positioned.fill(
              child: Center(
                child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
              ),
            )
          else if (_isCameraInitialized)
            Positioned.fill(
              child: Center(
                child: Transform.scale(
                  scale: 1.2,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),

          Positioned.fill(
            child: CustomPaint(
              painter: HolePainter(position: Offset(200, 350)),//Aqui modifica x y del recuadro
            ),
          ),

          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: _loadChildens(),
          // ),

          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Center(
              child: Text(
                "Elige de quien sera la foto y muestra tu mejor sonrisa enseñando los dientes en el recuadro",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

           Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Center(
              child: Text(
                "Este diagnóstico no es 100% preciso. Para obtener un diagnóstico certero, te recomendamos agendar tu cita con un especialista.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          if (_imageFile == null)
            Positioned(
              top: 15,
              right: 5,
              child: FloatingActionButton(
                mini: true,
                onPressed: _switchCamera,
                child: Icon(Icons.cameraswitch),
              ),
            ),

          if (_imageFile != null)
            Positioned(
              top: 15,
              left: 5,
              child: IconButton(
                icon:
                    Icon(Icons.close, color: Color.fromARGB(255, 255, 62, 62)),
                onPressed: _retakePicture,
              ),
            ),

           Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              onPressed: _childrensSelected.isEmpty
                  ? null
                  : () async {
                      if (_imageFile != null && _childrensSelected.isNotEmpty) {
                        File imageFile = File(_imageFile!.path);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.remove('imageUrl');
                        await prefs.remove('assistantResponse');
                        FileService.uploadImage(
                          imageFile,
                          _childrensSelected[0].id!,
                        );
                        disposeCameraAfterDelay();

                        // Aquí pasas el parámetro
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AfterCleaningScreen(
                              cameFromBrushing: widget.cameFromBrushing, // Uso de nombre de argumento
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      } else {
                        _takePicture();
                      }
                    },
              backgroundColor: _childrensSelected.isEmpty
                  ? Colors.grey
                  : Theme.of(context).primaryColor,
              child: Icon(
                _imageFile == null ? Icons.camera : Icons.check,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<PersonModel?> showChildrenSelectionDialog() async {
  List<PersonModel> children = await childrenService.get();
  if (children.isEmpty) return null;

  return showDialog<PersonModel>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return false;
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      "Selecciona un usuario",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.maxFinite,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: children.length,
                        itemBuilder: (context, index) {
                          final child = children[index];
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
                              onTap: () {
                                Navigator.pop(context, child); // <- Devuelve el child seleccionado
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  disposeCameraAfterDelay() {
    Future.delayed(Duration(seconds: 3), () {
      _cameraController!.dispose();
      setState(() {
        _isCameraInitialized = false;
      });
    });
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    final newDirection =
        _cameras[_selectedCameraIndex].lensDirection == CameraLensDirection.back
            ? CameraLensDirection.front
            : CameraLensDirection.back;

    await _cameraController?.dispose();
    _cameraController = null;

    setState(() {
      _isCameraInitialized = false;
    });

    _initializeCamera(direction: newDirection);
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      XFile file = await _cameraController!.takePicture();
      setState(() {
        _imageFile = file;
        _isCameraInitialized = true; // Ocultamos la cámara
      });
    } catch (e) {
      print('Error al tomar la foto: $e');
    }
  }

  void _retakePicture() {
    setState(() {
      _imageFile = null;
    });
    _initializeCamera();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    setState(() {
      _currentZoomLevel = (_currentZoomLevel * details.scale)
          .clamp(1.0, _cameraController!.value.aspectRatio);
    });

    _cameraController?.setZoomLevel(_currentZoomLevel);
  }

  Future<void> _onTapFocus(TapUpDetails details) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    // Obtén la posición tocada
    final x = details.localPosition.dx / MediaQuery.of(context).size.width;
    final y = details.localPosition.dy / MediaQuery.of(context).size.height;

    // Establecer el punto de enfoque
    await _cameraController?.setFocusPoint(
      Offset(x, y),
    );
    await _cameraController?.setExposurePoint(Offset(x, y));
  }

  Widget _loadChildens() {
    if (_childrensSelected.isEmpty) {
      return FutureBuilder(
        future: childrenService.get(),
        builder: (context, AsyncSnapshot<List<PersonModel>> snapshot) {
          if (snapshot.hasData) {
            _allChildrens = snapshot.data!;
            _controllerCount.start();
            return Row(
              children: [
                _addChildren(),
                Expanded(
                  child: ChildrenHorizontal(
                    items: snapshot.data!,
                    callback: (val) {
                      setState(() {
                        _childrensSelected.addAll(
                            val.where((e) => !_childrensSelected.contains(e)));
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                _addChildren(),
                Expanded(
                  child: ShimmerWidget(
                    child: ChildrenHorizontal(items: [
                      PersonModel(name: ''),
                      PersonModel(name: ''),
                      PersonModel(name: '')
                    ]),
                  ),
                ),
              ],
            );
          }
        },
      );
    } else {
      return Row(
        children: [
          _addChildren(),
          Expanded(
            child: ChildrenHorizontal(
              items: _childrensSelected,
              callback: (val) {
                setState(() {
                  _childrensSelected.addAll(
                      val.where((e) => !_childrensSelected.contains(e)));
                });
              },
            ),
          ),
        ],
      );
    }
  }

  _addChildren() {
    return SizedBox(
        height: 70.0,
        width: Utils.size(context).width * 0.25,
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.person_add,
                size: 40.0,
                color: kButtonColor,
              ),
              NormalText(
                text: Utils.translate("add"),
                textSize: kSubTitleFontSize,
                fontWeight: FontWeight.w500,
                textColor: kButtonColor,
              ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/children_form').then((value) => {});
          },
        ));
  }
}