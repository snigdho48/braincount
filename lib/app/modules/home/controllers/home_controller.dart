import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final navcontroller = Get.put(NavController());
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

   void opendialog() {
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
                  child: const Text('Reject',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
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
