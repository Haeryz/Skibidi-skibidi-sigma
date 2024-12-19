import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class PlanController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();
  final TextEditingController controllerStartLocation = TextEditingController();
  final TextEditingController controllerDestination = TextEditingController();
  final TextEditingController controllerArrivalDate = TextEditingController();

  var isLoading = false.obs;
  var date = DateTime.now().add(const Duration(days: 0)).obs;
  var arrivalDate = DateTime.now().add(const Duration(days: 1)).obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Assuming we care about any result that is not 'none'
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        _uploadLocalData();
      }
    });
  }

  Future<void> fetchTasks() async {
    // Add logic here to fetch tasks if necessary
    update(); // Notify listeners about changes
  }

  void initForm({
    bool isEdit = false,
    String? name,
    String? description,
    String? date,
    String? startLocation,
    String? destination,
    String? arrivalDate,
  }) {
    if (isEdit) {
      this.date.value = DateFormat('dd MMMM yyyy').parse(date ?? '');
      controllerName.text = name ?? '';
      controllerDescription.text = description ?? '';
      controllerDate.text = date ?? '';
      controllerStartLocation.text = startLocation ?? '';
      controllerDestination.text = destination ?? '';
      controllerArrivalDate.text = arrivalDate ?? '';
    } else {
      controllerDate.text = DateFormat('dd MMMM yyyy').format(this.date.value);
      controllerArrivalDate.text =
          DateFormat('dd MMMM yyyy').format(this.arrivalDate.value);
    }
  }

  void clearFormFields() {
    controllerName.clear();
    controllerDescription.clear();
    controllerDate.clear();
    controllerStartLocation.clear();
    controllerDestination.clear();
    controllerArrivalDate.clear();

    date.value = DateTime.now().add(const Duration(days: 1));
    arrivalDate.value = DateTime.now().add(const Duration(days: 1));
  }

  void selectArrivalDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime? pickedArrivalDate = await showDatePicker(
      context: context,
      initialDate: arrivalDate.value,
      firstDate: today,
      lastDate: DateTime(2101),
    );
    if (pickedArrivalDate != null) {
      arrivalDate.value = pickedArrivalDate;
      controllerArrivalDate.text =
          DateFormat('dd MMMM yyyy').format(arrivalDate.value);
    }
  }

  void selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: today,
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      date.value = pickedDate;
      controllerDate.text = DateFormat('dd MMMM yyyy').format(date.value);
    }
  }

  Future<void> saveTask(bool isEdit, String? documentId) async {
    String name = controllerName.text.trim();
    String description = controllerDescription.text.trim();
    String taskDate = controllerDate.text.trim();
    String startLocation = controllerStartLocation.text.trim();
    String destination = controllerDestination.text.trim();
    String arrivalDateText = controllerArrivalDate.text.trim();

    // Add validation for new fields here
    if (name.isEmpty ||
        startLocation.isEmpty ||
        destination.isEmpty ||
        arrivalDateText.isEmpty) {
      _showSnackBarMessage('All fields are required');
      return;
    }

    isLoading.value = true; // Start loading

    try {
      Map<String, dynamic> tripData = {
        'name': name,
        'description': description,
        'date': taskDate,
        'startLocation': startLocation,
        'destination': destination,
        'arrivalDate': arrivalDateText,
      };

      // Check connectivity and save accordingly
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        // Save data locally when offline
        _saveLocally(tripData);
        isLoading.value = false; // Set loading to false immediately if offline
        Get.snackbar("Offline", "Data saved locally. Will upload when online.");
      } else {
        // Save to Firestore when online
        if (isEdit && documentId != null) {
          DocumentReference documentTask = firestore.doc('trips/$documentId');
          await documentTask.update(tripData);
        } else {
          await firestore.collection('trips').add(tripData);
        }
        isLoading.value = false; // Set loading to false after saving
      }

      clearFormFields();
      Get.back(result: true);
    } catch (e) {
      isLoading.value = false; // Always set loading to false on error
      _showSnackBarMessage('An error occurred: $e');
    }
  }

  void _showSnackBarMessage(String message) {
    Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
  }

  void _saveLocally(Map<String, dynamic> tripData) {
    List<dynamic> trips = box.read('localTrips') ?? [];
    trips.add(tripData);
    box.write('localTrips', trips);
    Get.snackbar("Success", "Saved locally. Will upload when online.");
  }

  Future<void> _uploadLocalData() async {
    List<dynamic> localTrips = box.read('localTrips') ?? [];
    if (localTrips.isEmpty) return;

    for (var trip in localTrips) {
      await firestore.collection('trips').add(trip);
    }

    box.remove('localTrips');
    Get.snackbar("Success", "Local data uploaded to Firebase.");
  }

  void registerBackgroundNotification() {
    Workmanager().registerPeriodicTask(
      "tripArrivalNotificationTask",
      "tripArrivalNotificationTask",
      frequency: const Duration(hours: 24), // Runs daily
    );
  }

  Future<void> setStartLocationFromGPS() async {
    try {
      PermissionStatus permissionStatus =
          await Permission.locationWhenInUse.request();

      if (permissionStatus.isDenied) {
        _showSnackBarMessage(
            'Location permission is denied. Please enable it in settings');
        return;
      } else if (permissionStatus.isPermanentlyDenied) {
        _showSnackBarMessage(
            'Location permission is permanently denied. Please enable it in settings');
        await openAppSettings();
        return;
      }

      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        _showSnackBarMessage('Location services are disabled');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.best),
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      Uri googleMapsUri =
          Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBarMessage('Could not open Google Maps.');
        return;
      }

      controllerStartLocation.text = '$latitude, $longitude';
    } catch (e) {
      _showSnackBarMessage('An error occurred while fetching location: $e');
      print("$e");
    }
  }

  void checkTripArrivalNotifications() async {
    final currentDate = DateTime.now();
    final threeDaysFromNow = currentDate.add(const Duration(days: 3));

    final tripsSnapshot = await firestore.collection('trips').get();

    for (var doc in tripsSnapshot.docs) {
      final tripData = doc.data();
      final arrivalDateText = tripData['arrivalDate'];

      if (arrivalDateText != null) {
        final arrivalDate = DateFormat('dd MMMM yyyy').parse(arrivalDateText);

        if (arrivalDate.isBefore(threeDaysFromNow) &&
            arrivalDate.isAfter(currentDate)) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: doc.id.hashCode,
              channelKey: 'basic_channel',
              title: 'Upcoming Trip Reminder',
              body:
                  'Your trip to ${tripData['destination']} is in less than 3 days!',
              notificationLayout: NotificationLayout.BigText,
            ),
          );
        }
      }
    }
  }
}
