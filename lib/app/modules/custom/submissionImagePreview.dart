import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget imagePreview({
  required String type,
  required String image,
  required controller,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Stack(
        children: [
          InkWell(
            onTap: () {
              controller.preview(image, type);
            },
            child: Container(
              margin: EdgeInsets.only(right: Get.width * 0.02),
              padding: EdgeInsets.only(top: 8),
              child: Image.network(
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
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
