import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maplibre_gl/maplibre_gl.dart'; // Import Maplibre

class MapSelectionView extends StatelessWidget {
  final Function(String, double, double) onLocationSelected;
  final TextEditingController _controller = TextEditingController();
  final RxList<dynamic> suggestions = <dynamic>[].obs;

  MapSelectionView({super.key, required this.onLocationSelected});

  Future<void> _fetchLocation(String query) async {
    final String apiKey = dotenv.env['LOCATIONIQ_API_KEY'] ?? '';

    final Uri url = Uri.parse("https://api.locationiq.com/v1/autocomplete")
        .replace(queryParameters: {
      'key': apiKey,
      'q': query,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      print("Response JSON: ${json.encode(data)}");

      suggestions.value = data;

      if (data.isNotEmpty) {
        String location = data[0]['display_name'];
        double lat = double.parse(data[0]['lat']);
        double lon = double.parse(data[0]['lon']);
        onLocationSelected(location, lat, lon);
      } else {
        Get.snackbar("No results", "No locations found for your query.");
      }
    } else {
      Get.snackbar("Error", "Failed to fetch locations. Status code: ${response.statusCode}");
    }
  }

  void _onQueryChanged(String query) {
    if (query.length >= 3) {
      _fetchLocation(query);
    } else {
      suggestions.clear();
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
                    _onQueryChanged(_controller.text);
                  },
                ),
              ),
              onChanged: _onQueryChanged,
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return ListTile(
                        title: Text(suggestion['display_name']),
                        onTap: () {
                          double lat = double.parse(suggestion['lat']);
                          double lon = double.parse(suggestion['lon']);
                          onLocationSelected(suggestion['display_name'], lat, lon);
                          _controller.clear();
                          suggestions.clear();
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

class MapView extends StatelessWidget {
  final double latitude;
  final double longitude;

  MapView({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final String apiKey = dotenv.env['MAPTILER_API_KEY'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: MaplibreMap(
        styleString: "https://api.maptiler.com/maps/streets/style.json?key=$apiKey",
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.0,
        ),
        onMapCreated: (MaplibreMapController controller) {
          controller.addSymbol(SymbolOptions(
            geometry: LatLng(latitude, longitude),
            iconImage: "marker-15",
          ));
        },
      ),
    );
  }
}