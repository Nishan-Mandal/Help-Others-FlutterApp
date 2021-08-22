import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAds {
  Future<InitializationStatus> initialization;
  BannerAds(this.initialization);
  String get bannerAdUnit => 'ca-app-pub-1317304154938617/4158835032';
  String get bannerAdUnit2 => 'ca-app-pub-1317304154938617/8439335712';
  String get bannerAdUnit3 => 'ca-app-pub-1317304154938617/2377679619';

  BannerAdListener get adListener => _adListener;
  BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened.'),
    onAdClosed: (Ad ad) => print('Ad closed.'),
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
}
