import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_app/routes/app_routes.dart';
import 'package:timer_builder/timer_builder.dart';
import 'check_controller.dart';

class CheckPage extends GetWidget<CheckController> {
  TextEditingController nicknameController = TextEditingController();
  CheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now().add(Duration(hours: 9));
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.toNamed(Routes.INITIAL_PAGE);
            },
            icon: Icon(Icons.arrow_back),
          ),
          bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text(
                    '1-1 인적사항',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    '1-2 타로카드',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: [
                TextField(
                  controller: nicknameController,
                  decoration: InputDecoration(hintText: '닉네임 + 체크박스'),
                ),
                Text('생년월일 드롭다운'),
                Text('태어난 시각 드롭다운 + 체크박스'),
                ElevatedButton(
                  onPressed: () {
                   controller.checkController.page == 1;
                  },
                  child: Text('NEXT!!'),
                ),
              ],
            ),
            Column(
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
                builder: (context) {
                  // 한국 시간은 표준시간 + 9
                  DateTime date = DateTime.now().add(Duration(hours: 9));
                  return Text(
                    '${date.year}.${date.month}.${date.day}  ${date.hour} : ${date.minute} : ${date.second}',
                    style: TextStyle(fontSize: 20),
                  );
                },
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
          ],
        ),
      ),
    );
  }
}
