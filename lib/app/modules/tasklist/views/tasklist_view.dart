import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
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
      bottomNavigationBar: CustomBottomNavigationBar(),
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
                    final data = controller.pendingtask;

                    // Null or structure check
                    if (data.isEmpty || data['monitoring'] == null) {
                      return const Center(
                          child: Text("No monitoring data available."));
                    }

                    List monitoring = data['monitoring'];

                    return Column(
                      spacing: 10,
                      children: monitoring
                          .map<Widget>((task) => tasklistCardDashboard(
                                text: task['billboard_detail']?['title'] ??
                                    'Untitled',
                                status: task['is_accepeted'] ?? 'UNKNOWN',
                                onPressed: () =>
                                    task['is_accepeted'] == 'ACCEPTED'
                                        ? Get.toNamed(Routes.DATACOLLECT,
                                            arguments: task['uuid'])
                                        : task['is_accepeted'] == 'PENDING'
                                            ? controller.opendialog(
                                                uuid: task['uuid'])
                                            : null,
                              ))
                          .toList(),
                    );
                  }),
                  SizedBox(
                    height: Get.height * .03,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
