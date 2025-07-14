// ignore_for_file: unused_field, must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:odontobb/services/authentication_service.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/services/purchases_service.dart';
import 'package:odontobb/services/webview_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
// import 'package:flutter/services.dart';
import 'package:styled_text/styled_text.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ItemDetailScreen extends StatefulWidget {
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
  final String? id;
  final String title;
  final String? description;
  final String? bibliographicalCitation;
  String? imageUrl;
  final String? linkDemo;
  final String? linkProduct;
  final String? category;
  final double? price;
  final bool? forClients;
  bool? paid;
  final String? imageName;
  final String? from;

  @override
  ItemDetailScreen(
      {super.key,
      this.id,
      required this.title,
      this.description,
      this.bibliographicalCitation = '',
      this.imageUrl,
      this.linkDemo = '',
      this.linkProduct,
      this.category,
      this.price,
      this.forClients,
      this.paid = false,
      this.imageName = '',
      this.from = ''});
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final PurchasesService _purchasesService = PurchasesService();
  final AuthenticationService _authenticationService =
      AuthenticationService(FirebaseAuth.instance);

  bool client = true; //default false
  bool autoPlay = true;

  // Controlador para el reproductor de YouTube
  YoutubePlayerController? _controller;
  bool _isControllerInitialized = false;

  // Estado para controlar la visualización del video
  bool _showThumbnail = true;
  String? _currentVideoId;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    if (_isControllerInitialized && _controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  getInfo() async {
    await Future.delayed(Duration(seconds: Utils.loadingTime));
    //client = await _authenticationService.isClient();
    if (mounted) setState(() {});
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    switch (widget.from) {
      case 'ToLearn':
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
          FileService.loadImage('products/${widget.imageName}')
              .then((snapshot) {
            if (snapshot != null && snapshot.isNotEmpty) {
              setState(() {
                widget.imageUrl = snapshot;
              });
            }
          });
        }
        break;

      case 'DidYouKnow':
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
          FileService.loadImage('tips/${widget.imageName}').then((snapshot) {
            if (snapshot != null && snapshot.isNotEmpty) {
              setState(() {
                widget.imageUrl = snapshot;
              });
            }
          });
        }
        break;
      default:
        break;
    }

    final hero = Hero(
      tag: widget.title ?? "defaultTag",
      child: Material(
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.imageUrl!),
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
            expandedHeight: 300.0,
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
                        child: hero,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          "assets/images/odontobbIcon.png",
                          height: 40,
                        ),
                      ),
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
                      NormalText(
                        textOverflow: TextOverflow.visible,
                        text: widget.title,
                        textColor: Utils.isDarkMode
                            ? kDarkTextColorColor
                            : Colors.black54,
                        textSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      widget.description?.isNotEmpty == true
                          ? StyledText(
                              text: "<p>${widget.description!}</p>",
                              newLineAsBreaks: true,
                              tags: {
                                'b': StyledTextTag(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                'p': StyledTextTag(
                                  style: TextStyle(
                                    color: Utils.isDarkMode
                                        ? kDarkTextColorColor
                                        : Colors.black54,
                                    fontSize: kSubTitleFontSize,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              },
                              textAlign: TextAlign.justify,
                            )
                          : Container(),
                      const SizedBox(
                        height: 40.0,
                      ),
                      widget.bibliographicalCitation?.isNotEmpty == true
                          ? NormalText(
                              textOverflow: TextOverflow.visible,
                              text: widget.bibliographicalCitation!,
                              textColor: Utils.isDarkMode
                                  ? kDarkTextColorColor
                                  : Colors.black54,
                              textSize: kMicroFontSize,
                            )
                          : Container(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      widget.linkDemo?.isNotEmpty == true
                          ? _showVideoDemo(context, widget.linkDemo!)
                          : Container(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      widget.price?.isFinite == true
                          ? _checkPayProduct(client)
                          : Container(),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showVideoDemo(BuildContext context, String linkDemo) {
    try {
      // Intentar extraer el ID del video de la URL usando youtube_player_flutter
      final videoId = YoutubePlayer.convertUrlToId(linkDemo);

      // Si no se puede extraer el ID, mostrar un contenedor vacío
      if (videoId == null) {
        print('No se pudo extraer el ID del video de la URL: $linkDemo');
        return Container();
      }

      // Guardar el ID del video actual
      _currentVideoId = videoId;

      // URL de la miniatura de alta calidad
      String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

      // Retornar el reproductor de YouTube con manejo de errores
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del video (opcional)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Video Demostrativo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Utils.isDarkMode ? kDarkTextColorColor : Colors.black87,
              ),
            ),
          ),
          // Contenedor del video con aspecto profesional
          Container(
            width: MediaQuery.of(context).size.width,
            // Usar AspectRatio para mantener la relación 16:9 estándar para videos
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  // Bordes redondeados para aspecto más profesional
                  borderRadius: BorderRadius.circular(8.0),
                  // Sombra sutil para dar profundidad
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  // Color de fondo mientras carga el video
                  color: Colors.black,
                ),
                // Clip para asegurar que el video respete los bordes redondeados
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: _showThumbnail
                      ? _buildThumbnail(context, videoId, thumbnailUrl)
                      : _buildYoutubePlayer(videoId),
                ),
              ),
            ),
          ),
          // Espacio después del video
          SizedBox(height: 16),
        ],
      );
    } catch (e) {
      // Capturar cualquier error que ocurra durante la inicialización
      print('Error en _showVideoDemo: $e');
      return _showErrorWidget();
    }
  }

  // Construye la miniatura con un botón de reproducción
  Widget _buildThumbnail(
      BuildContext context, String videoId, String thumbnailUrl) {
    return GestureDetector(
      onTap: () {
        // Al hacer clic en la miniatura, inicializar el reproductor y mostrar el video
        setState(() {
          _showThumbnail = false;
          _initializeYoutubePlayer(videoId);
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Miniatura del video
          Image.network(
            thumbnailUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              );
            },
          ),
          // Icono de reproducción superpuesto
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
          // Texto de instrucción
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Toca para reproducir el video',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Inicializa el reproductor de YouTube
  void _initializeYoutubePlayer(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: true,
        hideControls: false,
      ),
    );
    _isControllerInitialized = true;

    // Forzar un rebuild después de un breve retraso
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) setState(() {});
    });
  }

  // Construye el reproductor de YouTube
  Widget _buildYoutubePlayer(String videoId) {
    if (_controller == null) {
      _initializeYoutubePlayer(videoId);
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
      );
    }

    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: kPrimaryColor,
      progressColors: ProgressBarColors(
        playedColor: kPrimaryColor,
        handleColor: kPrimaryColor,
      ),
      onReady: () {
        print('Player is ready.');
        // Reproducir el video automáticamente cuando esté listo
        _controller!.play();

        // Forzar un rebuild para asegurar que el video se muestre correctamente
        if (mounted) setState(() {});
      },
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: ProgressBarColors(
            playedColor: kPrimaryColor,
            handleColor: kPrimaryColor,
          ),
        ),
        RemainingDuration(),
        FullScreenButton(),
      ],
    );
  }

  Widget _showErrorWidget() {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 50, color: Colors.red),
            SizedBox(height: 10),
            Text(
              'Error al cargar el video',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _checkPayProduct(bool client) {
  return Container();
  // return FutureBuilder(
  // future: _purchasesService.get(widget.id!),
  // builder:
  //     (BuildContext context, AsyncSnapshot<List<PurchaseModel>> snapshot) {
  //   if ((snapshot.hasData && snapshot.data!.length > 0) ||
  //       client && widget.forClients!) {
  //     return _getProduct(context);
  //   } else {
  //     return _buyRegion(context);
  //   }
  // });
}

// _getProduct(BuildContext context) {
//   return Align(
//       alignment: Alignment.bottomRight,
//       child: DefaultButton(
//         buttonTitle: Utils.translate("view_content"),
//         width: double.infinity,
//         onPress: () {
//           VideoModel video = new VideoModel(
//               widget.linkProduct!, widget.category!, widget.title);

//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) {
//               return WebViewWidget(videoModel: video);
//             }),
//           );
//         },
//       ));
// }

// _buyRegion(BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       Padding(
//         padding: EdgeInsets.only(top: 15.0),
//         child: NormalText(
//           textOverflow: TextOverflow.visible,
//           text: '\$ ${widget.price.toString()}',
//           textColor: Utils.isDarkMode ? kDarkTextColorColor : Colors.black,
//           textSize: kLargeFontSize,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       _btnBuyProduct(context)
//     ],
//   );
// }

// _btnBuyProduct(BuildContext context) {
//   // final _paymentItems = [
//   //   PaymentItem(
//   //     label: '${widget.category} - ${widget.title}',
//   //     amount: widget.price.toString(),
//   //     status: PaymentItemStatus.final_price,
//   //   )
//   // ];
//   // return Row(children: [
//   //   ApplePayButton(
//   //     paymentConfigurationAsset: 'applepay.json',
//   //     paymentItems: _paymentItems,
//   //     width: 200,
//   //     height: 50,
//   //     style: ApplePayButtonStyle.black,
//   //     type: ApplePayButtonType.buy,
//   //     margin: const EdgeInsets.only(top: 15.0),
//   //     onPaymentResult: onPayResult,
//   //     loadingIndicator: const Center(
//   //       child: CircularProgressIndicator(),
//   //     ),
//   //   ),
//   //   GooglePayButton(
//   //     paymentConfigurationAsset: 'gpay.json',
//   //     paymentItems: _paymentItems,
//   //     style: GooglePayButtonStyle.black,
//   //     type: GooglePayButtonType.pay,
//   //     margin: const EdgeInsets.only(top: 15.0),
//   //     onPaymentResult: onPayResult,
//   //     loadingIndicator: const Center(
//   //       child: CircularProgressIndicator(),
//   //     ),
//   //   ),
//   // ]);
// }

// void onPayResult(paymentResult) {
//   // Send the resulting Apple Pay token to your server / PSP
//   PurchaseModel purchase = new PurchaseModel();
//   purchase.productId = widget.id;
//   purchase.userId = Utils.globalFirebaseUser!.uid;
//   purchase.price = widget.price;

//   _purchasesService.save(purchase).then((value) {
//     _authenticationService.activeClient(true);
//     setState(() {
//       widget.paid = true;
//     });
//   });
// }
