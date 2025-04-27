import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/camerbtn.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/map.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

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
                      Obx(
                        () => Container(
                          alignment: Alignment.center,
                          child: Text(
                            controller.updatedmodel.value?.billboardDetail
                                    ?.title ??
                                '',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.width * 0.7,
                        child: Obx(() {
                          // Check if coordinates are valid and not zero or missing
                          bool isCoordinatesValid = controller.lat.value != 0 &&
                              controller.lon.value != 0 &&
                              controller.updatedmodel.value?.billboardDetail
                                      ?.latitude !=
                                  0 &&
                              controller.updatedmodel.value?.longitude != 0;

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
                                    'lat': controller.updatedmodel.value
                                            ?.billboardDetail?.latitude ??
                                        0, // Default coordinates (Dhaka, Bangladesh)
                                    'lon': controller.updatedmodel.value
                                            ?.billboardDetail?.longitude ??
                                        0,
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
                      Obx(() {
                        if (controller.statusList.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Row(
                          children: [
                            // Billboard status with DropdownButton
                            Container(
                              padding: EdgeInsets.all(12),
                              width: Get.width * .9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: 200,
                                child: MultiDropdown<String>(
                                  controller: controller
                                      .statusMultiSelectController.value,
                                  items: controller.statusList
                                      .map((status) => DropdownItem<String>(
                                          label: status, value: status))
                                      .toList(),
                                  fieldDecoration: FieldDecoration(
                                    labelText: 'Billboard Status',
                                    border: OutlineInputBorder(),
                                  ),
                                  dropdownDecoration: const DropdownDecoration(
                                    maxHeight: 300,
                                  ),
                                  chipDecoration: const ChipDecoration(
                                    backgroundColor: Colors.blueAccent,
                                    wrap: true,
                                  ),
                                  onSelectionChange: (selectedItems) {
                                    // Save selected statuses as list of strings
                                    controller.selectedStatus.value =
                                        selectedItems
                                            .map((item) => item)
                                            .toList();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select at least one status';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
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
                          focusNode: controller.commentFocusNode.value,
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
                              child: Row(spacing: 10, children: [
                                controller.navcontroller.imageList.any(
                                        (element) => element['type'] == 'left')
                                    ? cameraButton(
                                        type: 'left',
                                        file: controller.navcontroller.imageList
                                            .firstWhere((element) =>
                                                element['type'] ==
                                                'left')['file'],
                                        controller: controller,
                                      )
                                    : SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller.navcontroller
                                                .opencamera(type: 'left');
                                            controller.commentFocusNode.value
                                                .unfocus();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: Image.asset(
                                                'assets/image/left.jpeg',
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              ).image),
                                              color: Color(0xFF4CAF50),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(0xFF4CAF50),
                                                width: 5,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                            controller.commentFocusNode.value
                                                .unfocus();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: Image.asset(
                                                'assets/image/right.jpeg',
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              ).image),
                                              color: Color(0xFF4CAF50),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(0xFF4CAF50),
                                                width: 5,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF4CAF50),
                                            padding: EdgeInsets.zero,
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
                                            controller.commentFocusNode.value
                                                .unfocus();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: Image.asset(
                                                'assets/image/front.jpeg',
                                                fit: BoxFit.cover,
                                                width: 100,
                                              ).image),
                                              color: Color(0xFF4CAF50),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(0xFF4CAF50),
                                                width: 5,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF4CAF50),
                                            padding: EdgeInsets.zero,
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
                                            controller.commentFocusNode.value
                                                .unfocus();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: Image.asset(
                                                'assets/image/close.jpeg',
                                                fit: BoxFit.fitWidth,
                                                width: 100,
                                              ).image),
                                              color: Color(0xFF4CAF50),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(0xFF4CAF50),
                                                width: 5,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF4CAF50),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                              ]),
                            ),
                          )),

                      Obx(() => Row(
                            children: controller.navcontroller.imageList
                                .where((e) =>
                                    e['type'] != 'close' &&
                                    e['type'] != 'front' &&
                                    e['type'] != 'right' &&
                                    e['type'] != 'left')
                                .toList()
                                .map((entry) {
                              if (entry['file'] == null) {
                                return SizedBox.shrink();
                              }
                              return cameraButton(
                                type: entry['type'],
                                file: entry['file'],
                                controller: controller,
                              );
                            }).toList(),
                          )),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            var length = controller.navcontroller.imageList
                                .where((e) =>
                                    e['type'] != 'close' &&
                                    e['type'] != 'front' &&
                                    e['type'] != 'right' &&
                                    e['type'] != 'left')
                                .toList()
                                .length;

                            controller.navcontroller
                                .opencamera(type: 'extra_${length + 1}');
                            controller.commentFocusNode.value.unfocus();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF4CAF50),
                                width: 5,
                              ),
                            ),
                            child: Text('Add More',
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                      //submit button
                      SizedBox(
                        width: Get.width * .9,
                        child: ElevatedButton(
                          onPressed: controller.postData,
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
