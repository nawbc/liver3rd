import 'package:dio/dio.dart';
import 'package:liver3rd/app/api/gitee/src_links.dart';

class GiteeApi {
  Future<List> fetchReleases() async {
    Response res = await Dio().get(releaseUrl);
    return res.data;
  }
}
