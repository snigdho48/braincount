import 'package:braincount/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NotificationsController extends GetxController {
  final request = oneRequest();
  final storage = GetStorage();
  final notifications = [].obs;
  late WebSocketChannel channel;
  var messages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();

    
  }

  void getNotifications() async {
   final token = storage.read('token');
   return;

    try {
      channel = WebSocketChannel.connect(
        Uri.parse('${wsUrl}notifications/?token=$token'),
      );
      channel.stream.listen(
        (message) {
          messages.add(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          Future.microtask(() {
            Get.snackbar(
              'WebSocket Error',
              error.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          });
        },
        onDone: () {
          print('WebSocket closed');
        },
        cancelOnError: true, // This will close the stream on error
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      Future.microtask(() {
        Get.snackbar(
          'WebSocket Connect Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    channel.sink.close();
    super.onClose();
  }
}
