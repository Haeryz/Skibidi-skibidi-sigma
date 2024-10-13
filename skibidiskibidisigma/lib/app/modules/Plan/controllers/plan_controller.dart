import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Trip {
  final String name;
  final String startLocation;
  final String destination;
  final DateTime departureDate;
  final DateTime returnDate;
  final String vehicle;

  Trip({
    required this.name,
    required this.startLocation,
    required this.destination,
    required this.departureDate,
    required this.returnDate,
    required this.vehicle,
  });
}

class PlanController extends GetxController {
  var selectedTab = 0.obs;

  // Dropdown options
  final List<String> vehicle = [
    'Motor', 'Mobil', 'Bus', 'Kereta api', 'Kapal', 'Pesawat'
  ];
  
  // Selected vehicle and dates
  var selectedVehicle = ''.obs;
  var selectedDepartureDate = DateTime.now().obs;
  var selectedReturnDate = DateTime.now().obs;
  
  // Start and destination locations
  var startLocation = ''.obs;
  var destination = ''.obs;

  // List of trips
  var trips = <Trip>[].obs;
  var isEditing = false.obs;
  var editingTripIndex = (-1).obs;

  // Select a tab
  void selectTab(int index) {
    selectedTab.value = index;
  }

  // Add or update a trip
  void addTrip(Trip trip) {
    if (isEditing.value && editingTripIndex.value >= 0) {
      // Update the existing trip
      trips[editingTripIndex.value] = trip;
      isEditing.value = false;
      editingTripIndex.value = -1;
    } else {
      // Add new trip
      trips.add(trip);
    }
  }

  // Edit a trip
  void editTrip(int index) {
    final trip = trips[index];
    selectedVehicle.value = trip.vehicle;
    selectedDepartureDate.value = trip.departureDate;
    selectedReturnDate.value = trip.returnDate;
    startLocation.value = trip.startLocation;
    destination.value = trip.destination;
    isEditing.value = true;
    editingTripIndex.value = index;
  }

  // Reset form
  void resetForm() {
    selectedVehicle.value = '';
    selectedDepartureDate.value = DateTime.now();
    selectedReturnDate.value = DateTime.now();
    startLocation.value = '';
    destination.value = '';
    isEditing.value = false;
    editingTripIndex.value = -1;
  }

  // Select a date
  Future<void> selectDate(BuildContext context, Rx<DateTime> selectedDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2069),
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }

  // Set selected vehicle
  void setSelectedVehicle(String value) {
    selectedVehicle.value = value;
  }

  // Set start location
  void setStartLocation(String location) {
    startLocation.value = location;
  }

  // Set destination
  void setDestination(String location) {
    destination.value = location;
  }

  // Delete a trip
  void deleteTrip(int index) {
    trips.removeAt(index);
  }
}
