import 'package:f_logs/model/flog/flog.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/utils/pre_handler.dart';

ForumApi _forumApi = ForumApi();
UserApi _userApi = UserApi();

Future<void> complishMissions(bool auto,
    {List gameList, Function onSuccess, Function(dynamic) onError}) async {
  try {
    if (gameList != null) {
      int count = 0;
      await for (var item in Stream.fromIterable(gameList)) {
        await requestDiffFormMissions(auto, count);
        count++;
      }
    } else {
      await requestDiffFormMissions(auto, 1);
    }
    Map data = await _forumApi.fetchRecPosts(initHomePageRecPostsQuery(1));
    List postList = data['data']['list'];

    await _upvotePosts(postList, auto: auto).catchError((err) {
      FLog.error(text: err, className: '_upvotePosts');
    });
    await _viewThreePosts(postList, auto: auto).catchError((err) {
      FLog.error(text: err, className: '_viewThreePosts');
    });
    await _sharePost(postList).catchError((err) {
      FLog.error(text: err, className: '_sharePost');
    });
    await _userApi.signIn().catchError((err) {
      
      FLog.error(text: err, className: '_userApi');
    });
    if (onSuccess != null) onSuccess();
  } catch (err) {
    if (onError != null) onError(err);
  }
}

Future<void> requestDiffFormMissions(bool auto, int form) async {
  Map data = await _forumApi.fetchRecPosts(initHomePageRecPostsQuery(form));
  List postList = data['data']['list'];

  if (postList != null) {
    await _upvotePosts(postList, auto: auto).catchError((err) {
      FLog.error(text: err, className: '_upvotePosts');
    });
    await _viewThreePosts(postList, auto: auto).catchError((err) {
      FLog.error(text: err, className: '_viewThreePosts');
    });
    await _sharePost(postList).catchError((err) {
      FLog.error(text: err, className: '_sharePost');
    });
  }

  await _userApi.signIn().catchError((err) {
    FLog.error(text: err, className: '_userApi');
  });
}

Future<void> _sharePost(List postList) async {
  String postId = postList[0]['post']['post_id'];
  await _forumApi.sharePost(postId);
}

Future<void> _upvotePosts(List postList, {bool auto}) async {
  if (auto) {
    await for (var item in Stream.fromIterable(postList)) {
      String postId = item['post']['post_id'];
      await _forumApi.upvotePost(postId: postId);
      await Future.delayed(Duration(milliseconds: 600));
    }
  } else {
    for (var i = 0; i < 5; i++) {
      String postId = postList[i]['post']['post_id'];
      await _forumApi.upvotePost(postId: postId);
    }
  }
}

Future<void> _viewThreePosts(List postList, {bool auto}) async {
  if (auto) {
    await for (var item in Stream.fromIterable(postList)) {
      String postId = item['post']['post_id'];
      await _forumApi.fetchFullPost(postId);
      await Future.delayed(Duration(milliseconds: 600));
    }
  } else {
    for (var i = 0; i < 3; i++) {
      String postId = postList[i]['post']['post_id'];
      await _forumApi.fetchFullPost(postId);
    }
  }
}
