import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:tarot_app/pages/2_page/check_page.dart';

import '../../routes/app_routes.dart';
import 'initial_controller.dart';

class InitialPage extends GetWidget<InitialController> {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('attachedfiles/lotifile/logo_animation.gif'),
          Text('아이콘들 나옴'),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.CHECK_PAGE);
            },
            child: Text('START!!'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('럭키인증'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('럭키상자'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
