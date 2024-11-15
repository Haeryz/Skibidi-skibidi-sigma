import 'package:get/get.dart';

class ReviewController extends GetxController {
  // Reactive variable for selected stars
  final RxInt selectedStars = 0.obs;

  // Method to update the selected stars
  void updateStars(int stars) {
    selectedStars.value = stars;
  }
}
