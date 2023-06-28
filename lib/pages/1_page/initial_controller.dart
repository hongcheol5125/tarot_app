import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tarot_app/ad_helper.dart';

class InitialController extends GetxController {
  Rx<bool> isVisible = Rx(false);
  Rx<BannerAd?> bannerAd = Rx<BannerAd?>(null);
showText() {
    isVisible.value = true;
  }

  @override
  void onInit() async{
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
    super.onInit();
  }

//   void dispose() {
//   bannerAd?.dispose();
//   super.dispose();
// }
}