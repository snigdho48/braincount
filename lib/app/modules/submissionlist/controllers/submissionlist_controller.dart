import 'dart:convert';

import 'package:braincount/app/modules/submissionlist/data/submission/submission.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:braincount/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class SubmissionListController extends GetxController {
  //TODO: Implement SUBMISSIONLISTController

  final request = oneRequest();
  final storage = GetStorage();
  final pendingtask = List<Submission>.empty(growable: true).obs;

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
      url: '${baseUrl}monitoring/',
      method: RequestType.GET,
      header: {
        'Authorization': 'Bearer ${storage.read('token')}',
        'Accept': 'application/json',
      },
      resultOverlay: false,
    );
    result.fold((response) {
      pendingtask.clear();
      pendingtask.value = List<Submission>.from(
          response.map((x) => Submission.fromMap(x)).toList());
    }, (error) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          icon: const Icon(Icons.error, color: Colors.red),
          duration: const Duration(seconds: 3));
    });
  }
}
