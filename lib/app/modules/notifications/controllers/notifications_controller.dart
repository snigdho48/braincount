import 'package:braincount/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:one_request/one_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:braincount/app/services/notification_service.dart';

class NotificationsController extends GetxController {
  final request = oneRequest();
  final storage = GetStorage();
  final notifications = [].obs;
  late WebSocketChannel channel;
  var messages = <Map<dynamic, dynamic>>[].obs;
  var unreadCount = 0.obs;
  final isRunning = false.obs;

  @override
  void onInit() {
    super.onInit();
    messages.listen((_) => updateUnreadCount());
    if (!isRunning.value) {
      isRunning.value = true;
      getNotifications();
    }
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
          dynamic decoded;
          try {
            decoded = jsonDecode(message);
          } catch (e) {
            print('Failed to decode message: $e');
            return;
          }
          if (decoded is Map && decoded['type'] == 'all_notifications') {
            // This is the full list of previous notifications
            messages.clear();
            if (decoded['notifications'] is List) {
              messages.addAll(List<Map<dynamic, dynamic>>.from(decoded['notifications']));
            }
            print('messages: $messages');
          } else if (decoded is Map) {
            // This is a real-time notification
            messages.insert(0, decoded);
            print('message2: $decoded');
            // Show local notification
            showNotification(decoded['title']?.toString() ?? 'New Notification', decoded['body']?.toString() ?? 'You have a new notification');
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
        final data = msg;
        if ( data['is_read'] == false) {
          count++;
        }
      } catch (_) {}
    }
    unreadCount.value = count;
  }

  void markAllAsRead() {
    for (int i = 0; i < messages.length; i++) {
      try {
        var data = messages[i];
        if ( data['is_read'] == false) {
          data['is_read'] = true;
          messages[i] = data;
        }
      } catch (_) {}
    }
    updateUnreadCount();
  }

  void markAsRead(int index) {
    try {
      var data =messages[index];
      if (data['is_read'] == false) {
        data['is_read'] = true;
        messages[index] = data;
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
