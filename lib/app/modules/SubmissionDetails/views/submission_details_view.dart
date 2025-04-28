import 'package:braincount/app/data/constants.dart';
import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/camerbtn.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/map.dart';
import 'package:braincount/app/modules/custom/submissionImagePreview.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../controllers/submission_details_controller.dart';

class SubmissionDetailsView extends GetView<SubmissionDetailsController> {
  const SubmissionDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, back: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.getStatus();
          Get.bottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            Container(
              height: Get.height * 0.8,
              width: Get.width,
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05,
                vertical: Get.height * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Re-Submit',
                    style: TextStyle(
                      fontSize: Get.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: Get.height * .015,
                        children: [
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
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  width: Get.width * .9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    width: Get.width,
                                    child: MultiDropdown<String>(
                                      controller: controller
                                          .statusMultiSelectController.value,
                                      items: controller.statusList
                                          .map((status) => DropdownItem<String>(
                                              label: status, value: status ,selected: controller.selectedStatus.contains(status)
))
                                          .toList(),
                                      fieldDecoration: FieldDecoration(
                                        labelText: 'Billboard Status',
                                        border: OutlineInputBorder(),
                                      ),
                                      dropdownDecoration:
                                          const DropdownDecoration(
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
                            padding: EdgeInsets.symmetric(vertical: 12),
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
                                // want always border
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width:
                                        1, // Same thickness for focused state
                                  ),
                                ),
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
                                            (element) =>
                                                element['type'] == 'left')
                                        ? cameraButton(
                                            type: 'left',
                                            file: controller
                                                .navcontroller.imageList
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
                                                controller
                                                    .commentFocusNode.value
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
                                                backgroundColor:
                                                    Colors.transparent,
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                    controller.navcontroller.imageList.any(
                                            (element) =>
                                                element['type'] == 'right')
                                        ? cameraButton(
                                            type: 'right',
                                            file: controller
                                                .navcontroller.imageList
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
                                                controller
                                                    .commentFocusNode.value
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
                                                backgroundColor:
                                                    Color(0xFF4CAF50),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                    controller.navcontroller.imageList.any(
                                            (element) =>
                                                element['type'] == 'front')
                                        ? cameraButton(
                                            type: 'front',
                                            file: controller
                                                .navcontroller.imageList
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
                                                controller
                                                    .commentFocusNode.value
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
                                                backgroundColor:
                                                    Color(0xFF4CAF50),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                    controller.navcontroller.imageList.any(
                                            (element) =>
                                                element['type'] == 'close')
                                        ? cameraButton(
                                            type: 'close',
                                            file: controller
                                                .navcontroller.imageList
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
                                                controller
                                                    .commentFocusNode.value
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
                                                backgroundColor:
                                                    Color(0xFF4CAF50),
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

                          Obx(() => SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(
                                    top: Get.height * .02,
                                    bottom: Get.height * .02),
                                child: Row(
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
                                ),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // important to avoid overflow
          children: [
            // Icon(
            //   FontAwesomeIcons.paperPlane,
            //   color: Colors.white,
            //   size: Get.width * 0.06, // optional: size adjustment
            // ),
            // SizedBox(height: 4), // small gap between icon and text
            Text(
              'Re\nSubmit',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Get.width * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: backgroundColorLinear(
        child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: Get.height * .02,
                  left: context.width * .05,
                  right: context.width * .05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: Get.height * .015,
                children: [
                  Obx(() {
                    final data = controller.submissionData.value;

                    return Column(
                      spacing: 10,
                      children: [
                        Text(
                          data.billboardDetail?.title ?? 'Untitled',
                          style: TextStyle(
                              fontSize: Get.width * .05,
                              fontWeight: FontWeight.w300,
                              color: Colors.black87),
                        ),
                        SizedBox(
                          height: Get.width * 0.7,
                          child: Stack(
                            children: [
                              // Show the map only if coordinates are valid
                              if (data.billboardDetail?.latitude != 0 &&
                                  data.billboardDetail?.latitude != 0)
                                openStreetMap(coordinates: [
                                  {
                                    'lat': data.latitude!.toDouble(),
                                    'lon': data.longitude!.toDouble(),
                                  },
                                ]),
                              if (data.billboardDetail?.latitude == 0 &&
                                  data.billboardDetail?.longitude == 0)
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
                          ),
                        ),
                        Text(
                          'Submission Status :',
                          style: TextStyle(
                              fontSize: Get.width * .05,
                              fontWeight: FontWeight.w300,
                              color: Colors.black87),
                        ),
                        Badge(
                          padding: EdgeInsets.all(Get.width * .02),
                          backgroundColor: data.status == 'ACCEPTED'
                              ? Colors.green
                              : data.status == 'REJECTED'
                                  ? Colors.red
                                  : Colors.orange,
                          label: Text(
                            data.approvalStatus ?? 'UNKNOWN',
                            style: TextStyle(
                                fontSize: Get.width * .04,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        data.rejectReason != null &&
                                data.approvalStatus == 'REJECTED'
                            ? SizedBox(
                                height: Get.height * .02,
                              )
                            : SizedBox.shrink(),
                        data.rejectReason != null &&
                                data.approvalStatus == 'REJECTED'
                            ? Column(
                                children: [
                                  Text(
                                    'Reject Reason:',
                                    style: TextStyle(
                                        fontSize: Get.width * .05,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: Get.width * .87,
                                    child: Text(
                                      data.rejectReason.toString(),
                                      style: TextStyle(
                                          fontSize: Get.width * .04,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        data.rejectReason != null &&
                                data.approvalStatus == 'REJECTED'
                            ? SizedBox(
                                height: Get.height * .02,
                              )
                            : SizedBox.shrink(),
                        Text(
                          'Submitted Status:',
                          style: TextStyle(
                              fontSize: Get.width * .05,
                              fontWeight: FontWeight.w300,
                              color: Colors.black87),
                        ),
                        data.status != null
                            ? Container(
                                alignment: Alignment.center,
                                width: Get.width * .87,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 10,
                                    children: data.status!.map((status) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * .02,
                                            vertical: Get.height * .01),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF4CAF50),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                              fontSize: Get.width * .04,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: Get.height * .02,
                        ),
                        Text(
                          'Submitted Comment:',
                          style: TextStyle(
                              fontSize: Get.width * .05,
                              fontWeight: FontWeight.w300,
                              color: Colors.black87),
                        ),
                        Container(
                          alignment: data.comment == null
                              ? Alignment.center
                              : Alignment.centerLeft,
                          width: Get.width * .87,
                          child: Text(
                            data.comment != null
                                ? data.comment.toString()
                                : 'No comments available',
                            style: TextStyle(
                                fontSize: Get.width * .04,
                                fontWeight: FontWeight.w300,
                                color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * .02,
                        ),
                        Text(
                          'Submitted Images :',
                          style: TextStyle(
                              fontSize: Get.width * .05,
                              fontWeight: FontWeight.w300,
                              color: Colors.black87),
                        ),
                        Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: controller.images
                                .map(
                                  (element) => imagePreview(
                                      type: element['type'],
                                      image: baseUrl.split('/api')[0] +
                                          element['url'],
                                      controller: controller),
                                )
                                .toList()),
                        SizedBox(
                          height: Get.height * .03,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            )),
      ),
    );
  }
}
