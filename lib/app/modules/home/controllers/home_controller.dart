import 'package:braincount/app/data/constants.dart';
import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final navcontroller = Get.put(NavController());
  final request = oneRequest();
  final storage = GetStorage();
  final pendingtask = {}.obs;
  @override
  void onInit() {
    super.onInit();
    tasks();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void tasks() async {
    final result = await request.send(
        url: '${baseUrl}monitoring_request/',
        method: RequestType.GET,
        header: {
          'Authorization': 'Bearer ${storage.read('token')}',
          'Accept': 'application/json',
        },
        resultOverlay: false,
        queryParameters: {
          'status': 'PENDING',
        });
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
            child: const Text(
              'Are you sure you want to accept this task?',
              style: TextStyle(fontSize: 16),
            ),
          ),
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
