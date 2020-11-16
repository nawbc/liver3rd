import 'package:f_logs/model/flog/flog.dart';
import 'package:liver3rd/app/api/forum/forum_api.dart';
import 'package:liver3rd/app/api/forum/user/user_api.dart';
import 'package:liver3rd/app/store/posts.dart';

ForumApi _forumApi = ForumApi();
UserApi _userApi = UserApi();

Future<void> complishMissions(
    {Function onSuccess, Function(dynamic) onError}) async {
  try {
    Map data = await _forumApi.fetchRecPosts(initHomePageRecPostsQuery(1));
    List postList = data['data']['list'];
    print(data);
    await _upvoteFivePosts(postList).catchError((err) {
      FLog.error(text: err, className: '_upvoteFivePosts');
    });
    await _viewThreePosts(postList).catchError((err) {
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

Future<void> _sharePost(List postList) async {
  String postId = postList[0]['post']['post_id'];
  await _forumApi.sharePost(postId);
}

Future<void> _upvoteFivePosts(List postList) async {
  int len = postList.length >= 5 ? 5 : postList.length;
  for (var i = 0; i < len; i++) {
    String postId = postList[i]['post']['post_id'];
    await _forumApi.upvotePost(postId: postId);
  }
}

Future<void> _viewThreePosts(List postList) async {
  for (var i = 0; i < 3; i++) {
    String postId = postList[i]['post']['post_id'];
    await _forumApi.fetchFullPost(postId);
  }
}
