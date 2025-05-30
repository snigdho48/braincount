import 'package:get/get.dart';

import '../modules/SUBMISSIONLIST/bindings/SUBMISSIONLIST_binding.dart';
import '../modules/SUBMISSIONLIST/views/SUBMISSIONLIST_view.dart';
import '../modules/SubmissionDetails/bindings/submission_details_binding.dart';
import '../modules/SubmissionDetails/views/submission_details_view.dart';
import '../modules/datacollect/bindings/datacollect_binding.dart';
import '../modules/datacollect/views/datacollect_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/tasklist/bindings/tasklist_binding.dart';
import '../modules/tasklist/views/tasklist_view.dart';
import '../modules/withdraw/bindings/withdraw_binding.dart';
import '../modules/withdraw/views/withdraw_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.TASKLIST,
      page: () => const TasklistView(),
      binding: TasklistBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SUBMISSIONLIST,
      page: () => const SubmissionlistView(),
      binding: SubmissionListBinding(),
    ),
    GetPage(
      name: _Paths.DATACOLLECT,
      page: () => const DatacollectView(),
      binding: DatacollectBinding(),
    ),
    GetPage(
      name: _Paths.WITHDRAW,
      page: () => const WithdrawView(),
      binding: WithdrawBinding(),
    ),
    GetPage(
      name: _Paths.SUBMISSION_DETAILS,
      page: () => const SubmissionDetailsView(),
      binding: SubmissionDetailsBinding(),
    ),
  ];
}
