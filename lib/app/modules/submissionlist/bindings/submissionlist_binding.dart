import 'package:braincount/app/modules/submissionlist/controllers/submissionlist_controller.dart';
import 'package:get/get.dart';

class SubmissionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubmissionListController>(
      () => SubmissionListController(),
    );
  }
}
