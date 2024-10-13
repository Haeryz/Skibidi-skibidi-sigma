import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapSelectionView extends StatelessWidget {
  final Function(String) onLocationSelected;
  final TextEditingController _controller = TextEditingController();

  MapSelectionView({required this.onLocationSelected});

  Future<void> _fetchLocation(String query) async {
    final String apiKey = dotenv.env['LOCATIONIQ_API_KEY'] ?? ''; // Load the API key from .env
    final String url = 'https://us1.locationiq.com/v1/search.php?key=$apiKey&q=$query&format=json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Print the JSON response for debugging
        print("Response body: ${response.body}");

        List<dynamic> locations = json.decode(response.body);
        if (locations.isNotEmpty) {
          String selectedLocation = locations[0]['display_name']; // Get the location name
          onLocationSelected(selectedLocation);
          Get.back(); // Return to the previous screen
        } else {
          Get.snackbar('Error', 'No locations found');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch location');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Masukkan Lokasi',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _fetchLocation(_controller.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Optionally, you could trigger location fetch here as well
                // _fetchLocation(_controller.text);
              },
              child: const Text('Select Location'),
            ),
          ],
        ),
      ),
    );
  }
}
