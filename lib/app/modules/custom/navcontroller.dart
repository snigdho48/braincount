// lib/app/controllers/nav_controller.dart

import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class NavController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final cameraready = false.obs;
  final cameraclick = false.obs;
  final cameraenable = false.obs;
  late CameraController camcontroller;
  late Future<void> initializeControllerFuture;
  final scale = 1.0.obs; // Initial scale factor
  final RxList<Map> imageList = <Map>[].obs;

  RxDouble btnScale = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeCameraReady() {
    cameraready.value = !cameraready.value;
  }

  void changeCameraClick() {
    cameraclick.value = !cameraclick.value;
  }

  void removeImage(String type) {
    imageList.removeWhere((element) => element['type'] == type);
  }

  void startScaling() {
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 300));
      if (imageList.length == 4) {
        btnScale.value = 1.0;
      } else {
        btnScale.value = (btnScale.value == 1.0) ? 1.2 : 1.0;
      }
      return true; // Keep the loop running
    });
  }

  void opencamera({required String type}) async {
    print('imageList: $imageList');
    await initializeCamera();
    if (Get.currentRoute == "/dataCollect" || Get.currentRoute == "/submissionDetails") {
      if (imageList.length == 8) {
        Get.snackbar(
          'Limit Over',
          'Cannot take more than 8 images',
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
        );
        return;
      }

      showGeneralDialog(
        context: Get.context!,
        barrierDismissible: false,
        barrierLabel: "Camera",
        pageBuilder: (context, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              // Optional: remove SafeArea if you want to go *under* status bar too
              child: Stack(
                children: [
                  SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: FutureBuilder<void>(
                      future: initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CameraPreview(camcontroller);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.of(context).pop();
                        disableCamera();
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            final image = await camcontroller.takePicture();
                            imageList.add({
                              'file': image,
                              'type': type,
                            });

                            Navigator.of(context).pop();
                            disableCamera();
                          } catch (e) {
                            print('Error taking picture: $e');
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 32,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      Get.snackbar(
        'Camera Disabled',
        'Camera is disabled in this route.',
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
      );
      return;
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
      cameraready.value = true;
    } catch (e) {
      print('Error enabling camera: $e');
    }
  }

  void disableCamera() {
    cameraenable.value = false;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Get.offAllNamed(Routes.HOME);
    } else if (index == 1) {
      Get.offAllNamed(Routes.TASKLIST);
    } else if (index == 2) {
      Get.offAllNamed(Routes.WITHDRAW);
    } else if (index == 3) {
      Get.offAllNamed(Routes.NOTIFICATIONS);
    } else if (index == 4) {
      Get.offAllNamed(Routes.PROFILE);
    }
  }
}
