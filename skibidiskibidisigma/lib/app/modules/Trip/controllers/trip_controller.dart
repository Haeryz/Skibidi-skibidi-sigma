import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TripController extends GetxController {
  final tripNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    checkAndSyncOfflineTrips();
  }

  void completeTrip() async {
    String tripName = tripNameController.text.trim();
    if (tripName.isEmpty) {
      Get.snackbar(
        'Error', 
        'Nama trip tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Periksa autentikasi
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar(
        'Error', 
        'Anda harus login terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Cek koneksi internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      saveTripLocally(tripName);
    } else {
      await saveTripToFirestore(tripName);
    }

    tripNameController.clear();
  }

  void saveTripLocally(String tripName) {
    try {
      List<dynamic> offlineTrips = box.read('offlineTrips') ?? [];
      offlineTrips.add({
        'name': tripName,
        'userId': _auth.currentUser?.uid,
        'createdAt': DateTime.now().toIso8601String(),
      });
      box.write('offlineTrips', offlineTrips);

      Get.snackbar(
        'Offline', 
        'Trip disimpan secara lokal',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error saving trip locally: $e');
      Get.snackbar(
        'Error', 
        'Gagal menyimpan trip secara lokal',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveTripToFirestore(String tripName) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }

      // Tambahkan debugging print
      print('Attempting to save trip: $tripName for user: ${currentUser.uid}');

      DocumentReference docRef = await _firestore.collection('trips').add({
        'name': tripName,
        'userId': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Cetak ID dokumen yang baru dibuat
      print('Trip saved with ID: ${docRef.id}');

      Get.snackbar(
        'Success', 
        'Trip berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Cetak error yang sebenarnya
      print('Error saving trip to Firestore: $e');
      
      Get.snackbar(
        'Error', 
        'Gagal menyimpan trip: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> checkAndSyncOfflineTrips() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        List<dynamic> offlineTrips = box.read('offlineTrips') ?? [];
        if (offlineTrips.isNotEmpty) {
          for (var trip in offlineTrips) {
            // Hanya sinkronkan trip milik pengguna yang sedang login
            if (trip['userId'] == currentUser.uid) {
              await _firestore.collection('trips').add({
                'name': trip['name'],
                'userId': currentUser.uid,
                'createdAt': FieldValue.serverTimestamp(),
              });
            }
          }
          
          // Hapus data offline setelah sinkronisasi
          box.remove('offlineTrips');
          
          Get.snackbar(
            'Success', 
            'Trip offline berhasil disinkronkan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      print('Error syncing offline trips: $e');
      Get.snackbar(
        'Error', 
        'Gagal sinkronisasi trip offline',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}