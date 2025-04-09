import 'dart:io';
import 'dart:math';

import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
import 'package:braincount/app/modules/custom/camerbtn.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/map.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/datacollect_controller.dart';

class DatacollectView extends GetView<DatacollectController> {
  const DatacollectView({super.key});
  @override
  Widget build(BuildContext context) {
    // final navcontroller = Get.put(NavController());
    // controller.navcontroller.imageList.clear();
    return Scaffold(
      appBar: appBarWidget(context, back: true),

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
                            width: Get.width * .9,
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
                        width: Get.width * .9,
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
                      Text('Take The Photos:',
                          style: TextStyle(
                            fontSize: Get.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      Obx(() => SizedBox(
                            width: Get.width * 0.9,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 10,
                                children: [
                                  controller.navcontroller.imageList.any(
                                    (element) =>
                                        element['type'] == 'left'
                                  )?cameraButton(
                                    type:'left',
                                    file: controller.navcontroller.imageList
                                        .firstWhere(
                                            (element) => element['type'] == 'left')
                                        ['file'],
                                      controller: controller,
                                  ):SizedBox(
                                    width: 100,
                                    height: 100,

                                    child: ElevatedButton(onPressed: (){
                                      controller.navcontroller.opencamera(type:
                                          'left');
                                    }, child: Text('Left',
                                      style: TextStyle(
                                        fontSize: Get.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF4CAF50),
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),

                                   controller.navcontroller.imageList.any(
                                        (element) => element['type'] == 'right')
                                    ? cameraButton(
                                        type: 'right',
                                        file: controller.navcontroller.imageList
                                            .firstWhere((element) =>
                                                element['type'] ==
                                                'right')['file'],
                                        controller: controller,
                                      )
                                    : SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller.navcontroller
                                                .opencamera(type: 'right');
                                          },
                                          child: Text('right',
                                              style: TextStyle(
                                                fontSize: Get.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF4CAF50),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),

                                       controller.navcontroller.imageList.any(
                                        (element) => element['type'] == 'front')
                                    ? cameraButton(
                                        type: 'front',
                                        file: controller.navcontroller.imageList
                                            .firstWhere((element) =>
                                                element['type'] ==
                                                'front')['file'],
                                        controller: controller,
                                      )
                                    : SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller.navcontroller
                                                .opencamera(type: 'front');
                                          },
                                          child: Text('Front',
                                              style: TextStyle(
                                                fontSize: Get.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF4CAF50),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                       controller.navcontroller.imageList.any(
                                        (element) => element['type'] == 'close')
                                    ? cameraButton(
                                        type: 'close',
                                        file: controller.navcontroller.imageList
                                            .firstWhere((element) =>
                                                element['type'] ==
                                                'close')['file'],
                                        controller: controller,
                                      )
                                    : SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller.navcontroller
                                                .opencamera(type: 'close');
                                          },
                                          child: Text('Close',
                                              style: TextStyle(
                                                fontSize: Get.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF4CAF50),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                ]
                              ),
                            ),
                          )),

                      //submit button
                      SizedBox(
                        width: Get.width * .9,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Submit',
                              style: TextStyle(
                                fontSize: Get.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ])),
          ],
        ),
      )),
    );
  }
}
