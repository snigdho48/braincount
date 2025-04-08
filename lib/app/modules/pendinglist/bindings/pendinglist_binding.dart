import 'package:get/get.dart';

import '../controllers/pendinglist_controller.dart';

class PendinglistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PendinglistController>(
      () => PendinglistController(),
    );
  }
}
