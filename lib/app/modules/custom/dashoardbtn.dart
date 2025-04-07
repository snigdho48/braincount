import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dashboardbtn({required String text,required VoidCallback onPressed}) {
  return Container(
                                alignment: Alignment.center,
                               
                                margin: EdgeInsets.only(right: Get.width * .07),
                                child:
    ElevatedButton(onPressed: onPressed, 
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(color: Colors.black54),
      ),
      
      elevation: 3,
      padding: EdgeInsets.symmetric(horizontal:  Get.width * .05),
    ),
    child: 
     Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,textAlign: TextAlign.center,softWrap: true, style: TextStyle(fontSize: Get.width * .035, fontWeight: FontWeight.w300,color: Colors.black87),),
          Icon(Icons.arrow_forward_ios, color: Colors.black54)
        ],
      ),
    ),
    );
}