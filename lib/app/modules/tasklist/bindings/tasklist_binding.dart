import 'package:get/get.dart';

import '../controllers/tasklist_controller.dart';

class TasklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasklistController>(
      () => TasklistController(),
    );
  }
}
