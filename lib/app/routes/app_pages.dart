import 'package:get/get.dart';

import '../modules/datacollect/bindings/datacollect_binding.dart';
import '../modules/datacollect/views/datacollect_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/pendinglist/bindings/pendinglist_binding.dart';
import '../modules/pendinglist/views/pendinglist_view.dart';
import '../modules/previouslist/bindings/previouslist_binding.dart';
import '../modules/previouslist/views/previouslist_view.dart';
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
      page: () => const HomeView(),
      binding: HomeBinding(),
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
      name: _Paths.PENDINGLIST,
      page: () => const PendinglistView(),
      binding: PendinglistBinding(),
    ),
    GetPage(
      name: _Paths.PREVIOUSLIST,
      page: () => const PreviouslistView(),
      binding: PreviouslistBinding(),
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
  ];
}
