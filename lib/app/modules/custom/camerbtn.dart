import 'dart:io';

import 'package:braincount/app/modules/datacollect/controllers/datacollect_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget cameraButton(
    {required String type,
    required XFile file,
    required DatacollectController controller}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Stack(
        children: [
          InkWell(
            onTap: () {
              controller.preview(file, type);
            },
            child: Container(
              margin: EdgeInsets.only(right: Get.width * 0.02),
              padding: EdgeInsets.only(top: 8),
              child: Image.file(
                File(file.path),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 16,
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  controller.navcontroller.removeImage(type);
                },
              ),
            ),
          )
        ],
      ),
      Text(
          type
              .split(
                  RegExp(r'[_\s-]+')) // split on underscores, spaces, or dashes
              .map((word) => word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '')
              .join(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    ],
  );
}
