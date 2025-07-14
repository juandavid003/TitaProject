import 'package:flutter/material.dart';

final navigatorPlus = NavigatorPlus._instance;

class NavigatorPlus {
  static final _instance = NavigatorPlus._();
  NavigatorPlus._();

  GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  GlobalKey<NavigatorState>? get _getNavigatorKey {
    return _navigatorKey;
  }

  GlobalKey<NavigatorState> get key {
    return _navigatorKey;
  }

  GlobalKey<NavigatorState> addKey(GlobalKey<NavigatorState> newKey) {
    _navigatorKey = newKey;
    return _navigatorKey;
  }

  BuildContext? get currentContext =>
      _getNavigatorKey?.currentState?.overlay?.context;

  /// Navigate to a specific Widget
  Future<dynamic>? show(
    Widget destination, {
    bool? replace,
    bool? maintainState,
    RouteSettings? settings,
  }) {
    FocusManager.instance.primaryFocus!.unfocus();
    if (replace != null && replace == true) {
      return _getNavigatorKey?.currentState?.pushReplacement(
        MaterialPageRoute(
            builder: (context) => destination,
            fullscreenDialog: false,
            maintainState: maintainState ?? true,
            settings: settings),
      );
    } else {
      return _getNavigatorKey?.currentState?.push(
        MaterialPageRoute(
            builder: (context) => destination,
            fullscreenDialog: false,
            maintainState: maintainState ?? true,
            settings: settings),
      );
    }
  }

  Future<dynamic>? pushAndRemoveUntil(
    Widget destination, {
    required bool replace,
    required bool maintainState,
    required RouteSettings settings,
  }) {
    FocusManager.instance.primaryFocus!.unfocus();
    return _getNavigatorKey?.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => destination,
          fullscreenDialog: false,
          maintainState: maintainState,
          settings: settings),
      ModalRoute.withName('/'),
    );
  }

  /// Navigate to a modal specific Widget
  Future<dynamic>? showModal(
    Widget destination, {
    bool? replace,
    bool maintainState = true,
    RouteSettings? settings,
  }) {
    FocusManager.instance.primaryFocus!.unfocus();
    if (replace != null && replace == true) {
      return _getNavigatorKey?.currentState?.pushReplacement(
        MaterialPageRoute(
            builder: (context) => destination,
            fullscreenDialog: true,
            maintainState: maintainState,
            settings: settings),
      );
    } else {
      return _getNavigatorKey?.currentState?.push(
        MaterialPageRoute(
            builder: (context) => destination,
            fullscreenDialog: true,
            maintainState: maintainState,
            settings: settings),
      );
    }
  }

  /// Check if you can return
  bool get canBack {
    if (_getNavigatorKey == null || _getNavigatorKey!.currentState == null) {
      return false;
    } else {
      return _getNavigatorKey!.currentState!.canPop();
    }
  }

  /// Back to previous Widget
  void back({dynamic result}) {
    FocusManager.instance.primaryFocus!.unfocus();
    if (canBack) _getNavigatorKey!.currentState!.pop(result);
  }

  /// Back to first stack widget
  void backAll() {
    FocusManager.instance.primaryFocus!.unfocus();
    if (canBack) {
      _getNavigatorKey!.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
