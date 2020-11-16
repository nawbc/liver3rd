import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:liver3rd/app/api/gitee/gitee_api.dart';
import 'package:liver3rd/app/utils/const_settings.dart';
import 'package:liver3rd/app/utils/handle_cache.dart';
import 'package:liver3rd/app/utils/share.dart';
import 'package:liver3rd/app/utils/tiny_utils.dart';
import 'package:liver3rd/app/widget/common_widget.dart';
import 'package:liver3rd/app/widget/dialogs.dart';
import 'package:liver3rd/app/widget/option_item_widget.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';
import 'package:liver3rd/app/widget/no_scaled_text.dart';

class SoftwareSettingsFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SoftwareSettingsFragmentState();
  }
}

class SoftwareSettingsFragmentState extends State<SoftwareSettingsFragment> {
  HandleCache _handleCache;
  String _cacheSize;
  GiteeApi _giteeApi = GiteeApi();
  String _version = "";
  String _splashMode;
  bool _canUpdate = false;
  bool _locker = true;

  @override
  void initState() {
    super.initState();
    _handleCache = HandleCache();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _renderCacheSize();
    if (_locker) {
      await _checkUpdate();
      await _renderSplashMode();
      _locker = false;
    }
  }

  _renderSplashMode() async {
    if (mounted) {
      String mode = await Share.shareString(SPLASH_MODE);
      setState(() {
        _splashMode = mode;
      });
    }
  }

  Future<bool> _checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    try {
      List tmp = await _giteeApi.fetchReleases();
      if (tmp[0] != null) {
        Version latestVersion = Version.parse(tmp[tmp.length - 1]['tag_name']);
        Version currentVersion = Version.parse(packageInfo.version);
        if (latestVersion > currentVersion) {
          _updateVersionString('更新 ${latestVersion.toString()}');
          setState(() {
            _canUpdate = true;
          });
          return true;
        } else {
          _updateVersionString(packageInfo.version);
          return false;
        }
      } else {
        _updateVersionString(packageInfo.version);
        return false;
      }
    } catch (e) {
      _updateVersionString(packageInfo.version);
      return false;
    }
  }

  void _updateVersionString(String str) {
    if (mounted) {
      setState(() {
        _version = str;
      });
    }
  }

  Future<void> _renderCacheSize() async {
    String size = await _handleCache.loadCache();
    if (mounted) {
      setState(() {
        _cacheSize = size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(_splashMode);
    return Container(
      child: Column(
        children: [
          OptionItem(
            title: '启动页',
            subTitle: '女武神,软件Logo,米游社画报',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            extend: NoScaledText(
              _splashMode == null ? SPLASH_MODE_1 : _splashMode,
            ),
            onPress: () async {
              List types = [SPLASH_MODE_1, SPLASH_MODE_2, SPLASH_MODE_3];
              Dialogs.showSelectDialog(
                context,
                list: types,
                title: '设置启动页类型',
                selected: _splashMode,
                onSelect: (selected, index) {
                  Share.setString(SPLASH_MODE, selected).then((val) async {
                    Scaffold.of(context)
                        .showSnackBar(CommonWidget.snack('设置成功'));
                    String mode = await Share.shareString(SPLASH_MODE);
                    setState(() {
                      _splashMode = mode;
                    });
                  }).catchError((e) {
                    Scaffold.of(context).showSnackBar(
                      CommonWidget.snack('设置失败', isError: true),
                    );
                  });
                },
              );
            },
            shadow: null,
          ),
          OptionItem(
            title: '清除缓存',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              await DefaultCacheManager().emptyCache().then((val) async {
                await _renderCacheSize();
                Scaffold.of(context).showSnackBar(CommonWidget.snack("清除成功"));
              }).catchError((val) async {
                await _renderCacheSize();
                Scaffold.of(context)
                    .showSnackBar(CommonWidget.snack("清除失败", isError: true));
              });
            },
            shadow: null,
            extend: NoScaledText(_cacheSize == null ? '' : _cacheSize),
          ),
          OptionItem(
            title: '检查更新',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            onPress: () async {
              if (await _checkUpdate()) {
                TinyUtils.openUrl('http://sewerganger.gitee.io/liver3rd/');
              }
            },
            shadow: null,
            extend: NoScaledText(
              _version,
              style: _canUpdate ? TextStyle(color: Colors.red) : null,
            ),
          ),
          OptionItem(
            title: '导出日志',
            titleColor: Colors.grey,
            subTitleColor: Colors.grey[400],
            color: Colors.grey[200],
            marginBottom: 0,
            onPress: () async {
              await FLog.exportLogs();
              Directory logDir = await TinyUtils.logDir();
              Scaffold.of(context)
                  .showSnackBar(CommonWidget.snack('${logDir.path}'));
            },
            shadow: null,
          ),
        ],
      ),
    );
  }
}
