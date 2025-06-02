import 'dart:convert';
import 'dart:io';
import 'package:braincount/app/data/constants.dart';
import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:braincount/app/modules/datacollect/model/monitoring_model/monitoring_model.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class DatacollectController extends NavController {
  final lat = 0.0.obs;
  final lon = 0.0.obs;
  final locationStatus = ''.obs;
  final selectedStatus = [].obs;
  final commentController = TextEditingController().obs;
  final navcontroller = Get.put(NavController());
  final request = oneRequest();
  final storage = GetStorage();
  final uuid = ''.obs;
  final model = Rx<List<MonitoringModel>>([]);
  final updatedmodel = Rx<MonitoringModel?>(null);
  final statusMultiSelectController = MultiSelectController<String>().obs;
  final commentFocusNode = FocusNode().obs;
  final previous_status = [].obs;

  final statusList = [].obs;

  @override
  void onInit() {
    super.onInit();
    _getLocation();
    uuid.value = Get.arguments[0];
    previous_status.value = Get.arguments[1] ?? [];
    navcontroller.imageList.clear();
    getStatus();
    getdata(uuid: uuid.value);
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
    navcontroller.imageList.clear();
    commentController.value.clear();
    selectedStatus.value = statusList[0];
    model.value = [];
    updatedmodel.value = null;
    super.dispose();
  }

  void getStatus() async {
    final result = await request.send(
      url: '${baseUrl}monitoring/billboard-status/',
      method: RequestType.GET,
      header: {
        'Authorization': 'Bearer ${storage.read('token')}',
        'Accept': 'application/json',
      },
      resultOverlay: false,
    );
    result.fold((response) {
      statusList.clear();
      statusList.value = response['status'];
      selectedStatus.value = [statusList[0]];
    }, (error) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 3));
    });
  }

  void postData() async {
    if (navcontroller.imageList.length < 4) {
      Get.snackbar('Error', 'Please take all the photo',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 3));
      return;
    }
    if (selectedStatus.isEmpty) {
      Get.snackbar('Error', 'Please select status',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 3));
      return;
    }
 
    final result = await request.send(
      url: '${baseUrl}monitoring/',
      method: RequestType.PATCH,
      formData: true,
      header: {
        'Authorization': 'Bearer ${storage.read('token')}',
      },
      resultOverlay: false,
      body: {
        'uuid': updatedmodel.value?.uuid,
        'status': selectedStatus.value,
        'comment': commentController.value.text,
        'latitude': lat.value,
        'longitude': lon.value,
        'left': request.file(
            file: File(navcontroller.imageList
                .firstWhere((e) => e['type'] == 'left')['file']
                .path),
            filename: 'left.jpg'),
        'front': request.file(
            file: File(navcontroller.imageList
                .firstWhere((e) => e['type'] == 'front')['file']
                .path),
            filename: 'front.jpg'),
        'close': request.file(
            file: File(navcontroller.imageList
                .firstWhere((e) => e['type'] == 'close')['file']
                .path),
            filename: 'close.jpg'),
        'right': request.file(
            file: File(navcontroller.imageList
                .firstWhere((e) => e['type'] == 'right')['file']
                .path),
            filename: 'right.jpg'),
        'extra_images': navcontroller.imageList
            .where((e) =>
                e['type'] != 'left' &&
                e['type'] != 'front' &&
                e['type'] != 'close' &&
                e['type'] != 'right')
            .toList()
            .map((e) => request.file(
                file: File(e['file'].path), filename: e['file'].name))
            .toList(),
      },
    );

    result.fold((response) {
      Get.back();
      Get.snackbar('Success', 'Data submitted successfully',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.check, color: Colors.green),
          duration: const Duration(seconds: 3));
    }, (error) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 3));
    });
  }

  void getdata({
    String? uuid,
  }) async {
    final result = await request.send(
      url: '${baseUrl}monitoring/',
      method: RequestType.GET,
      header: {
        'Authorization': 'Bearer ${storage.read('token')}',
        'Accept': 'application/json',
      },
      resultOverlay: false,
      queryParameters: {
        'request_uuid': uuid,
      },
    );
    result.fold((response) {
      model.value = [];
      model.value = (response as List)
          .map((e) => MonitoringModel.fromJson(jsonEncode(e)))
          .toList();

      updatedmodel.value = model.value.firstWhereOrNull((e) =>
          e.left == null &&
          e.right == null &&
          (e.comment == '' || e.comment == null) &&
          e.front == null &&
          e.close == null);
      if (updatedmodel.value == null) {
        Get.back();

        Get.snackbar('Error', 'Data Already Updated',
            snackPosition: SnackPosition.TOP,
            isDismissible: true,
            icon: const Icon(Icons.error, color: Colors.red),
            duration: const Duration(seconds: 2));
        return;
      }
    }, (error) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 2));
    });
  }

  void preview(XFile xfile, String type) {
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
                      return PhotoViewGalleryPageOptions(
                        imageProvider: navcontroller.imageList[index]['file'] ==
                                null
                            ? null
                            : FileImage(File(
                                navcontroller.imageList[index]['file'].path)),
                        initialScale: PhotoViewComputedScale.contained * .95,
                        heroAttributes:
                            navcontroller.imageList[index]['file'] == null
                                ? null
                                : // Use the file path as the hero tag
                                PhotoViewHeroAttributes(
                                    tag: File(navcontroller
                                            .imageList[index]['file'].path)
                                        .path),
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
                  child: Text(
                    type,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
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
        duration: const Duration(seconds: 3),
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

    locationStatus.value = 'Location fetched successfully';
  }
}
