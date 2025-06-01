import 'package:braincount/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class NotificationsController extends GetxController {
  final request = oneRequest();
  final storage = GetStorage();
  final notifications = [].obs;
  late WebSocketChannel channel;
  var messages = <String>[].obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    messages.listen((_) => updateUnreadCount());
    getNotifications();
  }

  void getNotifications() async {
   final token = storage.read('token');


    try {
      channel = WebSocketChannel.connect(
        Uri.parse('wss://$url/ws/notifications/?token=$token'),
      );
      channel.stream.listen(
        (message) {
          print('message: $message');
          if (message is Map && message['type'] == 'all_notifications') {
            // This is the full list of previous notifications
            messages.clear();
            for (var notif in message['notifications']) {
              messages.add(notif);
            }
          } else if (message is Map) {
            // This is a real-time notification
            messages.insert(0, jsonEncode(message));
          }
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

void updateUnreadCount() {
    int count = 0;
    for (var msg in messages) {
      try {
        final data = msg is String ? jsonDecode(msg) : msg;
        if (data is Map && data['is_read'] == false) {
          count++;
        }
      } catch (_) {}
    }
    unreadCount.value = count;
  }

  void markAllAsRead() {
    for (int i = 0; i < messages.length; i++) {
      try {
        var data = jsonDecode(messages[i]);
        if (data is Map && data['is_read'] == false) {
          data['is_read'] = true;
          messages[i] = jsonEncode(data);
        }
      } catch (_) {}
    }
    updateUnreadCount();
  }

  void markAsRead(int index) {
    try {
      var data = jsonDecode(messages[index]);
      if (data is Map && data['is_read'] == false) {
        data['is_read'] = true;
        messages[index] = jsonEncode(data);
        updateUnreadCount();
      }
    } catch (_) {}
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
