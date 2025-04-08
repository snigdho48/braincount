import 'package:get/get.dart';

import '../controllers/datacollect_controller.dart';

class DatacollectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatacollectController>(
      () => DatacollectController(),
    );
  }
}
