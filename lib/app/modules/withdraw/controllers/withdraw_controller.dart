import 'package:braincount/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';

class WithdrawController extends GetxController {
  final request = oneRequest();
  final storage = GetStorage();
  final withdrawals = [].obs;
  final withdraws = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getWithdrawals();
  }

  void getWithdrawals() async {
    final result = await request.send(
      url: '${baseUrl}withdraw/',
      method: RequestType.GET,
      resultOverlay: false,
      header: {
        'Authorization': 'Bearer ${storage.read('token')}',
      },
    );
    result.fold((response) {
      print('Withdrawals: $response');
      withdraws.clear();
      withdrawals.clear();
      withdrawals.addAll(response['withdrawals'] ?? []);
      withdraws.value = {
        'completed_tasks': response['completed_tasks'],
        'pending_tasks': response['pending_tasks'],
        'rejected_tasks': response['rejected_tasks'],
        'total_pending_amount': response['total_pending_amount'],
        'total_amount': response['total_amount'],
        'total_withdrawable_amount': response['total_withdrawable_amount'],
        'withdrwal_amount_per_task': response['withdrwal_amount_per_task'],

      };
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
