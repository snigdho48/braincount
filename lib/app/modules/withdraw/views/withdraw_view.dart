import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/withdraw_controller.dart';

class WithdrawView extends GetView<WithdrawController> {
  const WithdrawView({super.key});
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
