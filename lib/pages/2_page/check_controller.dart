import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tarot_app/ad_helper.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../routes/app_routes.dart';
import '../../utils/birthday_list.dart';
import '../../utils/tarotcard_imgs.dart';

class CheckController extends GetxController {
  TextEditingController nicknameController = TextEditingController();
  late int initialTab;
  late Rx<int> pageIndex;
  late PageController checkController;
  Rx<bool?> isCheckedNickName = Rx(false);
  Rx<bool?> isCheckedHour = Rx(false);
  Rx<String> dropdownYear = Rx(years.first);
  Rx<String> dropdownMonth = Rx(months.first);
  Rx<String> dropdownDay = Rx(days.first);
  Rx<String> dropdownHour = Rx(hours.first);
  Rx<String> dropdownMinute = Rx(minutes.first);
  // ----------구분선(위:인적사항 / 아래:타로카드)---------------
  Rx<String> imagePath1 = Rx('attachedfiles/tarotcard/대기카드.png');
  Rx<String> imagePath2 = Rx('attachedfiles/tarotcard/대기카드.png');
  Rx<String> imagePath3 = Rx('attachedfiles/tarotcard/대기카드.png');
  Rx<BannerAd?> bannerAd = Rx<BannerAd?>(null);

  @override
  void onInit() async{
    super.onInit();
    initialTab = Get.arguments;
    pageIndex = Rx(initialTab);
    checkController = PageController(initialPage: initialTab);

    await BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        print('###################ok###################');
        bannerAd.value = ad as BannerAd?;
        update();
      },
      onAdFailedToLoad: (ad, err) {
        print('Failed to load a banner ad: ${err.message}');
        ad.dispose();
      },
      onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  ).load();
  }

  onChangedCheckNickName(value) {
    isCheckedNickName.value = value;
  }

  onChangedCheckHour(value) {
    isCheckedHour.value = value;
  }

  onChangedDropdownYear(value) {
    dropdownYear.value = value;
  }

  onChangedDropdownMonth(value) {
    dropdownMonth.value = value;
  }

  onChangedDropdownDay(value) {
    dropdownDay.value = value;
  }

  onChangedDropdownHour(value) {
    dropdownHour.value = value;
  }

  onChangedDropdownMinute(value) {
    dropdownMinute.value = value;
  }

  void changeImage1() {
    Random random = Random();
    int randomIndex = random.nextInt(images.length);
    imagePath1.value = images[randomIndex];
  }

  void changeImage2() {
    Random random = Random();
    int randomIndex = random.nextInt(images.length);
    imagePath2.value = images[randomIndex];
  }

  void changeImage3() {
    Random random = Random();
    int randomIndex = random.nextInt(images.length);
    imagePath3.value = images[randomIndex];
  }

  arrowButton() {
    if (checkController.hasClients) {
      if (pageIndex.value == 1) {
        checkController.animateToPage(0,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        pageIndex.value = 0;
      } else {
        Get.offAllNamed(Routes.INITIAL_PAGE);
      }
    }
  }

  onPressedChange1() {
    changeImage1();
    if (imagePath1.value == imagePath2.value ||
        imagePath1.value == imagePath3.value) {
     return changeImage1();
    }
  }

  onPressedChange2() {
    changeImage2();
    if (imagePath2.value == imagePath1.value ||
        imagePath2.value == imagePath3.value) {
     return changeImage2();
    }
  }

  onPressedChange3() {
    changeImage3();
    if (imagePath3.value == imagePath1.value ||
        imagePath3.value == imagePath2.value) {
      changeImage3();
    }
  }

  randomCard1() {
   return Obx(
      () => GestureDetector(
        onTap: onPressedChange1,
        child: Container(
          width: 70,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath1.value),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  randomCard2() {
   return Obx(
      () => GestureDetector(
        onTap: onPressedChange2,
        child: Container(
          width: 70,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath2.value),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  randomCard3() {
   return Obx(
      () => GestureDetector(
        onTap: onPressedChange3,
        child: Container(
          width: 70,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath3.value),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  timeBuilder(){
    return TimerBuilder.periodic(
          Duration(seconds: 1),
          builder: (context) {
            // 한국 시간은 표준시간 + 9
            DateTime date = DateTime.now().add(Duration(hours: 9));
            return Text(
              '${date.year}.${date.month}.${date.day}  ${date.hour} : ${date.minute} : ${date.second}',
              style: TextStyle(fontSize: 20),
            );
          },
        );
  }
}
