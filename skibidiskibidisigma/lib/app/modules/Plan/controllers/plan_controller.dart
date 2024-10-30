import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PlanController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();

  var isLoading = false.obs;
  var date = DateTime.now().add(Duration(days: 1)).obs;

  Future<void> fetchTasks() async {
    // Add logic here to fetch tasks if necessary
    update(); // Notify listeners about changes
  }

  void initForm(
      {bool isEdit = false, String? name, String? description, String? date}) {
    if (isEdit && name != null && description != null && date != null) {
      this.date.value = DateFormat('dd MMMM yyyy').parse(date);
      controllerName.text = name;
      controllerDescription.text = description;
      controllerDate.text = date;
    } else {
      controllerDate.text = DateFormat('dd MMMM yyyy').format(this.date.value);
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

    if (name.isEmpty) {
      _showSnackBarMessage('Name is required');
      return;
    } else if (description.isEmpty) {
      _showSnackBarMessage('Description is required');
      return;
    }

    isLoading.value = true;

    try {
      if (isEdit && documentId != null) {
        DocumentReference documentTask = firestore.doc('tasks/$documentId');
        await documentTask.update({
          'name': name,
          'description': description,
          'date': taskDate,
        });
      } else {
        await firestore.collection('tasks').add({
          'name': name,
          'description': description,
          'date': taskDate,
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
