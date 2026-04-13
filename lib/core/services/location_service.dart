import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/app/urls.dart';
import 'package:amin_pass/app/token_service.dart';

class LocationService extends GetxService {
  final NetworkClient _networkClient = Get.find<NetworkClient>();
  Timer? _locationTimer;

  Future<void> startPeriodicLocationUpdate() async {
    // Stop any existing timer
    stopPeriodicUpdate();

    // Check permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    // Initial update
    _fetchAndSendLocation();

    // Start 20-minute timer
    _locationTimer = Timer.periodic(const Duration(minutes: 20), (timer) {
      _fetchAndSendLocation();
    });
    
    print("Periodic location update started (20 minutes interval).");
  }

  Future<void> _fetchAndSendLocation() async {
    try {
      // Check if user is logged in
      if (TokenService.accessToken == null) {
        print("User not logged in. Skipping location update.");
        stopPeriodicUpdate();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await _networkClient.postRequest(
        ApiUrls.updateLocation,
        body: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );

      if (response.isSuccess) {
        print('Location updated successfully: ${position.latitude}, ${position.longitude}');
      } else {
        print('Failed to update location: ${response.errorMassage}');
      }
    } catch (e) {
      print('Error fetching or sending location: $e');
    }
  }

  void stopPeriodicUpdate() {
    _locationTimer?.cancel();
    _locationTimer = null;
    print("Periodic location update stopped.");
  }

  @override
  void onClose() {
    stopPeriodicUpdate();
    super.onClose();
  }
}
