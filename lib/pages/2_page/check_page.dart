import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_app/model/result.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../routes/app_routes.dart';
import '../../utils/birthday_list.dart';
import 'check_controller.dart';

class CheckPage extends GetWidget<CheckController> {
  const CheckPage({super.key});

  checkList(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          // 닉네임 텍스트필드 + 체크박스
          child: Row(
            children: [
              Text('이름'),
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
                      activeColor: Colors.white,
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

        // 생년월일 드롭다운
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('생년월일'),
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

        //태어난 시각 드롭다운 + 체크박스
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('태어난 시간'),
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
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: controller.isCheckedHour.value,
                    onChanged: controller.onChangedCheckHour,
                  ),
                ),
              ),
            ),
          ],
        ),

        // NEXT 버튼(타로카드 페이지로 가기)
        ElevatedButton(
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
        ElevatedButton(
          onPressed: () {
            Get.offAllNamed(Routes.INITIAL_PAGE);
          },
          child: Text('restart!!'),
        ),
        SizedBox(height: 50)
      ],
    );
  }

  cardList(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            controller.randomCard1(),
            controller.randomCard2(),
            controller.randomCard3(),
          ],
        ),
        SizedBox(height: 20),
        controller.timeBuilder(),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () { // context때문에 controller로 못 넘기는듯 
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
          },
          child: Text('NEXT!!'),
        ),
      ],
    );
  }

  arrowBackButton() {
    return Obx(
      () => IconButton(
          onPressed: controller.arrowButton,
          icon: Icon(Icons.arrow_back),
          color: controller.pageIndex.value == 0
              ? Colors.purple
              : Colors.purpleAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading:
              // 뒤로가기 버튼
              arrowBackButton(),
        ),
        body: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          if (controller.checkController.hasClients) {
                            controller.checkController.animateToPage(0,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                            controller.pageIndex.value = 0;
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: controller.pageIndex.value == 0
                              ? const BoxDecoration(
                                  color: Colors.white,
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
                  ),
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          if (controller.checkController.hasClients) {
                            controller.checkController.animateToPage(1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                            controller.pageIndex.value = 1;
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: controller.pageIndex.value == 1
                              ? const BoxDecoration(
                                  color: Colors.white,
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
                  ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
