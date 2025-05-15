// ignore_for_file: unused_field

// import 'package:odontobb/constant.dart';
// import 'package:odontobb/models/favorite_model.dart';
import 'package:odontobb/constant.dart';
import 'package:odontobb/models/favorite_model.dart';
import 'package:odontobb/models/video_model.dart';
import 'package:odontobb/services/favorites_service.dart';
// import 'package:odontobb/util.dart';
// import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../util.dart';
import 'custom_elements/normal_text.dart';

class WebViewWidget extends StatefulWidget {
  static const routeName = "/webview";

  final VideoModel videoModel;

  const WebViewWidget({super.key, required this.videoModel});

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  final FavoritesService _favoritesService = FavoritesService();

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );
    // ..onInit = () {
    //   _controller.loadVideoById(videoId: widget.videoModel.url);
    // }
    // ..onFullscreenChange = (isFullScreen) {
    //   //redirect to full scream
    // };
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    // _controllerYoutube.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // _controllerYoutube.dispose();
    super.dispose();
  }

  void listener() {
    // if (_isPlayerReady && mounted && !_controllerYoutube.value.isFullScreen) {
    //   setState(() {
    //     _playerState = _controllerYoutube.value.playerState;
    //     _videoMetaData = _controllerYoutube.metadata;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
              title: NormalText(
            text: widget.videoModel.title,
            textSize: kPriceFontSize,
            fontWeight: FontWeight.w600,
          )),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 750) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        player,
                        const VideoPositionIndicator(),
                      ],
                    )
                  ],
                );
              }

              return ListView(
                children: [
                  widget.videoModel.url.isNotEmpty == true
                      ? player
                      : Container(),
                  const VideoPositionIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: NormalText(
                      text: widget.videoModel.info,
                      textSize: kNormalFontSize,
                      fontWeight: FontWeight.w400,
                      textOverflow: TextOverflow.visible,
                      textColor: Utils.getColorMode(),
                    ),
                  ),
                  Image.asset(
                    "assets/images/App_Educar.png",
                    fit: BoxFit.contain,
                    height: Utils.size(context).height * 0.35,
                    width: Utils.size(context).width,
                  ),
                ],
              );
            },
          ),
          floatingActionButton: favoriteButton(widget.videoModel.url),
        );
      },
    );
  }

  Widget favoriteButton(String url) {
    return FloatingActionButton(
      onPressed: () async {
        FavoriteModel favoriteModel = FavoriteModel();
        favoriteModel.url = url;
        favoriteModel.userId = Utils.globalFirebaseUser!.uid;

        _favoritesService.save(favoriteModel).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Utils.translate('add_favorited'))),
          );
        });
      },
      backgroundColor: kButtonColor,
      child: const Icon(Icons.favorite),
    );
  }
}

///
class VideoPositionIndicator extends StatelessWidget {
  ///
  const VideoPositionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return StreamBuilder<Duration>(
      stream: controller.getCurrentPositionStream(),
      initialData: Duration.zero,
      builder: (context, snapshot) {
        final position = snapshot.data?.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}
