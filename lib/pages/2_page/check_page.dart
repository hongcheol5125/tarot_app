import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_app/pages/1_page/initial_page.dart';
import 'package:tarot_app/routes/app_routes.dart';
import 'check_controller.dart';

class CheckPage extends GetWidget<CheckController> {
  TextEditingController nicknameController = TextEditingController();
  CheckPage({super.key});

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
        children: [
          Text('큰 텍스트(1-1 인적사항)\n투명한 텍스트(1-2 타로카드)'),
          TextField(
            controller: nicknameController,
            decoration: InputDecoration(hintText: '닉네임 + 체크박스'),
          ),
          Text('생년월일 드롭다운'),
          Text('태어난 시각 드롭다운 + 체크박스'),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.CARD_PAGE);
            },
            child: Text('NEXT!!'),
          ),
        ],
      ),
    );
  }
}
