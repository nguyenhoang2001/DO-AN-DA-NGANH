import 'dart:io';
import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  // TODO: WebViewScreen MaterialPage Helper
  static MaterialPage page() {
    return MaterialPage(
        name: ThermometerPage.hcmut,
        key: ValueKey(ThermometerPage.hcmut),
        child: const WebViewScreen());
  }

  const WebViewScreen({Key? key}) : super(key: key);

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('oisp.hcmut.edu.vn'),
      ),
      body: const WebView(
        initialUrl: 'https://oisp.hcmut.edu.vn/',
      ),
    );
  }
}
