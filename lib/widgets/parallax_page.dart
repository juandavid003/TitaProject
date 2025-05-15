// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'dart:io';
import 'package:odontobb/helpers/showPicker.dart';
import 'package:flutter/material.dart';
import 'package:odontobb/util.dart';

class ParallaxPage extends StatefulWidget {
  final ImageProvider? image;
  final Widget? child;
  final double? height;

  ParallaxPage({super.key, this.image, this.height, this.child});

  @override
  _ParallaxImageState createState() => _ParallaxImageState();
}

class _ParallaxImageState extends State<ParallaxPage> {
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double avatarHeight = 0;

  _scrollListener() {
    setState(() {
      if (_scrollController.position.pixels.abs() < 10) {
        avatarHeight = _scrollController.position.pixels;
      }
      if (_scrollController.position.pixels.abs() < 150) {
        _scrollPosition = _scrollController.position.pixels;
      }
    });
  }

  late File _image;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: (Utils.size(context).height * 0.25 - _scrollPosition).abs(),
            width: Utils.size(context).width,
            child: Stack(
              children: [
                Container(
                  height: Utils.size(context).height * 0.4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/main_bg_two.png"),
                      fit: BoxFit.fill,
                      alignment: AlignmentDirectional.topStart,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      showPicker(context, (val) {
                        setState(() {
                          _image = val;
                        });
                      });
                    },
                    child: CircleAvatar(
                        radius: (50 - avatarHeight),
                        backgroundColor: Colors.red,
                        // ignore: unnecessary_null_comparison
                        backgroundImage: FileImage(_image)
                        // _image == null
                        //     ? AssetImage("assets/images/user-default.png")
                        //     : FileImage(_image),
                        ),
                  ),
                ),
                Positioned(
                  left: Utils.size(context).width - 50,
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile_edit')
                          .then((value) {});
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
