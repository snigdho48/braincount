import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:braincount/app/modules/home/views/home_view.dart';
import 'package:braincount/app/modules/tasklist/views/tasklist_view.dart';
import 'package:braincount/app/modules/withdraw/views/withdraw_view.dart';
import 'package:braincount/app/modules/notifications/views/notifications_view.dart';
import 'package:braincount/app/modules/profile/views/profile_view.dart';
import 'package:braincount/app/modules/custom/appbar.dart';

class MainNavigationView extends GetView<NavController> {
  const MainNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: const [
          HomeView(),
          TasklistView(),
          WithdrawView(),
          NotificationsView(),
          ProfileView(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
        backgroundColor: Colors.white,
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedIconTheme: const IconThemeData(size: 24),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Balance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
} 