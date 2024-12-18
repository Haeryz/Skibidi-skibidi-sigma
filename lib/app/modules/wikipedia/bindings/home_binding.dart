import 'package:get/get.dart';

import '../controllers/wikipedia_controller.dart';

class wikipediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WikipediaController>(
      () => WikipediaController(),
    );
  }
}
