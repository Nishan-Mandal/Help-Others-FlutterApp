import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Constants.dart';

class AdMobService {
  static String get bannerAdUnitId1 => 'ca-app-pub-3940256099942544/6300978111';
  // static String get bannerAdUnitId2 => 'ca-app-pub-3940256099942544/6300978111';
  static initialize() {
    if (MobileAds.instance == null) {
      print("initialize:AdMob");
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBannerAd() {
    BannerAd ad = new BannerAd(
      adUnitId: bannerAdUnitId1,
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
      ),
    );

    return ad;
  }

  static BannerAd createBannerAd2() {
    BannerAd ad = new BannerAd(
      adUnitId: bannerAdUnitId1,
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
      ),
    );

    return ad;
  }

  static BannerAd createBannerAd3() {
    BannerAd ad = new BannerAd(
      adUnitId: bannerAdUnitId1,
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
      ),
    );

    return ad;
  }

  static String get interstitialAdUnitID =>
      'ca-app-pub-3940256099942544/1033173712';

  static InterstitialAd _interstitialAd;

  static int _numInterstitialLoadAttempts = 0;
  static createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitID,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;

          _interstitialAd.show();
          _interstitialAd = null;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= 2) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  // static void showInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     _createInterstitialAd();
  //   }
  // }

  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print("ad shown");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print("ad disposed");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError adError) {
        print("$ad onAdFailed $adError");
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  String get rewardedAdUnitID => 'ca-app-pub-3940256099942544/5224354917';
  RewardedAd _rewardedAd;
  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitID,
        request: AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print("Ad loaded");
          this._rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // print("Failed to load rewardedAd");
          // loadRewardedAd();
        }));
  }

  void showRewardedAd() {
    _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem rpoints) {
      print("Reward earned is${rpoints.amount}");
    });

    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );
  }
}
