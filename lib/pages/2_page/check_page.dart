import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_app/model/result.dart';
import 'package:tarot_app/widget/banner_widget.dart';

import '../../routes/app_routes.dart';
import '../../utils/birthday_list.dart';
import 'check_controller.dart';

class CheckPage extends GetWidget<CheckController> {
  const CheckPage({super.key});

  arrowBackButton() {
    return Obx(
      () => IconButton(
          onPressed: controller.arrowButton,
          icon: Icon(
            Icons.arrow_back,
            size: 40,
          ),
          color: controller.pageIndex.value == 0
              ? Colors.purple
              : Colors.purpleAccent),
    );
  }

  pageViewTitles() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Obx(
              () => Container(
                height: 50,
                decoration: controller.pageIndex.value == 0
                    ? const BoxDecoration(
                        color: Color.fromRGBO(252, 199, 3, 1),
                      )
                    : const BoxDecoration(color: Colors.grey),
                alignment: Alignment.center,
                child: Text(
                  '1-1 인적사항',
                  style: TextStyle(
                    color: controller.pageIndex.value == 0
                        ? null
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => Container(
                height: 50,
                decoration: controller.pageIndex.value == 1
                    ? const BoxDecoration(
                        color: Color.fromRGBO(252, 199, 3, 1),
                      )
                    : const BoxDecoration(color: Colors.grey),
                alignment: Alignment.center,
                child: Text(
                  '1-2 타로카드',
                  style: TextStyle(
                    color: controller.pageIndex.value == 1
                        ? null
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkList(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              // 닉네임 텍스트필드 + 체크박스
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
                child: Row(
                  children: [
                    Text('이름 :', style: TextStyle(fontSize: 15),),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: controller.nicknameController,
                        decoration: InputDecoration(hintText: '닉네임'),
                      ),
                    ),
                    SizedBox(
                      child: Obx(
                        () => Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Color.fromRGBO(252, 199, 3, 1),
                            checkColor: Colors.red,
                            value: controller.isCheckedNickName.value,
                            onChanged: controller.onChangedCheckNickName,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
            // 생년월일 드롭다운
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('생년월일 :', style: TextStyle(fontSize: 15),),
                  SizedBox(
                    child: Obx(
                      () => DropdownButton<String>(
                          value: controller.dropdownYear.value, // 이걸 적어줘야 처음 숫자 뜬다.
                          items: years.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: controller.onChangedDropdownYear),
                    ),
                  ),
                  SizedBox(
                    child: Obx(
                      () => DropdownButton<String>(
                          value: controller.dropdownMonth.value, // 이걸 적어줘야 처음 숫자 뜬다.
                          items: months.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: controller.onChangedDropdownMonth),
                    ),
                  ),
                  SizedBox(
                    child: Obx(
                      () => DropdownButton<String>(
                          value: controller.dropdownDay.value, // 이걸 적어줘야 처음 숫자 뜬다.
                          items: days.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: controller.onChangedDropdownDay),
                    ),
                  ),
                ],
              ),
            ),
          
            //태어난 시각 드롭다운 + 체크박스
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('태어난 시간 :', style: TextStyle(fontSize: 15),),
                  SizedBox(
                    child: Obx(
                      () => DropdownButton<String>(
                          value: controller.dropdownHour.value, // 이걸 적어줘야 처음 숫자 뜬다.
                          items: hours.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: controller.onChangedDropdownHour),
                    ),
                  ),
                  SizedBox(
                    child: Obx(
                      () => DropdownButton<String>(
                          value: controller.dropdownMinute.value, // 이걸 적어줘야 처음 숫자 뜬다.
                          items:
                              minutes.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: controller.onChangedDropdownMinute),
                    ),
                  ),
                  SizedBox(
                    child: Obx(
                      () => Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          activeColor: Color.fromRGBO(252, 199, 3, 1),
                          checkColor: Colors.red,
                          value: controller.isCheckedHour.value,
                          onChanged: controller.onChangedCheckHour,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
          
            // NEXT 버튼(타로카드 페이지로 가기)
            TextButton(
              onPressed: () {
                if (controller.isCheckedNickName.value == false &&
                    controller.nicknameController.text == '') {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('이름을 적거나 체크박스를 체크해주세요.'),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  return;
                }
                if (controller.dropdownYear.value == '년' ||
                    controller.dropdownMonth.value == '월' ||
                    controller.dropdownDay.value == '일') {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('생년 / 월 / 일을 골라주세요.'),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  return;
                }
                if (controller.isCheckedHour.value == false) {
                  if (controller.dropdownHour.value == '시' &&
                      controller.dropdownMinute.value == '분') {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('태어난 시, 분을 고르시거나 체크박스를 체크해주세요.'),
                              const SizedBox(height: 15),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    return;
                  } else {
                    controller.checkController.animateToPage(1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                    controller.pageIndex.value = 1;
                  }
                } else {
                  if (controller.checkController.hasClients) {
                    controller.checkController.animateToPage(1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                    controller.pageIndex.value = 1;
                  }
                }
              },
              child: Text('NEXT!!'),
            ),
            // 처음페이지로 가는 버튼
            TextButton(
              onPressed: () {
                Get.offAllNamed(Routes.INITIAL_PAGE);
              },
              child: Text('restart!!'),
            ),
          ],
        ),
      ),
    );
  }

  cardList(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            controller.randomCard1(),
            controller.randomCard2(),
            controller.randomCard3(),
          ],
        ),
        SizedBox(height: 40),
        controller.timeBuilder(),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            // context때문에 controller로 못 넘기는듯
            if (controller.imagePath1.value == 'attachedfiles/tarotcard/대기카드.png' ||
                controller.imagePath2.value ==
                    'attachedfiles/tarotcard/대기카드.png' ||
                controller.imagePath3.value ==
                    'attachedfiles/tarotcard/대기카드.png') {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('세개의 카드를 모두 골라주세요!'),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              return;
            }

            DateTime birthDay = DateTime(
              int.parse(controller.dropdownYear.value),
              int.parse(controller.dropdownMonth.value),
              int.parse(controller.dropdownDay.value),
            );

            Duration? birthTime;

            if (controller.dropdownHour.value != '시' &&
                controller.dropdownMinute.value != '분') {
              birthTime = Duration(
                hours: int.parse(controller.dropdownHour.value),
                minutes: int.parse(controller.dropdownMinute.value),
              );
            }

            Result result = Result(
              name: controller.nicknameController.text,
              birthDay: birthDay,
              birthTime: birthTime,
              birthPoint: null,
              selectedCards: [
                controller.imagePath1.value,
                controller.imagePath2.value,
                controller.imagePath3.value,
              ],
              cardPoint: null,
              randomPoint: null,
              lottoPoint: null,
            );

            Get.toNamed(Routes.RESULT_PAGE, arguments: result);
            // VV잘 넘어가는지 확인
            // print('------------------------------------');
            // print(result.birthDay);
            // print(result.birthTime);
            // print(result.name);
          },
          child: Text('NEXT!!'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(252, 199, 3, 1),
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Color.fromRGBO(252, 199, 3, 1),
          leading:
              // 뒤로가기 버튼
              arrowBackButton(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            pageViewTitles(),
            // pageView 목록
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.checkController,
                children: <Widget>[
                  checkList(context),
                  cardList(context),
                ],
              ),
            ),
            BannerWidget(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
