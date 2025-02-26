import 'package:flutter/material.dart';
import 'package:get/get.dart';

PreferredSize appBarWidget(BuildContext context) {
  var isSubroute = Get.currentRoute.split('/').length > 2;

  return PreferredSize(
    
    preferredSize:
        Size(Get.width, kToolbarHeight + MediaQuery.of(context).padding.top),
    child: Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      
      
      decoration: BoxDecoration(
       image: DecorationImage(image: 
       AssetImage('assets/image/bgtop.png'),
        fit: BoxFit.cover,
        ),
        
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(builder: (context) {
            if(!isSubroute) return SizedBox(width: Get.width*.1,);
            return IconButton(
              icon: Icon( Icons.arrow_back),
              onPressed: () {
                  Get.back();
                
              },
            );
          }),
          // Displaying the current route with first letter capitalized for each word
          Text(
            Get.currentRoute
                .substring(1)
                .split('/')
                .map((word) => word.isNotEmpty
                    ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                    : '')
                .join(' - '),
            style: TextStyle(fontSize: 20),
          ),
          // Notifications IconButton
          Builder(builder: (context) {
            return IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Open end drawer for notifications
            
            },
          );
          }),
        ],
      ),
    ),
  );
}
