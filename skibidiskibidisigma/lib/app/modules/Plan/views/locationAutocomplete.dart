import 'package:flutter/material.dart';
import 'package:skibidiskibidisigma/app/modules/plan/views/locationService.dart';

class LocationAutocomplete extends StatefulWidget {
  final TextEditingController controller;

  LocationAutocomplete({required this.controller});

  @override
  _LocationAutocompleteState createState() => _LocationAutocompleteState();
}

class _LocationAutocompleteState extends State<LocationAutocomplete> {
  final LocationService _locationService = LocationService();
  List<dynamic> _suggestions = [];

void _onChanged(String value) async {
  if (value.isNotEmpty) {
    try {
      final response = await _locationService.fetchAutocomplete(value);
      setState(() {
        _suggestions = response;
      });
    } catch (error) {
      // Handle error here (e.g., log it or show a message)
      setState(() {
        _suggestions = [];
      });
    }
  } else {
    setState(() {
      _suggestions = [];
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(labelText: 'Location'),
          onChanged: _onChanged,
          style: TextStyle(fontSize: 18.0),
        ),
        if (_suggestions.isNotEmpty)
          Container(
            height: 200, // Set a height for the suggestions list
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                var suggestion = _suggestions[index];
                return ListTile(
                  title: Text(suggestion['display_name']),
                  onTap: () {
                    widget.controller.text = suggestion['display_name'];
                    setState(() {
                      _suggestions = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
