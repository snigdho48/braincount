import 'package:get/get.dart';
import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:braincount/app/modules/home/controllers/home_controller.dart';
import 'package:braincount/app/modules/tasklist/controllers/tasklist_controller.dart';
import 'package:braincount/app/modules/withdraw/controllers/withdraw_controller.dart';
import 'package:braincount/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:braincount/app/modules/profile/controllers/profile_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavController());
    Get.put(HomeController());
    Get.put(TasklistController());
    Get.put(WithdrawController());
    Get.put(NotificationsController());
    Get.put(ProfileController());
  }
} 