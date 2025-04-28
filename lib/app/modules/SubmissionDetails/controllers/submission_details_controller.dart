import 'dart:io';

import 'package:braincount/app/data/constants.dart';
import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:braincount/app/modules/submissionlist/data/submission/submission.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SubmissionDetailsController extends GetxController {
  late CameraController camcontroller;
  late Future<void> initializeControllerFuture;

  final submissionData = Submission().obs;
  final statusMultiSelectController = MultiSelectController<String>().obs;
  final commentFocusNode = FocusNode().obs;
  final lat = 0.0.obs;
  final lon = 0.0.obs;
  final locationStatus = ''.obs;
  final selectedStatus = [].obs;
  final commentController = TextEditingController().obs;
  final navcontroller = Get.put(NavController());
  final request = oneRequest();
  final storage = GetStorage();
  final uuid = ''.obs;
  final images = [].obs;
  final statusList = [].obs;
  @override
  void onInit() {
    super.onInit();
    submissionData.value = Get.arguments as Submission;
    commentController.value.text = submissionData.value.comment ?? '';

    images.value = [
      {
        'url': submissionData.value.close,
        'type': 'close',
      },
      {
        'url': submissionData.value.front,
        'type': 'front',
      },
      {
        'url': submissionData.value.left,
        'type': 'left',
      },
      {
        'url': submissionData.value.right,
        'type': 'right',
      },
      if (submissionData.value.extraImagesList != null)
        ...submissionData.value.extraImagesList!
            .asMap()
            .entries
            .map((entry) => {
                  'url': entry.value,
                  'type': 'extra ${entry.key + 1}',
                }),
    ];
    buildimage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
    commentFocusNode.value.dispose();
    commentController.value.dispose();
    navcontroller.camcontroller.dispose();
    navcontroller.imageList.clear();
  }

  void buildimage() async {
    // List to hold Future results for parallel downloads
    List<Future> imageDownloads = [];

    for (var element in images) {
      if (element['url'] != null) {
        // Start downloading image in parallel
        imageDownloads.add(urlToFile(element['url']).then((imagefile) async {
          // Convert the File to XFile
          final XFile xfile = XFile(imagefile.path);

          // Once the image is downloaded and converted to XFile, add it to the list
          if (navcontroller.imageList
              .where((e) => e['type'] == element['type'])
              .isEmpty) {
            navcontroller.imageList.add({
              'file': xfile, // Use XFile here instead of File
              'type': element['type'],
            });
          }
        }).catchError((e) {
          // Handle error for each image download
          print('Error downloading image ${element['url']}: $e');
        }));
      }
    }

    // Wait for all downloads to finish
    await Future.wait(imageDownloads);
  }

  Future<File> urlToFile(String imageUrl) async {
    try {
      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      // Download image with timeout (10 seconds)
      final http.Response response = await http
          .get(Uri.parse(baseUrl.split('/api')[0] + imageUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Save to file
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception(
            'Failed to load image, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading image: $e');
      rethrow; // Propagate the error further if needed
    }
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      camcontroller = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );
      initializeControllerFuture = camcontroller.initialize();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void enableCamera() async {
    try {
      await camcontroller.initialize();
    } catch (e) {
      print('Error enabling camera: $e');
    }
  }

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

  void preview(String url, String type) {
    final initialIndex = images.indexWhere((element) => element['url'] == url);
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
                    itemCount: images.length,
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
                        imageProvider: Image.network(
                          baseUrl.split('/api')[0] + images[index]['url'],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    ),
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ).image,
                        minScale: PhotoViewComputedScale.contained,
                        initialScale: PhotoViewComputedScale.contained * .95,
                        heroAttributes:
                            // Use the file path as the hero tag
                            PhotoViewHeroAttributes(
                          tag: baseUrl.split('/api')[0] + images[index]['url'],
                          transitionOnUserGestures: true,
                        ),
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
      print(response);
      statusList.value = response['status'];
      print(submissionData.value.status ?? []);
      if (submissionData.value.status != null || submissionData.value.status!.isNotEmpty) {
        selectedStatus.value = submissionData.value.status ?? [];
        
      } else {
        selectedStatus.value = [];
      }
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
      method: RequestType.POST,
      formData: true,
      header: {
        'Authorization': 'Bearer ${storage.read('token')}',
      },
      resultOverlay: false,
      body: {
        'uuid': submissionData.value.uuid,
        'status': selectedStatus.value,
        'comment': commentController.value.text,
        'billboard': submissionData.value.billboard,
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

  void resubmit() {}
}
