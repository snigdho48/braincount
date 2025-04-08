import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class DatacollectController extends NavController {
  final lat = 0.0.obs;
  final lon = 0.0.obs;
  final locationStatus = ''.obs;
  final selectedStatus = 'Good'.obs;
  final commentController = TextEditingController().obs;
  final statusList =[
    'Good',
    "Broken",
    "Not Working",
    "Not Available",
    "Not Visible",
    "Not Clear",
    "Not Bright",
    "Not Clean",

  ].obs;

  @override
  void onInit() {
    super.onInit();
    _getLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    disableCamera();
  }

  @override
  void dispose() {
    super.dispose();
    imageList.clear();
    disableCamera();
  }

  // Function to request permissions and get location
  Future<void> _getLocation() async {
    // Check location permissions using permission_handler
    PermissionStatus permission = await Permission.location.status;

    if (permission.isDenied || permission.isPermanentlyDenied) {
      // Request permission if it's denied or permanently denied
      PermissionStatus permissionResult = await Permission.location.request();
          PermissionStatus camera = await Permission.camera.request();
      PermissionStatus storage = await Permission.storage.request();

      if (permissionResult.isDenied) {
        locationStatus.value = 'Location permission denied';
        return;
      } else if (permissionResult.isPermanentlyDenied) {
        locationStatus.value = 'Location permission permanently denied';
        return;
      }
      if (camera.isDenied) {
        locationStatus.value = 'Camera permission denied';
        return;
      } else if (camera.isPermanentlyDenied) {
        locationStatus.value = 'Camera permission permanently denied';
        return;
      }
      if(storage.isDenied) {
        locationStatus.value = 'Storage permission denied';
        return;
      } else if (storage.isPermanentlyDenied) {
        locationStatus.value = 'Storage permission permanently denied';
        return;
      }
    }

    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationStatus.value = 'Location services are disabled.';
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services to use this feature.',
        snackPosition: SnackPosition.TOP,
        isDismissible: true,
        icon: const Icon(Icons.error, color: Colors.red),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        boxShadows: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderColor: Colors.red,
        borderWidth: 1,
      );
      return;
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    lat.value = position.latitude;
    lon.value = position.longitude;

    enableCamera();
    print('enable: ${cameraenable.value}');

    locationStatus.value = 'Location fetched successfully';
  }
}
