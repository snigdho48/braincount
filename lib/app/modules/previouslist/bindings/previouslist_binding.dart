import 'package:get/get.dart';

import '../controllers/previouslist_controller.dart';

class PreviouslistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreviouslistController>(
      () => PreviouslistController(),
    );
  }
}
