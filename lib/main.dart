import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {

  var getMaterialApp = GetMaterialApp(
    theme: ThemeData(useMaterial3: true),
    getPages: AppPages.pages,
    initialRoute: Routes.SPLASH_PAGE,
  );
  runApp(getMaterialApp);
}

