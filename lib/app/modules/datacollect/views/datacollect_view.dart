import 'dart:io';

import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/floatingButton.dart';
import 'package:braincount/app/modules/custom/map.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/datacollect_controller.dart';

class DatacollectView extends GetView<DatacollectController> {
  const DatacollectView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, back: true),
      floatingActionButton: FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: backgroundColorLinear(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: Get.height * .02,
                    left: context.width * .05,
                    right: context.width * .05),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: Get.height * .015,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Billboard1 at Gulshan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.width * 0.7,
                        child: Obx(() {
                          // Check if coordinates are valid and not zero or missing
                          bool isCoordinatesValid = controller.lat.value != 0 &&
                              controller.lon.value != 0;
            
                          return Stack(
                            children: [
                              // Show the map only if coordinates are valid
                              if (isCoordinatesValid)
                                openStreetMap(coordinates: [
                                  {
                                    'lat': controller.lat.value,
                                    'lon': controller.lon.value,
                                  },
                                  {
                                    'lat':
                                        23.8103, // Default coordinates (Dhaka, Bangladesh)
                                    'lon': 90.4125,
                                  }
                                ]),
                              // Show a loading indicator if coordinates are not valid
                              if (!isCoordinatesValid)
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 10),
                                      Text(
                                        'Loading map...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
       Row(
                        children: [
                          // Billboard status with DropdownButton
                          Container(
                            padding: EdgeInsets.all(12),
                            width: Get.width*.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              
                            ),
                            child: Obx(() {
                              return SizedBox(
                                // Replace Expanded with SizedBox
                                width: 200, // Set the desired width
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: Colors.white,
                                  value: controller.selectedStatus.value,
                                  items: controller.statusList
                                      .map((String status) {
                                    return DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null &&
                                        controller.statusList
                                            .contains(newValue)) {
                                      controller.selectedStatus.value =
                                          newValue;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Billboard Status',
                                    border: OutlineInputBorder(),
                                    ),
                                  ),
                              
                              );
                            }),
                          ),
                        ],
                      ),
                     Container(
                        padding: EdgeInsets.all(12),
                        width: Get.width*.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                        child: TextField(
                          minLines: 3,
                          maxLines: 5,
                          controller: controller.commentController.value,
                          decoration: InputDecoration(
                            labelText: 'Comment',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                              color: Colors.black,
                              
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                       
                     SizedBox(
                        width: Get.width * .9,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Obx(() => Row(
                                children: controller.imageList.map((xfile) {
                                  print(xfile.path);
                                  return Container(
                                    margin: EdgeInsets.only(
                                        right: Get.width * 0.02),
                                    child: Image.file(
                                      File(xfile.path), // Convert XFile to File
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              )),
                        ),
                      )

                  
                    
                    ])),
        
         
              
          ],
        ),
      )),
    );
  }
}
