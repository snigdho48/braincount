

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget backgroundColorLinear({required Widget child}) {
  return Container(
    height: Get.height,
    width: Get.width,
    decoration:  BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/image/bg.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: SingleChildScrollView(
      child: child,
    ),
  );
}