import 'package:flutter/widgets.dart';
import 'package:liver3rd/app/api/bh/bh_comics_api.dart';
import 'package:liver3rd/app/api/ys/ys_comics_api.dart';

class Comics with ChangeNotifier {
  List _bhComicsList = [];
  List get bhComicsList => _bhComicsList;
  set bhComicsList(val) {
    _bhComicsList = val;
  }

  Map _ysComicsMap = {};
  Map get ysComicsMap => _ysComicsMap;
  set ysComicsMap(val) {
    _ysComicsMap = val;
  }

  BhComicsApi _bhComicsApi = BhComicsApi();
  YsComicsApi _ysComicsApi = YsComicsApi();

  Future<void> fetchBhComicsList() async {
    _bhComicsList = await _bhComicsApi.fetchComicsListBH();
    notifyListeners();
  }

  Future<void> fetchYsComicsList() async {
    _ysComicsMap = await _ysComicsApi.fetchComicsListYS();
  }
}
