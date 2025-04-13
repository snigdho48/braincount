import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
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
    final navcontroller = Get.put(NavController());
    return Scaffold(
        appBar: appBarWidget(context),
        bottomNavigationBar: CustomBottomNavigationBar(),
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
                          width: Get.width * .3,
                          height: Get.width * .3,
                          padding: EdgeInsets.only(top: Get.width * .02),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '5000',
                                style: TextStyle(
                                  fontSize: Get.width * .09,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0, -Get.width * .02),
                                child: Text(
                                  'TK',
                                  style: TextStyle(
                                    fontSize: Get.width * .07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
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
                              text: 'Widthdraw',
                              onPressed: () {
                                navcontroller.changeIndex(3);
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
                          Get.toNamed(Routes.PENDINGLIST);
                        },
                      ),
                      Stack(
                        children: [
                          dashboardCard(
                            text: 'Pending List',
                            image: 'assets/icon/list.png',
                            onPressed: () {
                              navcontroller.changeIndex(1);
                            },
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Obx(() {
                                return Center(
                                  child: Text(
                                    controller.pendingtask['pending'] != null && 
                                            controller.pendingtask['pending'] >0
                                        ? controller.pendingtask['pending'].toString()
                                        : '0',
                                    style: TextStyle(
                                      fontSize: Get.width * .03,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                     
                      dashboardCard(
                        text: 'Previous List',
                        image: 'assets/icon/list.png',

                        onPressed: () {
                          Get.toNamed(Routes.PREVIOUSLIST);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * .04),
                  child: Text(
                    'Task List',
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
                                    text: task['billboard_detail']?['title'] ??
                                        'Untitled',
                                    status: task['is_accepeted'] ?? 'UNKNOWN',
                                    onPressed: () => controller.opendialog,
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
