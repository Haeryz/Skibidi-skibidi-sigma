import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  final String _apiKey = dotenv.env['LOCATIONIQ_API_KEY']!;

  Future<List<dynamic>> fetchAutocomplete(String query) async {
    final url =
        'https://us1.locationiq.com/v1/autocomplete?q=$query&key=$_apiKey';
    
    final response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load autocomplete data');
    }
  }
}