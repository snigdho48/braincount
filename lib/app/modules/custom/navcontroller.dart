// lib/app/controllers/nav_controller.dart
import 'package:get/get.dart';

class NavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
