import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapSelectionView extends StatelessWidget {
  final Function(String) onLocationSelected;
  final TextEditingController _controller = TextEditingController();
  final RxList<dynamic> suggestions = <dynamic>[].obs; // Observable list to hold suggestions

  MapSelectionView({super.key, required this.onLocationSelected});

  Future<void> _fetchLocation(String query) async {
    final String apiKey = dotenv.env['LOCATIONIQ_API_KEY'] ?? ''; // Load the API key from .env

    // Create the Uri with query parameters
    final Uri url = Uri.parse("https://api.locationiq.com/v1/autocomplete")
        .replace(queryParameters: {
      'key': apiKey,
      'q': query,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the response
      List<dynamic> data = json.decode(response.body);

      // Print the JSON output to the console
      print("Response JSON: ${json.encode(data)}"); // Print the entire JSON response

      // Update suggestions list
      suggestions.value = data; // Update the observable list with new data

      // Handle the response (you can show a list of suggestions or something else)
      if (data.isNotEmpty) {
        // Extract location details and pass it to the onLocationSelected callback
        String location = data[0]['display_name'];
        onLocationSelected(location);
      } else {
        // Handle the case when no location is found
        Get.snackbar("No results", "No locations found for your query.");
      }
    } else {
      // Handle error
      Get.snackbar("Error", "Failed to fetch locations. Status code: ${response.statusCode}");
    }
  }

  void _onQueryChanged(String query) {
    // Only trigger the search if the query has 3 or more characters
    if (query.length >= 3) {
      _fetchLocation(query);
    } else {
      suggestions.clear(); // Clear suggestions if less than 3 characters
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search for a location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _onQueryChanged(_controller.text); // Call when the search button is pressed
                  },
                ),
              ),
              onChanged: _onQueryChanged, // Trigger search as user types
            ),
            SizedBox(height: 10),
            // Display suggestions in a ListView
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return ListTile(
                        title: Text(suggestion['display_name']),
                        onTap: () {
                          // Call onLocationSelected when a suggestion is tapped
                          onLocationSelected(suggestion['display_name']);
                          _controller.clear(); // Clear the text field
                          suggestions.clear(); // Clear suggestions after selection
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
