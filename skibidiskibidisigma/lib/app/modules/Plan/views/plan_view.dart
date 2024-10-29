import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skibidiskibidisigma/app/modules/Plan/views/map_views.dart';
import 'package:skibidiskibidisigma/app/modules/Template/views/home_view.dart';
import 'package:skibidiskibidisigma/app/modules/Trip/views/trip_view.dart';
import '../controllers/plan_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'dart:convert';

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
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            child: Obx(() {
              if (controller.trips.isEmpty) {
                return const Center(
                  child: Text('Belum ada trip yang dibuat'),
                );
              }

              return ListView.builder(
                itemCount: controller.trips.length,
                itemBuilder: (context, index) {
                  final trip = controller.trips[index];
                  return ListTile(
                    title: Text(trip.name),
                    subtitle: Text(
                      '${trip.startLocation} → ${trip.destination}\n'
                      'Berangkat: ${DateFormat('dd/MM/yyyy').format(trip.departureDate)}\n'
                      'Pulang: ${DateFormat('dd/MM/yyyy').format(trip.returnDate)}\n'
                      'Kendaraan: ${trip.vehicle}',
                    ),
                    isThreeLine: true,
                    leading: const Icon(Icons.directions),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            controller.editTrip(index);
                            Get.bottomSheet(
                              BuatTripForm(),
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              isScrollControlled: true,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            controller.deleteTrip(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => TripView());
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class BuatTripForm extends StatelessWidget {
  final TextEditingController tripNameController = TextEditingController();
  final PlanController planController = Get.put(PlanController());
  final String? locationIQKey = dotenv.env['LOCATIONIQ_API_KEY'];
  final RxString startLocation = ''.obs;
  final RxDouble startLatitude = 0.0.obs;
  final RxDouble startLongitude = 0.0.obs;
  final RxString destinationLocation = ''.obs;
  final RxDouble destinationLatitude = 0.0.obs;
  final RxDouble destinationLongitude = 0.0.obs;

  BuatTripForm({super.key}) {
    if (planController.isEditing.value &&
        planController.editingTripIndex.value >= 0) {
      final trip = planController.trips[planController.editingTripIndex.value];
      tripNameController.text = trip.name;
      startLocation.value = trip.startLocation; // Initialize with trip data
      planController.setStartLocation(trip.startLocation);
      planController.setDestination(trip.destination);
    } else {
      tripNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
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
              const Text('Lokasi awal'),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to MapSelectionView and wait for the result
                    final result = await Get.to<MapSelectionView>(
                      () => MapSelectionView(
                        onLocationSelected: (location, lat, lon) {
                          startLocation.value = location;
                          startLatitude.value = lat;
                          startLongitude.value = lon;
                          // Navigate to MapView when a location is selected
                          Get.to<MapView>(
                            () => MapView(latitude: lat, longitude: lon),
                          );
                        },
                      ),
                    );

                    // Optional: Do something with the result if needed
                    // e.g., show a snackbar, update state, etc.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add_location_alt,
                        color: Colors.black,
                      ),
                      SizedBox(
                          width:
                              8), // Add some spacing between the icon and the text
                      Text('Select Location',
                          style:
                              TextStyle(color: Colors.black)), // Optional text
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Skibidi'),
              const SizedBox(height: 10),
              // lokasi1
              Obx(() => startLocation.isNotEmpty
                  ? Text(
                      'Selected Location: ${startLocation.value} \nLat: ${startLatitude.value}, Lon: ${startLongitude.value}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text('No location selected.')),
              const SizedBox(height: 20),
              const Text('Skibidi'),
              const SizedBox(height: 10),
              // lokasi2
              Obx(() => startLocation.isNotEmpty
                  ? Text(
                      'Selected Location: ${startLocation.value} \nLat: ${startLatitude.value}, Lon: ${startLongitude.value}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text('No location selected.')),
              const SizedBox(height: 20),
              const Text('Skibidi'),
              const SizedBox(height: 10),
              SizedBox(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'skibidi',
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Lokasi tujuan'),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to MapSelectionView and wait for the result
                    final result = await Get.to<MapSelectionView>(
                      () => MapSelectionView(
                        onLocationSelected: (location, lat, lon) {
                          // Navigate to MapView when a location is selected
                          Get.to<MapView>(
                            () => MapView(latitude: lat, longitude: lon),
                          );
                        },
                      ),
                    );

                    // Optional: Do something with the result if needed
                    // e.g., show a snackbar, update state, etc.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add_location_alt,
                        color: Colors.black,
                      ),
                      SizedBox(
                          width:
                              8), // Add some spacing between the icon and the text
                      Text('Select Location',
                          style:
                              TextStyle(color: Colors.black)), // Optional text
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Pilih Kendaraan'),
              const SizedBox(height: 10),
              Obx(
                () => DropdownButton<String>(
                  isExpanded: true,
                  value: planController.selectedVehicle.value.isNotEmpty
                      ? planController.selectedVehicle.value
                      : null,
                  hint: const Text('Pilih Kendaraan'),
                  items: planController.vehicle.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    planController.setSelectedVehicle(newValue!);
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text('Tanggal Berangkat'),
              const SizedBox(height: 10),
              Obx(
                () => GestureDetector(
                  onTap: () => planController.selectDate(
                      context, planController.selectedDepartureDate),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: DateFormat('dd/MM/yyyy')
                            .format(planController.selectedDepartureDate.value),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Tanggal Pulang'),
              const SizedBox(height: 10),
              Obx(
                () => GestureDetector(
                  onTap: () => planController.selectDate(
                      context, planController.selectedReturnDate),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: DateFormat('dd/MM/yyyy')
                            .format(planController.selectedReturnDate.value),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String tripName = tripNameController.text;
                    if (tripName.isNotEmpty) {
                      final trip = Trip(
                        name: tripName,
                        startLocation: planController.startLocation.value,
                        destination: planController.destination.value,
                        departureDate:
                            planController.selectedDepartureDate.value,
                        returnDate: planController.selectedReturnDate.value,
                        vehicle: planController.selectedVehicle.value,
                      );

                      planController.addTrip(trip);
                      planController.resetForm(); // Reset form after saving
                      Get.back();
                    } else {
                      Get.snackbar('Error', 'Nama trip tidak boleh kosong',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Obx(() => Text(
                        planController.isEditing.value
                            ? 'Update Trip'
                            : 'Buat Trip',
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
