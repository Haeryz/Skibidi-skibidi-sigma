import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs; // Observable integer for selected index

  void changeTabIndex(int index) {
    selectedIndex.value = index;

    // Use Get.toNamed() to prevent unnecessary page reloads
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOME, preventDuplicates: true);
        break;
      case 1:
        Get.toNamed(Routes.SEARCH, preventDuplicates: true);
        break;
      case 2:
        Get.toNamed(Routes.PLAN, preventDuplicates: true);
        break;
      case 3:
        Get.toNamed(Routes.REVIEW, preventDuplicates: true);
        break;
      case 4:
        Get.toNamed(Routes.AKUN, preventDuplicates: true);
        break;
    }
  }
}
