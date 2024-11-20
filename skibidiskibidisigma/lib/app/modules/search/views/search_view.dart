import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/navbar/views/navbar_view.dart';
import '../controllers/search_controller.dart' as local;

class SearchView extends GetView<local.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return TextField(
                decoration: InputDecoration(
                  hintText: controller.searchQuery.isEmpty
                      ? 'Jalan ke mana?'
                      : controller.searchQuery.value,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(controller.speechToText.isListening
                        ? Icons.mic_off
                        : Icons.mic),
                    onPressed: () async {
                      if (controller.speechToText.isListening) {
                        print("User clicked stop listening.");
                        controller.stopListening();
                      } else {
                        print("User clicked start listening.");
                        await controller.startListening();
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              return Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Cari tempat yang menarik dekat Anda',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              controller.toggleLocation();
                              print("User toggled location.");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              controller.isLocationActive.value
                                  ? 'Lokasi Aktif'
                                  : 'Aktifkan Lokasi',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.isLocationActive.value)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Lokasi Anda sudah aktif.',
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                  ],
                ),
              );
            })
          ],
        ),
      ),
      bottomNavigationBar: NavbarView(),
    );
  }
}
