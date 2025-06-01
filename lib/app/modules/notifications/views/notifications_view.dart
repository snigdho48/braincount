import 'dart:convert';
import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: backgroundColorLinear(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Obx(() {
            if (controller.messages.isEmpty) {
              return Center(child: Text('No notifications yet.'));
            }
            return ListView.builder(
              padding: EdgeInsets.only(
                top: Get.height * .02,
                left: context.width * .05,
                right: context.width * .05,
              ),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final messageStr = controller.messages[index];
                Map<dynamic, dynamic> data;
                try {
                  data = messageStr;
                } catch (_) {
                  data = {"message": messageStr};
                }
                final isRead = data['is_read'] ?? true;
                final type = data['type'] ?? '';
                final createdAt = data['created_at'] ?? '';
                final message = data['message'] ?? messageStr;

                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: isRead
                        ? null
                        : Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(right: 8, top: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                    title: Text(
                      message,
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        if (type.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: EdgeInsets.only(right: 8, top: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (createdAt.isNotEmpty)
                          Text(
                            _formatDate(createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    onTap: () => controller.markAsRead(index),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')} '
          '${_monthName(dt.month)} ${dt.year}, '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
