import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/dashboardtasklistcard.dart';
import 'package:braincount/app/modules/submissionlist/controllers/submissionlist_controller.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SubmissionlistView extends GetView<SubmissionListController> {
  const SubmissionlistView({super.key});
  Widget build(BuildContext context) {
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
                        top: Get.height * .09,
                        left: context.width * .05,
                        right: context.width * .05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: Get.height * .015,
                      children: [
                        Obx(() {
                          final data = controller.pendingtask
                              .where((task) => task.approvalStatus != null)
                              .toList();
                          // Null or structure check
                          if (data.isEmpty) {
                            return const Center(
                                child: Text("No monitoring data available."));
                          }
                  
                          return Column(
                            spacing: 10,
                            children: data
                                .map<Widget>((task) => tasklistCardDashboard(
                                    text: task.billboardDetail?.title ?? 'Untitled',
                                    status: task.approvalStatus ?? 'UNKNOWN',
                                    onPressed: () => Get.toNamed(
                                        Routes.SUBMISSION_DETAILS,
                                        arguments: task)))
                                .toList(),
                          );
                        }),
                        SizedBox(
                          height: Get.height * .03,
                        ),
                      ],
                    ),
                  ),
                    Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      width: Get.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                        // Replace Expanded with SizedBox
                        width: Get.width * .9, // Set the desired width
                        child: DropdownButtonFormField(
                          dropdownColor: Colors.white,
                          autofocus: true,
                          value: controller.selectedStatus.value,
                          items: controller.statusList.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null &&
                                controller.statusList.contains(newValue)) {
                              controller.selectedStatus.value =
                                  newValue.toString();
                            }
                            controller.tasks();
                          },
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
