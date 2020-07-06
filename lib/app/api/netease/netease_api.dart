import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/netease/src_links.dart';

class NeteaseApi {
  Future<Map> fetchPlayList({String id}) async {
    Response res = await Dio().get(playListUrl(id));
    return res.data;
  }

  Future<Map> fetchSong({String id}) async {
    Response res = await Dio().get(basicParseUrl('song', id));
    return res.data;
  }

  Future<Map> fetchLyric({String id}) async {
    Response res = await Dio().get(basicParseUrl('lyric', id));
    return res.data;
  }
}
