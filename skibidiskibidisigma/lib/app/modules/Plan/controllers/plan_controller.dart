import 'package:get/get.dart';

class PlanController extends GetxController {
  //TODO: Implement HomeController

  var selectedTab = 0.obs;

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void createTrip() {
    // Logic to create a trip
    print("Trip created");
    // Add more logic as needed for trip creation
  }

  void onNavBarItemTapped(int index) {
    // Handle navigation logic here
    print("Tapped on tab: $index");
    // Implement actual navigation here, e.g., switching views
  }
}
