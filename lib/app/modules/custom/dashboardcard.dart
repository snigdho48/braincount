import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dashboardCard({
  required String text,
  IconData? icon,
  String? image,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      padding: EdgeInsets.zero,
      elevation: 4,
    ),
    child: Container(
      alignment: Alignment.center,
      width: Get.width /3.5,
      height: Get.width /3.4,
      child: Column(        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon != null
              ? Icon(
            icon,
            color: Colors.black54,
            size: Get.width * .05,
          )
              : image != null
                  ? Image.asset(
                      image,
                      width: Get.width * .1,
                      height: Get.width * .1,
                    )
                  : SizedBox(),
          Text(
            text.split(' ').first,
            textAlign: TextAlign.center ,
            softWrap: true,
            overflow: TextOverflow.visible,
            textWidthBasis: TextWidthBasis.parent,
            style: TextStyle(fontSize: Get.width * .06, fontWeight: FontWeight.w300, color: Colors.black87),
          ),
           Text(
            text.split(' ').last,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.visible,
            textWidthBasis: TextWidthBasis.parent,
            style: TextStyle(
                fontSize: Get.width * .05,
                fontWeight: FontWeight.w300,
                color: Colors.black87),
          ),
      
        ],
      ),
    ),
  );
}