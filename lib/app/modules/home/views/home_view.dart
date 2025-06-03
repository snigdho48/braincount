import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/dashboardcard.dart';
import 'package:braincount/app/modules/custom/dashboardtasklistCard.dart';
import 'package:braincount/app/modules/custom/dashoardbtn.dart';
import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    // Set the app bar title when this page is built
    final navcontroller = Get.find<NavController>();
    return Scaffold(
        appBar: appBarWidget(context),
        body: backgroundColorLinear(
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: Get.height * .02),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: Get.width / 2,
                        child: Container(
                          margin: EdgeInsets.only(left: Get.width * .02),
                          width: Get.width * .39,
                          height: Get.width * .3,
                          padding: EdgeInsets.only(left: Get.width * .03),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: Offset(0, 4),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 228, 227,
                                    236), // top light greyish purple
                                Color(0xFFF6F7F9), // bottom light grey/white
                              ],
                            ),
                          ),
                          child: Obx(
                            ()=> Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: Get.height * .007,
                              
                              children: [
                                Text(
                                  'Task Summary',
                                  style: TextStyle(
                                    fontSize: Get.width * .035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Completed: ${controller.withdraws['completed_tasks'] ?? 0}',
                                  style: TextStyle(
                                    fontSize: Get.width * .035,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Pending: ${controller.withdraws['pending_tasks'] ?? 0}',
                                  style: TextStyle(
                                    fontSize: Get.width * .035,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Rejected: ${controller.withdraws['rejected_tasks'] ?? 0}',
                                  style: TextStyle(
                                    fontSize: Get.width * .035,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            dashboardbtn(
                              text: 'Balance History',
                              onPressed: () {
                                navcontroller.changeIndex(2);
                              },
                            ),
                            dashboardbtn(
                              text: 'Profile',
                              onPressed: () {
                                navcontroller.changeIndex(4);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * .04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      dashboardCard(
                        text: 'Task List',
                        image: 'assets/icon/list.png',
                        onPressed: () {
                          navcontroller.changeIndex(1);
                        },
                      ),
                      dashboardCard(
                        text: 'Submission List',
                        image: 'assets/icon/list.png',
                        onPressed: () {
                          Get.toNamed(Routes.SUBMISSIONLIST);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * .04),
                  child: Text(
                    'Pending Task List',
                    style: TextStyle(
                      fontSize: Get.width * .06,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
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
                                    text: task['billboard_detail']?['title'] + controller.getTaskView(task) ?? 'Untitled',
                                    status: task['is_accepeted'] ?? 'PENDING',
                                    onPressed: () => controller.opendialog(
                                        uuid: task['uuid']),
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
              ],
            ),
          ),
        ));
  }
}
