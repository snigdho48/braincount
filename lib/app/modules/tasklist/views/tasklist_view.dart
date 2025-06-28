import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/dashboardtasklistCard.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tasklist_controller.dart';

class TasklistView extends GetView<TasklistController> {
  const TasklistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: backgroundColorLinear(
        child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      top: Get.height * .11,
                      left: context.width * .05,
                      right: context.width * .05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: Get.height * .015,
                    children: [
                         
                      Obx(() {
                        final data = controller.pendingtask;

                        // Null or structure check
                        if (data.isEmpty ||
                            data['monitoring'] == null ||
                            data['monitoring'].length == 0) {
                          // Handle the case when data is null or empty
                          return Container(
                              alignment: Alignment.center,
                              height: Get.height * .6,
                              child: Text("No monitoring data available."));
                        }

                        List monitoring = data['monitoring'];

                        return Column(
                          spacing: 10,
                          children: monitoring
                              .map<Widget>((task) => tasklistCardDashboard(
                                    text: task['billboard_detail']?['title'] + controller.getTaskView(task) ??
                                        'Untitled',
                                    status:  task['is_accepeted']  ?? 'UNKNOWN',
                                    onPressed: () =>
                                        controller.getDetails(task)
                                  ))
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
      ),
    );
  }
}
