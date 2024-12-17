import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  final Connectivity connectivity = Connectivity();
  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    connectivity.onConnectivityChanged.listen((connectivityResults) {
      // Handle the first element of the list
      if (connectivityResults.isNotEmpty) {
        _updateConnectionStatus(connectivityResults.first);
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    var connectivityResult = await connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult.first);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    isConnected.value = connectivityResult != ConnectivityResult.none;
    if (!isConnected.value) {
      Get.snackbar("Connection Status", "No Internet Connection");
    } else {
      Get.snackbar("Connection Status", "Connected to Internet");
    }
  }
}
