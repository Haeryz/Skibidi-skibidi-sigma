import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart' as local;

class LocationAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final Widget? suffixIcon;

  const LocationAutocomplete({required this.controller, this.suffixIcon});

  @override
  _LocationAutocompleteState createState() => _LocationAutocompleteState();
}

class _LocationAutocompleteState extends State<LocationAutocomplete> {
  final local.SearchController _searchController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: 'Lokasi',
            suffixIcon: widget.suffixIcon,
          ),
          onChanged: (value) {
            _searchController.fetchLocationSuggestions(value);
          },
          style: const TextStyle(fontSize: 18.0),
        ),
        Obx(() {
          return _searchController.locationSuggestions.isNotEmpty
              ? SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _searchController.locationSuggestions.length,
                    itemBuilder: (context, index) {
                      var suggestion =
                          _searchController.locationSuggestions[index];
                      return ListTile(
                        title: Text(suggestion['display_name']),
                        onTap: () {
                          widget.controller.text = suggestion['display_name'];
                          _searchController.locationSuggestions.clear();
                        },
                      );
                    },
                  ),
                )
              : const SizedBox.shrink();
        }),
      ],
    );
  }
}
