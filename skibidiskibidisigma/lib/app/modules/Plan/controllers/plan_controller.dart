import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanController extends GetxController {
  //TODO: Implement HomeController

  var selectedTab = 0.obs;

  final List<String> vehicle= ['Motor', 'Mobil', 'Bus', 'Kereta api', 'Kapal', 'Pesawat'];
  var selectedVehicle = ''.obs;

  var selectedDepartureDate = DateTime.now().obs; 
  var selectedReturnDate = DateTime.now().obs; 

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

  void setSelectedVehicle(String value){
    selectedVehicle.value = value;
  }

  Future<void> selectDate(BuildContext context, Rx<DateTime>selectedDate ) async{
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2069),
      );

    if(pickedDate != null && pickedDate != selectedDate.value){
      selectedDate.value = pickedDate;
    }
  }
}
