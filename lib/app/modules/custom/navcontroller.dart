// lib/app/controllers/nav_controller.dart

import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:braincount/app/modules/home/controllers/home_controller.dart';
import 'package:braincount/app/modules/tasklist/controllers/tasklist_controller.dart';
import 'package:braincount/app/modules/withdraw/controllers/withdraw_controller.dart';
import 'package:braincount/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:braincount/app/modules/profile/controllers/profile_controller.dart';

class NavController extends GetxController with RouteAware {
  final RxInt selectedIndex = 0.obs;
  final RxString currentTitle = Routes.HOME.substring(1)
      .split('/')
      .map((word) => word.isNotEmpty
          ? (word[0].toUpperCase() +
              word.substring(1).replaceAllMapped(
                    RegExp(r'([A-Z])'),
                    (match) => ' ${match.group(0)}',
                  ))
          : '')
      .join(' - ')
      .obs;
  final cameraready = false.obs;
  final cameraclick = false.obs;
  final cameraenable = false.obs;
  late CameraController camcontroller;
  late Future<void> initializeControllerFuture;
  final scale = 1.0.obs; // Initial scale factor
  final RxList<Map> imageList = <Map>[].obs;

  RxDouble btnScale = 1.0.obs;

  late final HomeController homeController;
  late final TasklistController tasklistController;
  late final WithdrawController withdrawController;
  late final NotificationsController notificationsController;
  late final ProfileController profileController;
  final isFirstTime = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
   
  }

  void changeIndex(int index) {
    if (selectedIndex.value == index) {
      // If same tab is selected, refresh the data
      refreshCurrentTab();
      return;
    }
    selectedIndex.value = index;
    updateTitle();
    refreshCurrentTab();
  }
  void _updateTitleByRoute(String route) {
    // You can expand this mapping as needed
    switch (route) {
      case Routes.HOME:
        currentTitle.value = capitalize(Routes.HOME);
        break;
      case Routes.TASKLIST:
        currentTitle.value = capitalize(Routes.TASKLIST);
        break;
      case Routes.WITHDRAW:
        currentTitle.value = capitalize(Routes.WITHDRAW);
        break;
      case Routes.NOTIFICATIONS:
        currentTitle.value = capitalize(Routes.NOTIFICATIONS);
        break;
      case Routes.PROFILE:
        currentTitle.value = capitalize(Routes.PROFILE);
        break;
      default:
        // Fallback: use the last segment of the route as title
        final last = route.split('/').last;
        currentTitle.value =
            last.isNotEmpty ? capitalize(last) : capitalize(Routes.HOME);
    }
  }

  String capitalize(String s) => s
      .substring(1)
      .split('/')
      .map((word) => word.isNotEmpty
          ? (word[0].toUpperCase() +
              word.substring(1).replaceAllMapped(
                    RegExp(r'([A-Z])'),
                    (match) => ' ${match.group(0)}',
                  ))
          : '')
      .join(' - ');
  void updateTitle() {
    switch (selectedIndex.value) {
      case 0:
        _updateTitleByRoute(Routes.HOME);
        break;
      case 1:
        _updateTitleByRoute(Routes.TASKLIST);
        break;
      case 2:
        _updateTitleByRoute(Routes.WITHDRAW);
        break;
      case 3:
        _updateTitleByRoute(Routes.NOTIFICATIONS);
        break;
      case 4:
        _updateTitleByRoute(Routes.PROFILE);
        break;
    }
  }

  /// Call this from any page to set the app bar title dynamically
  void setTitle(String title) {
    currentTitle.value = title;
  }

  void refreshCurrentTab() {
    // Call appropriate API based on selected tab
     if(isFirstTime.value){
      homeController = Get.find<HomeController>();
    tasklistController = Get.find<TasklistController>();
    withdrawController = Get.find<WithdrawController>();
    notificationsController = Get.find<NotificationsController>();
    profileController = Get.find<ProfileController>();
    isFirstTime.value = false;
     }
    switch (selectedIndex.value) {
      case 0:
        homeController.onInit();
        break;
      case 1:
        tasklistController.tasks();
        homeController.onInit();
        break;
      case 2:
        withdrawController.onInit();
        break;
      case 3:
        notificationsController.onInit();
        break;
      case 4:
        profileController.onInit();
        break;
    }
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
    if (Get.currentRoute == "/dataCollect" ||
        Get.currentRoute == "/submissionDetails") {
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


}
