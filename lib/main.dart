import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {

  var getMaterialApp = GetMaterialApp(
    getPages: AppPages.pages,
    initialRoute: Routes.INITIAL_PAGE,
  );
  runApp(getMaterialApp);
}

