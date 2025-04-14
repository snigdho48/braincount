import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:braincount/app/data/constants.dart';
import 'package:flutter/material.dart';

class PreviouslistController extends GetxController {
  //TODO: Implement PreviouslistController

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
          'exclude': 'PENDING',
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
}
