import 'package:get/get.dart';
import 'package:tarot_app/pages/0_splash_page/splash_page.dart';
import 'package:tarot_app/routes/app_routes.dart';

import '../pages/1_page/initial_binding.dart';
import '../pages/1_page/initial_page.dart';
import '../pages/2_page/check_binding.dart';
import '../pages/2_page/check_page.dart';
import '../pages/4_page/result_binding.dart';
import '../pages/4_page/result_page.dart';
import '../pages/5_page/lucky_box_binding.dart';
import '../pages/5_page/lucky_box_page.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL_PAGE,
      page: () => InitialPage(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: Routes.CHECK_PAGE,
      page: () => CheckPage(),
      binding: CheckBinding(),
    ),
    GetPage(
      name: Routes.RESULT_PAGE,
      page: () => ResultPage(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: Routes.LUCKY_BOX_PAGE,
      page: () => LuckyBoxPage(),
      binding: LuckyBoxBinding(),
    ),
    GetPage(
      name: Routes.SPLASH_PAGE,
      page: () => const SplashPage(duration: 3)
    ),
  ];
}
