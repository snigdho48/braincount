import 'package:braincount/app/data/constants.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';

class LoginController extends GetxController {
  final GlobalKey formKey = GlobalKey();
  final visible = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final emailFocus = FocusNode().obs;
  final passwordFocus = FocusNode().obs;
  final request = oneRequest();
  final storage = GetStorage();

  final count = 0.obs;
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

  void login() async {
    // validate email with getx
    if (!GetUtils.isUsername(email.text)) {
      Get.snackbar('Error', 'Please enter a valid email address',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 5));
      return;
    }
    if (password.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a password',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 5));
      return;
    }
    if (password.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 5));
      return;
    }
    // Perform login action

    final result = await request.send(
        url: '${baseUrl}auth/login/',
        method: RequestType.POST,
        body: {
          'username': email.text,
          'password': password.text,
        },
        resultOverlay: false);

    result.fold(
      (res) {
        // Handle error
        Get.snackbar('Success', 'Login successful',
            snackPosition: SnackPosition.TOP,
            isDismissible: true,
            icon: const Icon(Icons.check, color: Colors.green),
            duration: const Duration(seconds: 5));
        print(res);
        storage.write('token', res['access_token']);
        storage.write('group', res['groups']);
        storage.write('username', res['username']);
        storage.write('email', res['email']);
        Get.offAllNamed(Routes.HOME);
      },

      (error) {
        Get.snackbar('Error', 'Login failed',
            snackPosition: SnackPosition.TOP,
            isDismissible: true,
            icon: const Icon(Icons.error, color: Colors.red),
            duration: const Duration(seconds: 5));
      },
      // Handle success
    );
  }
}
