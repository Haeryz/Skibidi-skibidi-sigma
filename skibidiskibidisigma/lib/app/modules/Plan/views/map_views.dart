import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maplibre_gl/maplibre_gl.dart'; // Import Maplibre
import 'package:geolocator/geolocator.dart';
import 'package:skibidiskibidisigma/app/modules/Plan/views/plan_view.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';  // Import geolocator

class MapSelectionView extends StatelessWidget {
  final Function(String, double, double) onLocationSelected;
  final TextEditingController _controller = TextEditingController();
  final RxList<dynamic> suggestions = <dynamic>[].obs;
  final RxString selectedLocationName = ''.obs;
  final RxDouble selectedLatitude = 0.0.obs;
  final RxDouble selectedLongitude = 0.0.obs;

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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      return;
    }

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

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _fetchAddressFromCoordinates(position.latitude, position.longitude);

    selectedLatitude.value = position.latitude;
    selectedLongitude.value = position.longitude;
    selectedLocationName.value = 'Selected via GPS';
  }

  void _onQueryChanged(String query) {
    if (query.isEmpty) {
      suggestions.clear();
    } else {
      _fetchLocation(query);
    }
  }

  void _onLocationSelected(String displayName, double lat, double lon) {
    selectedLocationName.value = displayName;
    selectedLatitude.value = lat;
    selectedLongitude.value = lon;
    suggestions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
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
            const SizedBox(height: 10),
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
                          _onLocationSelected(suggestion['display_name'], lat, lon);
                          _controller.clear();
                        },
                      );
                    },
                  )),
            ),
            Obx(() => Text(
              selectedLocationName.isNotEmpty ? 'Selected Location: ${selectedLocationName.value}' : 'No location selected.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
              onPressed: selectedLocationName.isNotEmpty
                  ? () {
                      onLocationSelected(
                        selectedLocationName.value,
                        selectedLatitude.value,
                        selectedLongitude.value,
                      );
                      Get.to<BuatTripForm>(
                            () => BuatTripForm(),
                      ); // Go back after confirming location
                    }
                  : null, // Disable button if no location is selected
              child: const Text('Confirm Location'),
            )),
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
