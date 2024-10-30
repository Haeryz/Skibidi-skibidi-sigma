import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PlanController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();
  final TextEditingController controllerStartLocation = TextEditingController();
  final TextEditingController controllerDestination = TextEditingController();
  final TextEditingController controllerArrivalDate = TextEditingController();

  var isLoading = false.obs;
  var date = DateTime.now().add(Duration(days: 1)).obs;
  var arrivalDate = DateTime.now().add(Duration(days: 1)).obs;

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

    isLoading.value = true;

    try {
      if (isEdit && documentId != null) {
        DocumentReference documentTask = firestore.doc('trips/$documentId');
        await documentTask.update({
          'name': name,
          'description': description,
          'date': taskDate,
          'startLocation': startLocation,
          'destination': destination,
          'arrivalDate': arrivalDateText,
        });
      } else {
        await firestore.collection('trips').add({
          'name': name,
          'description': description,
          'date': taskDate,
          'startLocation': startLocation,
          'destination': destination,
          'arrivalDate': arrivalDateText,
        });
      }
      Get.back(result: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackBarMessage(String message) {
    Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
  }
}
