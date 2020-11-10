import 'dart:io';
import 'package:ads/ads.dart' as ads;

class Ads {
  static final bool _testAds = false;
  static final String _appId = null; // removed from public repo
  static final String _interstitialUnitId = null; // removed from public repo

  static Ads _instance = Ads._internal();
  factory Ads() => _instance;
  Ads._internal() {
    if (_appId == null) return;
    _ads = ads.Ads(_appId,
        testing: _testAds,
        screenUnitId: _interstitialUnitId,
        keywords: [
          'video',
          'streaming',
          'movies',
          'tv shows',
          'films',
          'tv',
          'shows',
          'series',
          'watch',
          'netflix'
        ],
        contentUrl: 'https://www.netflix.com/',
        testDevices: []);
  }

  ads.Ads _ads;

  interstitial() {
    if (_ads == null) return;
    try {
      print('Ads implementation: About to show interstitial ad!');
      _ads.showFullScreenAd(errorListener: (Exception e) {
        print('Ads implementation: An error occured when trying to show ad: ' +
            e.toString());
        _ads.closeFullScreenAd();
      }, listener: (ads.MobileAdEvent e) {
        switch (e) {
          case ads.MobileAdEvent.clicked:
            print('Ads implementation: Ad clicked!');
            break;
          case ads.MobileAdEvent.closed:
            print('Ads implementation: Ad closed!');
            break;
          case ads.MobileAdEvent.failedToLoad:
            print('Ads implementation: Ad failed to load!');
            break;
          case ads.MobileAdEvent.impression:
            print('Ads implementation: Impression!');
            break;
          case ads.MobileAdEvent.leftApplication:
            print('Ads implementation: Left application!');
            break;
          case ads.MobileAdEvent.loaded:
            print('Ads implementation: Ad loaded!');
            break;
          case ads.MobileAdEvent.opened:
            print('Ads implementation: Ad opened!');
            break;
        }
      });
    } catch (e) {
      _ads.closeFullScreenAd();
      print('Ads implementation: Could not show ad: ' + e.toString());
    }
  }
}
