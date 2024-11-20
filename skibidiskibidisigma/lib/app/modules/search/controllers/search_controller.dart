import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchController extends GetxController {
  var isLocationActive = false.obs;
  var searchQuery = ''.obs;
  late stt.SpeechToText speechToText;

  @override
  void onInit() {
    super.onInit();
    speechToText = stt.SpeechToText();
    print("SpeechToText initialized.");
  }

  void toggleLocation() {
    isLocationActive.value = !isLocationActive.value;
    print("Location status toggled: ${isLocationActive.value}");
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
