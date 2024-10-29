import 'package:get/get.dart';

import '../controllers/akun_controller.dart';

class akunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<akunController>(
      () => akunController(),
    );
  }
}
