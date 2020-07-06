import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/bh/bh_animations_api.dart';

class Animations with ChangeNotifier {
  Map _bhAnimationsMap = {};
  Map get bhAnimationsMap => _bhAnimationsMap;
  BhAnimationsApi _bhAnimationsApi = BhAnimationsApi();

  Future<void> fetchBhAnimationsList() async {
    _bhAnimationsMap = await _bhAnimationsApi.fetchAnimationsList();
    notifyListeners();
  }
}
