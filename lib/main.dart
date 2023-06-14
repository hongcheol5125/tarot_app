import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tarot_app/firebase_options.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await GetStorage.init();
  var getMaterialApp = GetMaterialApp(
    theme: ThemeData(useMaterial3: true),
    getPages: AppPages.pages,
    initialRoute: Routes.SPLASH_PAGE,
  );
  runApp(getMaterialApp);
}
