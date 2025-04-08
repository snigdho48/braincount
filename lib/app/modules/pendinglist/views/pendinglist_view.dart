import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/dashboardtasklistcard.dart';
import 'package:braincount/app/modules/custom/floatingButton.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pendinglist_controller.dart';

class PendinglistView extends GetView<PendinglistController> {
  const PendinglistView({super.key});
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
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    tasklistCardDashboard(
                        text: 'Billboard1 at Gulshan',
                        onPressed: controller.opendialog,
                        status: 'Pending'),
                    SizedBox(
                      height: Get.height * .03,
                    ),
                  ],
                ),
              ))),
    );
  }
}
