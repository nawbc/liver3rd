import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:liver3rd/app/api/bh/src_links.dart';
import 'package:liver3rd/app/api/utils.dart';

class BhComicsApi {
  ReqUtils _reqUtils = ReqUtils();
  RegExp hrefReg = RegExp(r"/\d+");
  RegExp titleReg = RegExp(r"[\u4e00-\u9fa5]+");

  Future<List<Map>> _extractComicsListBH(String html) async {
    Document document = parse(html);
    List<Element> alinks = document.querySelectorAll('a');
    return alinks.map((ele) {
      String href = ele.attributes['href'];
      Element description = ele.querySelector('.container-description');
      return {
        'href': comicsListUrl + hrefReg.stringMatch(href),
        'title': titleReg.stringMatch(href),
        'coverUrl': ele.querySelector('img').attributes['src'],
        'description': description.innerHtml.trim()
      };
    }).toList();
  }

  Future<List<String>> _extractComicPicturesBH(String data) async {
    Document document = parse(data);
    Element wrapper = document.querySelector('.comic-wrapper');
    return wrapper.querySelectorAll('img').map((ele) {
      return ele.attributes['data-original'];
    }).toList();
  }

  Future<List<String>> fetchAllComicImgBH(String url) async {
    var headers = await _reqUtils.setDeviceHeader();
    Response res = await Dio().get(
      url,
      options: Options(
        headers: headers,
      ),
    );
    return _extractComicPicturesBH(res.data);
  }

  // https://comic.bh3.com/book/1001/get_chapter
  Future<List> fetchComicsCollectionBH(String url) async {
    var headers = await _reqUtils.setDeviceHeader();
    Response res = await Dio().get(
      url,
      options: Options(
        headers: headers,
      ),
    );
    return jsonDecode(res.data);
  }

  Future<List<Map>> fetchComicsListBH() async {
    var headers = await _reqUtils.setDeviceHeader();
    Response res = await Dio().get(
      comicsListUrl,
      options: Options(
        headers: headers,
      ),
    );
    return _extractComicsListBH(res.data);
  }
}
