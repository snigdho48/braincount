import 'dart:io';
import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DatacollectController extends NavController {
  final lat = 0.0.obs;
  final lon = 0.0.obs;
  final locationStatus = ''.obs;
  final selectedStatus = 'Good'.obs;
  final commentController = TextEditingController().obs;
  final navcontroller = Get.put(NavController());

  final statusList = [
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
    // Initialize the camera controller
    navcontroller.initializeCamera();
    _getLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    disableCamera();

    super.onClose();
  }

  @override
  void dispose() {
    disableCamera();
    super.dispose();
  }

  void preview(XFile xfile ,String type) {
    final initialIndex = navcontroller.imageList.indexOf(xfile);
    final pageController = PageController(initialPage: initialIndex);

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: false,
      barrierLabel: "Preview",
      barrierColor: Colors
          .transparent, // Set the barrier color to transparent to remove the background overlay
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor:
              Colors.transparent, // Transparent background for the Scaffold
          body: SafeArea(
            child: Stack(
              children: [
                // No background container, just the gallery
                SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    itemCount: navcontroller.imageList.length,
                    pageController: pageController,
                    loadingBuilder: (context, event) => Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: event == null
                              ? null
                              : event.expectedTotalBytes != null
                                  ? event.cumulativeBytesLoaded /
                                      event.expectedTotalBytes!
                                  : null,
                        ),
                      ),
                    ),
                    builder: (BuildContext context, int index) {
                      final imageFile =
                          File(navcontroller.imageList[index]['file'].path);

                      return PhotoViewGalleryPageOptions(
                        imageProvider: FileImage(imageFile),
                        initialScale: PhotoViewComputedScale.contained * .95,
                        heroAttributes:
                            PhotoViewHeroAttributes(tag: imageFile.path),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                  Positioned(
                  top: 20,
                  left: 20,
                  child: Text(type, style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ],
            ),
          ),
        );
      },
    );
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
      if (storage.isDenied) {
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
