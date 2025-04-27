import 'package:get/get.dart';

import '../controllers/submission_details_controller.dart';

class SubmissionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubmissionDetailsController>(
      () => SubmissionDetailsController(),
    );
  }
}
