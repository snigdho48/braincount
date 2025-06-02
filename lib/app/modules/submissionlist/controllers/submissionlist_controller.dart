import 'package:braincount/app/modules/submissionlist/data/submission/submission.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:braincount/app/data/constants.dart';
import 'package:flutter/material.dart';

class SubmissionListController extends GetxController {
  //TODO: Implement SUBMISSIONLISTController
  final selectedStatus = 'ALL'.obs;
  final statusList = [
    'ALL',
    'ACCEPTED',
    'REJECTED',
    'PENDING',
  ].obs;

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

    String getTaskView(Submission task) {
    final views = task.billboardDetail?.views;

  
    final viewIndex = views?.indexWhere((view) => view == task.view);

    return '\nview: ${viewIndex! + 1}';
  }

  void tasks() async {
   final queryParams =
        selectedStatus.value != 'ALL' ? {'approval_statuss': selectedStatus.value} : null;
    final result = await request.send(
      url: '${baseUrl}monitoring/',
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
      print(response);
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
