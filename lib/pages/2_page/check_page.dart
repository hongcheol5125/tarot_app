import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_app/pages/1_page/initial_page.dart';
import 'package:tarot_app/routes/app_routes.dart';
import 'check_controller.dart';

class CheckPage extends GetWidget<CheckController> {
  const CheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.toNamed(Routes.INITIAL_PAGE);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [Text('check Page')],
      ),
    );
  }
}
