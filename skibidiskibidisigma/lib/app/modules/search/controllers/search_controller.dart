import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
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

  void setLocationFromGPS() async {
    print("Fetching location from GPS");
    // Implement GPS location fetching logic
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