import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/Trip/controllers/trip_controller.dart';

class TripView extends StatelessWidget {
  final TripController controller = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Trip', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.tripNameController,
              decoration: InputDecoration(
                labelText: 'Nama Trip',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                controller.completeTrip();
                // Kembali ke PlanView
                Get.back(); // atau gunakan Get.off(() => PlanView()) jika ingin menghapus halaman ini dari stack
              },
              child: Text('Selesai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}