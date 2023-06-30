import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tarot_app/firebase_options.dart';
import 'package:tarot_app/services/local_data_service.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put<LocalDataService>(LocalDataService(), permanent: true); //

  var getMaterialApp = GetMaterialApp(
    theme: ThemeData(useMaterial3: true),
    getPages: AppPages.pages,
    initialRoute: Routes.SPLASH_PAGE,
  );
  runApp(getMaterialApp);
}
