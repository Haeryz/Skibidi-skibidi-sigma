import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

import '../views/location_service.dart';

class SearchController extends GetxController {
  var isLocationActive = false.obs;
  var searchQuery = ''.obs;
  late stt.SpeechToText speechToText;

  final TextEditingController controllerLocation = TextEditingController();
  final LocationService _locationService = LocationService();
  var locationSuggestions = <dynamic>[].obs;

  final AudioPlayer _audioPlayer = AudioPlayer();
  var isAudioPlaying = false.obs;
  var currentAudioPosition = 0.obs;
  var audioTotalDuration = 0.obs;

  var currentLocation = ''.obs;
  var fullAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    speechToText = stt.SpeechToText();
    print("SpeechToText initialized.");

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      isAudioPlaying.value = state == PlayerState.playing;
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      currentAudioPosition.value = position.inMilliseconds;
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      audioTotalDuration.value = duration.inMilliseconds;
    });
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> setLocationFromGPS() async {
    try {
      // Check if location permission is granted
      if (await Permission.location.request().isGranted) {
        // Get the current position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Save coordinates
        currentLocation.value =
            "Lat: ${position.latitude}, Long: ${position.longitude}";

        // Convert coordinates to a human-readable address
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          fullAddress.value =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
          print("Full address: ${fullAddress.value}");
        }
      } else {
        currentLocation.value = "Permission denied.";
        fullAddress.value = "Unable to fetch address.";
        print("Location permission denied.");
      }
    } catch (e) {
      currentLocation.value = "Failed to get location.";
      fullAddress.value = "Error: $e";
      print("Error fetching location: $e");
    }
  }

  Future<void> fetchLocationSuggestions(String query) async {
    if (query.isNotEmpty) {
      try {
        final response = await _locationService.fetchAutocomplete(query);
        locationSuggestions.value = response;
      } catch (error) {
        print("Error fetching location suggestions: $error");
        locationSuggestions.value = [];
      }
    } else {
      locationSuggestions.value = [];
    }
  }

  void toggleLocation() {
    isLocationActive.value = !isLocationActive.value;
    print("Location status toggled: ${isLocationActive.value}");

    if (isLocationActive.value) {
      playAudio('sound/livechat-129007.mp3');
    }
  }

  Future<void> playAudio(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path));
      print("Audio playing: $path");
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    print("Audio paused");
  }

  Future<void> resumeAudio() async {
    await _audioPlayer.resume();
    print("Audio resumed");
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    print("Audio stopped");
  }

  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
    print("Audio seeked to ${position.inSeconds} seconds");
  }

  Future<void> startListening() async {
    try {
      if (speechToText.isListening) {
        print("SpeechToText is already listening.");
        return;
      }

      print("Attempting to initialize SpeechToText...");
      bool available = await speechToText.initialize(
        onError: (error) {
          print("SpeechToText Error: ${error.errorMsg}");
        },
        onStatus: (status) {
          print("SpeechToText Status: $status");
        },
      );

      if (available) {
        print("SpeechToText available. Starting to listen...");
        speechToText.listen(onResult: (result) {
          searchQuery.value = result.recognizedWords;
          print("Recognized Words: ${result.recognizedWords}");
        });
      } else {
        print("SpeechToText not available on this device.");
      }
    } catch (e) {
      print("Error in startListening: $e");
    }
  }

  void stopListening() {
    try {
      if (speechToText.isListening) {
        speechToText.stop();
        print("Stopped listening.");
      } else {
        print("SpeechToText was not listening.");
      }
    } catch (e) {
      print("Error in stopListening: $e");
    }
  }
}
