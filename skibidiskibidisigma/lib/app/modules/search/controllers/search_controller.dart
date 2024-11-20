import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';

class SearchController extends GetxController {
  var isLocationActive = false.obs;
  var searchQuery = ''.obs;
  late stt.SpeechToText speechToText;
  
  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Observables for audio state
  var isAudioPlaying = false.obs;
  var currentAudioPosition = 0.obs;
  var audioTotalDuration = 0.obs;

  @override
  void onInit() {
    super.onInit();
    speechToText = stt.SpeechToText();
    print("SpeechToText initialized.");

    // Listen to audio player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      isAudioPlaying.value = state == PlayerState.playing;
    });

    // Listen to audio position changes
    _audioPlayer.onPositionChanged.listen((Duration position) {
      currentAudioPosition.value = position.inMilliseconds;
    });

    // Listen to audio duration changes
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      audioTotalDuration.value = duration.inMilliseconds;
    });
  }

  @override
  void onClose() {
    // Dispose of audio player when controller is closed
    _audioPlayer.dispose();
    super.onClose();
  }

  void toggleLocation() {
    isLocationActive.value = !isLocationActive.value;
    print("Location status toggled: ${isLocationActive.value}");
    
    // Play notification sound when location is activated
    if (isLocationActive.value) {
      playAudio('sound/livechat-129007.mp3');
    }
  }

  // Play audio from a given source
  Future<void> playAudio(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path));
      print("Audio playing: $path");
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Pause the currently playing audio
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    print("Audio paused");
  }

  // Resume the paused audio
  Future<void> resumeAudio() async {
    await _audioPlayer.resume();
    print("Audio resumed");
  }

  // Stop the audio completely
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    print("Audio stopped");
  }

  // Seek to a specific position in the audio
  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
    print("Audio seeked to ${position.inSeconds} seconds");
  }

  // Existing speech-to-text methods remain the same
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