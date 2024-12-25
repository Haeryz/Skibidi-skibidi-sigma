import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/wikipedia/controllers/wikipedia_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WikipediaView extends GetView<WikipediaController> {
  const WikipediaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WikipediaView'),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: controller.webViewCtrl),
    );
  }
}
