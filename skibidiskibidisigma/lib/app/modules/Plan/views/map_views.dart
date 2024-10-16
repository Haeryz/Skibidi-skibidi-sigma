import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maplibre_gl/maplibre_gl.dart'; // Import Maplibre
import 'package:geolocator/geolocator.dart';  // Import geolocator

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

      suggestions.value = data;

      if (data.isNotEmpty) {
        // Optionally remove the automatic selection logic
      } else {
        Get.snackbar("No results", "No locations found for your query.");
      }
    } else {
      Get.snackbar("Error", "Failed to fetch locations. Status code: ${response.statusCode}");
    }
  }

  Future<void> _fetchAddressFromCoordinates(double lat, double lon) async {
    final String apiKey = dotenv.env['LOCATIONIQ_API_KEY'] ?? '';

    final Uri url = Uri.parse("https://us1.locationiq.com/v1/reverse").replace(queryParameters: {
      'key': apiKey,
      'lat': lat.toString(),
      'lon': lon.toString(),
      'format': 'json',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String displayName = data['display_name'] ?? 'Unknown location';
      Get.snackbar('Reverse Geocode', 'Location: $displayName');
    } else {
      Get.snackbar("Error", "Failed to fetch address. Status code: ${response.statusCode}");
    }
  }

  // New method to get current GPS location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permissions are permanently denied, we cannot request permissions.");
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _fetchAddressFromCoordinates(position.latitude, position.longitude);
  }

  void _onQueryChanged(String query) {
    if (query.isEmpty) {
      suggestions.clear(); // Clear suggestions if the query is empty
    } else {
      _fetchLocation(query); // Fetch suggestions regardless of query length
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation, // Fetch current location when button pressed
          ),
        ],
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

                          // Fetch address from coordinates after location selection
                          _fetchAddressFromCoordinates(lat, lon);
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
