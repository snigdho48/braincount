import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:braincount/app/modules/custom/navcontroller.dart';
import 'package:braincount/app/modules/home/views/home_view.dart';
import 'package:braincount/app/modules/tasklist/views/tasklist_view.dart';
import 'package:braincount/app/modules/withdraw/views/withdraw_view.dart';
import 'package:braincount/app/modules/notifications/views/notifications_view.dart';
import 'package:braincount/app/modules/profile/views/profile_view.dart';
import 'package:braincount/app/modules/custom/appbar.dart';
import 'package:braincount/app/modules/notifications/controllers/notifications_controller.dart';

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
      bottomNavigationBar: Obx(() {
        final unreadCount = Get.find<NotificationsController>().unreadCount.value;
        return BottomNavigationBar(
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
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: 'Tasks',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Balance',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications),
                  if (unreadCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Notifications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
} 