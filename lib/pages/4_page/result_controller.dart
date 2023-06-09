import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tarot_app/model/result.dart';

class ResultController extends GetxController {
  ScreenshotController screenshotController = ScreenshotController();
  Random random = Random();
  late Result result;
  late int card1;
  late int card2;
  late int card3;
  late int luckyPoint;
  Rx<bool> isVisible = Rx(false);
  late List<int> lottoNumbers;

  final box = GetStorage();
  String fileName = '';
  late List<Uint8List> captureList;
  List<Uint8List> noCaptureData = [];

  @override
  void onInit() {
    super.onInit();
    result = Get.arguments;

    // 생년월일에 따른 랜덤숫자(20~30중 하나)
    result.birthPoint = random.nextInt(11) + 20;
    print('birthPoint : ${result.birthPoint}');

    // 카드에 따른 점수 합
    if (result.selectedCards![0].contains('1-')) {
      card1 = 10;
    } else if (result.selectedCards![0].contains('2-')) {
      card1 = 9;
    } else if (result.selectedCards![0].contains('3-')) {
      card1 = 8;
    } else if (result.selectedCards![0].contains('4-')) {
      card1 = 7;
    } else if (result.selectedCards![0].contains('5-')) {
      card1 = 6;
    } else if (result.selectedCards![0].contains('6-')) {
      card1 = 5;
    } else if (result.selectedCards![0].contains('7-')) {
      card1 = 4;
    }

    if (result.selectedCards![1].contains('1-')) {
      card2 = 10;
    } else if (result.selectedCards![1].contains('2-')) {
      card2 = 9;
    } else if (result.selectedCards![1].contains('3-')) {
      card2 = 8;
    } else if (result.selectedCards![1].contains('4-')) {
      card2 = 7;
    } else if (result.selectedCards![1].contains('5-')) {
      card2 = 6;
    } else if (result.selectedCards![1].contains('6-')) {
      card2 = 5;
    } else if (result.selectedCards![1].contains('7-')) {
      card2 = 4;
    }

    if (result.selectedCards![2].contains('1-')) {
      card3 = 10;
    } else if (result.selectedCards![2].contains('2-')) {
      card3 = 9;
    } else if (result.selectedCards![2].contains('3-')) {
      card3 = 8;
    } else if (result.selectedCards![2].contains('4-')) {
      card3 = 7;
    } else if (result.selectedCards![2].contains('5-')) {
      card3 = 6;
    } else if (result.selectedCards![2].contains('6-')) {
      card3 = 5;
    } else if (result.selectedCards![2].contains('7-')) {
      card3 = 4;
    }

    // 카드포인트
    result.cardPoint = card1 + card2 + card3;
    print('cardPoint : ${result.cardPoint}');

    // 10~40 중 랜덤숫자
    result.randomPoint = random.nextInt(31) + 10;
    print('randomPoint : ${result.randomPoint}');

    // 1~45 중 랜덤숫자(로또번호)
    List<int> generateLottoNumbers(int count) {
      List<int> numbers = [];

      while (numbers.length < count) {
        int lottoNumber = random.nextInt(45) + 1;
        if (!numbers.contains(lottoNumber)) {
          numbers.add(lottoNumber);
        }
      }
      return numbers;
    }

    lottoNumbers = generateLottoNumbers(6);

    print('lottoNumbers : $lottoNumbers');

    luckyPoint = result.birthPoint! + result.cardPoint! + result.randomPoint!;
    print('luckyPoint : ${luckyPoint}');

    captureWidget();
  }

  showText() {
    isVisible.value = true;
  }

  captureWidget() async {
    // 위젯 캡처를 위해 잠시 지연
    try {
      await Future.delayed(Duration(seconds: 10));

      // 위젯을 캡처하여 이미지로 저장
      final imageFile = await screenshotController.capture();
      print('캡쳐 성공 : ${imageFile}');

      if (box.read('captureList') == null) {
        noCaptureData.add(imageFile!);
        box.write('captureList', noCaptureData);
      } else {
        captureList = box.read('captureList');
        captureList.add(imageFile!);
        box.write('captureList', captureList);
      }
      print('getStorage에 데이터 저장 완료');
    } catch (e) {
      print('위젯 캡처 중 오류가 발생했습니다: $e');
    }
  }
}
