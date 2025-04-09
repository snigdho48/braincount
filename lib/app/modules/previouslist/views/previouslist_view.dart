import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/modules/custom/dashboardtasklistcard.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/previouslist_controller.dart';

class PreviouslistView extends GetView<PreviouslistController> {
  const PreviouslistView({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(context, back: true),
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
                        status: 'Accepted',
                        text: 'Billboard1 at Gulshan',
                        onPressed: () {
                          Get.toNamed(Routes.DATACOLLECT);
                        }),
                    tasklistCardDashboard(
                        status: 'Rejected',
                        text: 'Billboard1 at Gulshan',
                        onPressed: () {
                          Get.toNamed(Routes.DATACOLLECT);
                        }),
                    SizedBox(
                      height: Get.height * .03,
                    ),
                  ],
                ),
              )),
        ));
  }
}
