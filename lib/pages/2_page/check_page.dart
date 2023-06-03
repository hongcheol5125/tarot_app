import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

        ElevatedButton(
          onPressed: () async {
            if (controller.isCheckedNickName.value == false &&
                controller.nicknameController.text == '') {
              await showDialog<String>(
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
            }
            if (controller.dropdownYear.value == '년' ||
                controller.dropdownMonth.value == '월' ||
                controller.dropdownDay.value == '일') {
             await showDialog<String>(
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

  cardList() {
    return Column(
      children: [
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
            Get.toNamed(Routes.RESULT_PAGE, arguments: [
              controller.nicknameController.text,
              controller.dropdownYear.value,
              controller.dropdownMonth.value,
              controller.dropdownDay.value,
              controller.dropdownHour.value,
              controller.dropdownMinute.value,
            ]);
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
        appBar: AppBar(
          leading: Obx(
            () => IconButton(
                onPressed: () {
                  if (controller.checkController.hasClients) {
                    if (controller.pageIndex.value == 1) {
                      controller.checkController.animateToPage(0,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                      controller.pageIndex.value = 0;
                    } else {
                      Get.offAllNamed(Routes.INITIAL_PAGE);
                    }
                  }
                },
                icon: Icon(Icons.arrow_back),
                color: controller.pageIndex.value == 0
                    ? Colors.purple
                    : Colors.purpleAccent),
          ),
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
                controller: controller.checkController,
                children: <Widget>[
                  checkList(context),
                  cardList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
