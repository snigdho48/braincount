import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final GlobalKey formKey = GlobalKey();
  final visible = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final emailFocus = FocusNode().obs;
  final passwordFocus = FocusNode().obs;

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

  void increment() => count.value++;
}
