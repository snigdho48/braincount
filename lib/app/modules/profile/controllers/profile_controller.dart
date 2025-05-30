import 'package:braincount/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';

class ProfileController extends GetxController {
  final request = oneRequest();
  final storage = GetStorage();
  final profile = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  void getProfile() async {
    return;
    final result = await request.send(
        url: '${baseUrl}profile/',
        method: RequestType.GET,
        header: {
          'Authorization': 'Bearer ${storage.read('token')}',
          'Accept': 'application/json',
        },
        resultOverlay: false);
    result.fold((response) {
      profile.clear();
      profile.value = response;
      print('Profile: $profile');
    }, (error) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 3));
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
