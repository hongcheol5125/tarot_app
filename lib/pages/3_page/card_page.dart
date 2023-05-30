import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import 'card_controller.dart';
import 'package:timer_builder/timer_builder.dart';

class CardPage extends GetWidget<CardController> {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.toNamed(Routes.CHECK_PAGE);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('투명한 텍스트(1-1 인적사항)'),
              SizedBox(
                width: 10,
              ),
              Text('큰 텍스트(1-2 타로카드)'),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 150,
                width: 100,
                child: Image.asset('attachedfiles/tarotcard/대기카드.png'),
              ),
              SizedBox(
                height: 150,
                width: 100,
                child: Image.asset('attachedfiles/tarotcard/대기카드.png'),
              ),
              SizedBox(
                height: 150,
                width: 100,
                child: Image.asset('attachedfiles/tarotcard/대기카드.png'),
              ),
            ],
          ),
          SizedBox(height: 20),
          TimerBuilder.periodic(
            Duration(seconds: 1),
            builder: (context) => Text(
              '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}  ${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.RESULT_PAGE);
            },
            child: Text('NEXT!!'),
          ),
          
        ],
      ),
    );
  }
}
