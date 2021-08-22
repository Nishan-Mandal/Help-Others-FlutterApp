import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Constants.dart';

class AdMobService {
  // This is for future updates-------------
  // static String get bannerAdUnitId3 => 'ca-app-pub-3940256099942544/6300978111';

  static initialize() {
    if (MobileAds.instance == null) {
      print("initialize:AdMob");
      MobileAds.instance.initialize();
    }
  }

// This is for future updates-------------
  // static BannerAd createBannerAd3() {
  //   BannerAd ad = new BannerAd(
  //     adUnitId: bannerAdUnitId3,
  //     size: AdSize.mediumRectangle,
  //     request: AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (Ad ad) => print('Ad loaded.'),
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         print('Ad failed to load: $error');
  //         ad.dispose();
  //       },
  //       onAdOpened: (Ad ad) => print('Ad opened.'),
  //       onAdClosed: (Ad ad) => print('Ad closed.'),
  //     ),
  //   );

  //   return ad;
  // }

  static String get interstitialAdUnitID1 =>
      'ca-app-pub-1317304154938617/7571041406';

  static InterstitialAd _interstitialAd;

  static int _numInterstitialLoadAttempts = 0;
  static createInterstitialAd1() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitID1,
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
            createInterstitialAd1();
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
        createInterstitialAd1();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  static String get interstitialAdUnitID2 =>
      'ca-app-pub-1317304154938617/3570152411';

  static InterstitialAd _interstitialAd2;

  static int _numInterstitialLoadAttempts2 = 0;
  static createInterstitialAd2() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitID2,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd2 = ad;
          _numInterstitialLoadAttempts2 = 0;

          _interstitialAd2.show();
          _interstitialAd2 = null;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts2 += 1;
          _interstitialAd2 = null;
          if (_numInterstitialLoadAttempts2 <= 2) {
            createInterstitialAd2();
          }
        },
      ),
    );
  }

  static void showInterstitialAd2() {
    if (_interstitialAd2 == null) {
      return;
    }
    _interstitialAd2.fullScreenContentCallback = FullScreenContentCallback(
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
        createInterstitialAd2();
      },
    );
    _interstitialAd2.show();
    _interstitialAd2 = null;
  }

  String get rewardedAdUnitID1 => 'ca-app-pub-1317304154938617/2760822994';
  RewardedAd _rewardedAd;
  void loadRewardedAd1() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitID1,
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

  void showRewardedAd1() {
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

  String get rewardedAdUnitID2 => 'ca-app-pub-1317304154938617/6795722185';
  RewardedAd _rewardedAd2;
  void loadRewardedAd2() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitID2,
        request: AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print("Ad loaded");
          this._rewardedAd2 = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // print("Failed to load rewardedAd");
          // loadRewardedAd();
        }));
  }

  void showRewardedAd2() {
    _rewardedAd2.show(onUserEarnedReward: (RewardedAd ad, RewardItem rpoints) {
      print("Reward earned is${rpoints.amount}");
    });

    _rewardedAd2.fullScreenContentCallback = FullScreenContentCallback(
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

  String get rewardedAdUnitID3 => 'ca-app-pub-1317304154938617/3805956138';
  RewardedAd _rewardedAd3;
  void loadRewardedAd3() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitID3,
        request: AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print("Ad loaded");
          this._rewardedAd3 = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // print("Failed to load rewardedAd");
          // loadRewardedAd();
        }));
  }

  void showRewardedAd3() {
    _rewardedAd3.show(onUserEarnedReward: (RewardedAd ad, RewardItem rpoints) {
      print("Reward earned is${rpoints.amount}");
    });

    _rewardedAd3.fullScreenContentCallback = FullScreenContentCallback(
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

  String get rewardedAdUnitID4 => 'ca-app-pub-1317304154938617/9134659655';
  RewardedAd _rewardedAd4;
  void loadRewardedAd4() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitID4,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print("Ad loaded");
              this._rewardedAd4 = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {}));
  }

  void showRewardedAd4() {
    _rewardedAd4.show(onUserEarnedReward: (RewardedAd ad, RewardItem rpoints) {
      print("Reward earned is${rpoints.amount}");
    });

    _rewardedAd4.fullScreenContentCallback = FullScreenContentCallback(
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

  String get rewardedAdUnitID5 => 'ca-app-pub-1317304154938617/7821577989';
  RewardedAd _rewardedAd5;
  void loadRewardedAd5() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitID5,
        request: AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print("Ad loaded");
          this._rewardedAd5 = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // print("Failed to load rewardedAd");
          // loadRewardedAd();
        }));
  }

  void showRewardedAd5() {
    _rewardedAd5.show(onUserEarnedReward: (RewardedAd ad, RewardItem rpoints) {
      print("Reward earned is${rpoints.amount}");
    });

    _rewardedAd5.fullScreenContentCallback = FullScreenContentCallback(
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
