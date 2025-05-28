import 'dart:io';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget backgroundColorLinear({required Widget child}) {
  return PopScope(
    canPop: false,
    onPopInvoked: (didPop) async {
      if (didPop) return;

      if (Get.overlayContext != null && Navigator.of(Get.overlayContext!).canPop()) {
        Get.back();
      } else {
        // Show dialog before exiting app
        final shouldExit = await showDialog<bool>(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('Exit Application'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to exit?',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Any unsaved changes will be lost.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Exit'),
                ),
              ],
            ),
          ),
        );

        if (shouldExit == true) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }
      }
    },
    child: Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    ),
  );
}
