import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WikipediaController extends GetxController {
  //TODO: Implement HomeController
  late final WebViewController webViewCtrl;

  @override
  void onInit() {
    super.onInit();

    // Initialize the WebViewController from webview_flutter
    webViewCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.wikipedia.org/'));
  }
}
