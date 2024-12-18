import 'package:get/get.dart';

import '../controllers/akun_controller.dart';

// ignore: camel_case_types
class akunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<akunController>(
      () => akunController(),
    );
  }
}
