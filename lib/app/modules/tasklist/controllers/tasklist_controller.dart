import 'package:braincount/app/modules/custom/map.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:braincount/app/data/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class TasklistController extends GetxController {
  final request = oneRequest();
  final storage = GetStorage();
  final pendingtask = {}.obs;
  final selectedStatus = 'ALL'.obs;
  final statusList = [
    'ALL',
    'ACCEPTED',
    'REJECTED',
    'PENDING',
    'COMPLETED',
  ].obs;
  @override
  void onInit() {
    super.onInit();
    tasks();
  }

  void tasks() async {
    pendingtask.clear();
    final queryParams =
        selectedStatus.value != 'ALL' ? {'status': selectedStatus.value} : null;
    final result = await request.send(
      url: '${baseUrl}monitoring_request/',
      method: RequestType.GET,
      header: {
        'Authorization': 'Bearer ${storage.read('token')}',
        'Accept': 'application/json',
      },
      resultOverlay: false,
      queryParameters: queryParams,
    );
    result.fold((response) {
      pendingtask.clear();
      pendingtask.value = response;
    }, (error) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 3));
    });
  }

  Future<void> getDetails(task) async {
    // Check if location permission is granted
    final locationPermission = await Permission.location.status;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();


    if (!serviceEnabled) {
      Get.snackbar('Location Disabled',
          'Location services are disabled. Please enable them in your device settings to continue.',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.location_off, color: Colors.red),
          duration: const Duration(seconds: 3));
      return;
    }

    if (locationPermission.isDenied || locationPermission.isPermanentlyDenied) {
      // Optionally, you can request permission here
      Get.snackbar('Permission Denied',
          'Location permission is denied. Please enable it in your app settings to continue.',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 3));
      return;
    }
        final latitude = task['billboard_detail']['latitude'];
    final longitude = task['billboard_detail']['longitude'];
    final currentLocation = await Geolocator.getCurrentPosition();
    final distance = Geolocator.distanceBetween(latitude, longitude,
        currentLocation.latitude, currentLocation.longitude);
    if (distance > 50) {
      Get.snackbar('Location Mismatch',
          'You are not near the billboard location.',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.location_off, color: Colors.red),
          duration: const Duration(seconds: 3));
      return;
    }
    
    return task['is_accepeted'] == 'ACCEPTED'
        ? Get.toNamed(Routes.DATACOLLECT, arguments: [task['uuid'], task['previous_status']])
        : task['is_accepeted'] == 'PENDING' || task['is_accepeted'] == null
            ? opendialog(uuid: task['uuid'])
            : null;
  }

  String getTaskView(task)  {
    final views = task['billboard_detail']['views'];

      // get view index
      final viewIndex = views.indexWhere((view) => view['id'] == task['view']);

    return '\nview: ${viewIndex + 1}';
  }


  void accepetTask({String? uuid, String? status}) async {
    final result = await request.send(
        url: '${baseUrl}monitoring_request/',
        method: RequestType.PATCH,
        header: {
          'Authorization': 'Bearer ${storage.read('token')}',
          'Accept': 'application/json',
        },
        resultOverlay: false,
        body: {
          'is_accepeted': status,
          'uuid': uuid,
        });
    result.fold((response) {
      tasks();
      Get.snackbar('Success', 'Task accepted successfully',
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

  void opendialog({String? uuid}) {
    final task =
        pendingtask['monitoring'].firstWhere((task) => task['uuid'] == uuid);
    Get.defaultDialog(
      title: 'Task Acceptance',
      titlePadding: EdgeInsets.only(top: Get.height * .02),
      content: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                left: Get.width * .05,
                right: Get.width * .05,
                top: Get.height * .01,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    task['billboard_detail']['title'] ?? 'Untitled',
                    style: TextStyle(
                        fontSize: 16, textBaseline: TextBaseline.alphabetic),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Get.height * .0125,
                  ),
                  SizedBox(
                    width: Get.width * .8,
                    height: Get.height * .3,
                    child: openStreetMap(
                      coordinates: [
                        {
                          'lat': task['billboard_detail']['latitude'],
                          'lon': task['billboard_detail']['longitude']
                        }
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .02,
                  ),
                  const Text(
                    'This task will be assigned to you and you will be responsible for its completion.',
                    style: TextStyle(
                        fontSize: 14, textBaseline: TextBaseline.alphabetic),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: Get.height * .02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    accepetTask(uuid: uuid, status: 'ACCEPTED');
                    Get.back();
                  },
                  child: const Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide.none,
                    ),
                    elevation: 3,
                    padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                  ),
                ),
                ElevatedButton(
                  child: Text('Reject', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    accepetTask(uuid: uuid, status: 'REJECTED');
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide.none,
                    ),
                    elevation: 3,
                    padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
