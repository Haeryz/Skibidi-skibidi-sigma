import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';

import '../controllers/plan_controller.dart';

class PlanView extends GetView<PlanController> {
  const PlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final PlanController controller = Get.put(PlanController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
       title: const Text(
    'Rencanakan',
        style: TextStyle(
          fontWeight: FontWeight.bold, // Make the text bold
          color: Colors.black, // Optional: Change the text color if needed
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // White background
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          // Handle tab change
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Rencana',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Ulasan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => controller.selectTab(0),
                  child: Obx(() => Column(
                    children: [
                      Text(
                        "Trip",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: controller.selectedTab.value == 0
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      if (controller.selectedTab.value == 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 2,
                          width: 30,
                          color: Colors.black,
                        )
                    ],
                  )),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => controller.selectTab(1),
                  child: Obx(() => Column(
                    children: [
                      Text(
                        "Simpanan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: controller.selectedTab.value == 1
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      if (controller.selectedTab.value == 1)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 2,
                          width: 30,
                          color: Colors.black,
                        )
                    ],
                  )),
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 48,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 10),
                  const Text('Simpan Tempat yang ingin dikunjungi'),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.bottomSheet(
                        BuatTripForm(), // Show the bottom sheet with the form
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        isScrollControlled: true,
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Buat Trip',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuatTripForm extends StatelessWidget {
  final TextEditingController tripNameController = TextEditingController();

  BuatTripForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Buat Trip',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Nama Trip'),
          const SizedBox(height: 10),
          TextField(
            controller: tripNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Masukkan nama trip',
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                String tripName = tripNameController.text;
                if (tripName.isNotEmpty) {
                  // Do something with the trip name, e.g., create the trip
                  Get.back(); // Close the bottom sheet
                } else {
                  // Show a snackbar or error if the name is empty
                  Get.snackbar('Error', 'Nama trip tidak boleh kosong',
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Button background color
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Buat Trip',
                style: TextStyle(color: Colors.white), // Ensures the text is white
              ),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
                Get.toNamed(Routes.AUTHENTICATION);
              }, child: const Text(
                'test'
              )
              ),
          )
        ],
      ),
    );
  }
}