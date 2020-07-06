import 'package:firebase_admob/firebase_admob.dart';
import 'package:liver3rd/app/utils/const_settings.dart';

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['game', 'business'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  // testDevices: <String>["5EBACEA82F6F9C21B81E68869839C355"],
);

InterstitialAd createInterstitialAd(Function(MobileAdEvent) callback) {
  return InterstitialAd(
    adUnitId: INERSTTIALAD_ID,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      callback(event);
    },
  );
}
