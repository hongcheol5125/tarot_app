import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tarot_app/ad_helper.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  Rx<BannerAd?> bannerAd = Rx(null);
  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('###################ok###################');
          bannerAd.value = ad as BannerAd?;
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return bannerAd.value == null
          ? const CircularProgressIndicator()
          : SizedBox(
              width: bannerAd.value!.size.width.toDouble(),
              height: bannerAd.value!.size.height.toDouble(),
              child: AdWidget(ad: bannerAd.value!),
            );
    });
  }
}
