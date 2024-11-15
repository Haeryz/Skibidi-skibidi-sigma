import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs; // Observable integer for selected index

  void changeTabIndex(int index) {
    selectedIndex.value = index;

    // Add navigation logic here
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOME); // Navigate to HomeView
        break;
      case 1:
        Get.toNamed(Routes.SEARCH); // Navigate to SearchView
        break;
      case 2:
        Get.toNamed(Routes.PLAN); // Navigate to PlanView
        break;
      case 3:
        Get.toNamed(Routes.REVIEW); // Navigate to ReviewView
        break;
      case 4:
        Get.toNamed(Routes.AKUN); // Navigate to AccountView
        break;
    }
  }
}
