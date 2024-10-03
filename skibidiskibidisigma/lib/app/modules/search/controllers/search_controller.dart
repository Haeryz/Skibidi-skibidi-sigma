import 'package:get/get.dart';

class SearchController extends GetxController {
  var isLocationActive = false.obs;

  void toggleLocation() {
    isLocationActive.value = !isLocationActive.value;
  }
}
