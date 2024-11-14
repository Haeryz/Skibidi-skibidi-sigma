import 'package:get/get.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs; // Observable integer for selected index

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
