import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  final tripNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void completeTrip() async {
    String tripName = tripNameController.text.trim();
    if (tripName.isEmpty) {
      Get.snackbar(
        'Error', 
        'Nama trip tidak boleh kosong', 
        snackPosition: SnackPosition.BOTTOM
      );
      return;
    }

    // Check if trip with same name already exists
    bool exists = await checkTripExists(tripName);
    if (exists) {
      Get.snackbar(
        'Error', 
        'Trip dengan nama tersebut sudah ada', 
        snackPosition: SnackPosition.BOTTOM
      );
      return;
    }

    await addTripToFirestore(tripName);
    tripNameController.clear();
  }

  Future<bool> checkTripExists(String tripName) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('trips')
          .where('name', isEqualTo: tripName)
          .get();
      
      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error checking trip existence: $e');
      return false;
    }
  }

  Future<void> addTripToFirestore(String tripName) async {
    try {
      final tripData = {
        'name': tripName,
        'createdAt': FieldValue.serverTimestamp(),  // Tambahkan timestamp
      };
      
      await _firestore.collection('trips').add(tripData);
      Get.snackbar(
        'Success', 
        'Trip berhasil ditambahkan', 
        snackPosition: SnackPosition.BOTTOM
      );
      Get.back(); // Navigate back to PlanView
    } catch (e) {
      print('Error adding trip to Firestore: $e');
      Get.snackbar(
        'Error', 
        'Gagal menyimpan trip: $e', 
        snackPosition: SnackPosition.BOTTOM
      );
    }
  }
}