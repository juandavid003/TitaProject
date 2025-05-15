// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constant.dart';
import '../util.dart';

// ignore: must_be_immutable
class ShimmerWidget extends StatefulWidget {
  Widget child;

  ShimmerWidget({super.key, required this.child});

  @override
  _ShimmerWidgetState createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          Utils.isDarkMode ? kDarkBLackBgColor : Colors.grey.withOpacity(0.7),
      highlightColor:
          Utils.isDarkMode ? kDarkItemColor : Colors.grey.withOpacity(0.4),
      child: widget.child,
    );
  }
}
