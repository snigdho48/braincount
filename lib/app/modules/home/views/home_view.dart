import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/custom/bottomnav.dart';
import 'package:braincount/app/modules/custom/custombg.dart';
import 'package:braincount/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:braincount/app/modules/custom/floatingButton.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      floatingActionButton: FloatingButton(),
         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
         floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

      bottomNavigationBar: CustomBottomNavigationBar(),
      body: backgroundColorLinear(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: (){
              Get.toNamed(Routes.LOGIN);
            }, child: Text('Login'))
          ],
        ),
      )
    );
  }
}
