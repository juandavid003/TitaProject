import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewConfig {
  /// Configura el controlador de WebView con opciones seguras para iOS
  static WebViewController configureWebViewController({
    required String initialUrl,
    JavaScriptMode javaScriptMode = JavaScriptMode.unrestricted,
    bool allowsInlineMediaPlayback = true,
  }) {
    // Crear la configuración específica para iOS (WKWebView)
    late final PlatformWebViewControllerCreationParams params;

    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: allowsInlineMediaPlayback,
      mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    );

    // Crear el controlador con la configuración específica de la plataforma
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    // Configurar el controlador
    controller
      ..setJavaScriptMode(javaScriptMode)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(Uri.parse(initialUrl));

    // Configurar el manejo de navegación
    controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          // Permitir todas las navegaciones
          return NavigationDecision.navigate;
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('WebView error: ${error.description}');
        },
      ),
    );

    return controller;
  }
}
