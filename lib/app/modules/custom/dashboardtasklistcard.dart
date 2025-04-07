
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget tasklistCardDashboard({
  required String text,
  required VoidCallback onPressed,
  String? status,
}) {
  return Container(
    alignment: Alignment.center,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide.none,
        ),
        elevation: 3,
        padding: EdgeInsets.symmetric(horizontal: Get.width * .05,vertical: Get.width * .03),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: Get.width * .05,
            height: Get.width * .05,
            
            decoration: BoxDecoration(
              color: Colors.white,
              
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 218, 217, 225), // top light greyish purple
                  Color.fromARGB(255, 250, 251, 255), // bottom light grey/white
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
       
          ),
         Expanded(
      
           child: Padding(
             padding: EdgeInsets.only(left: Get.width * .07),
             child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    textWidthBasis: TextWidthBasis.parent,
                    style: TextStyle(
                      fontSize: Get.width * .04,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  status != null
                      ? Badge(
                          backgroundColor: status == 'Pending'
                              ? Colors.orange
                              : status == 'Accepted'
                                  ? Colors.green
                                  : Colors.red,
                          label: Text(
                            status,
                            style: TextStyle(
                              fontSize: Get.width * .03,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  Icon(Icons.arrow_forward_ios, color: Colors.black54,
                      size: Get.width * .05,),
                ],
             ),
           ),
         )
        ],
      ),
    ),
  );
}