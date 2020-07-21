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

    await _upvoteFivePosts(postList);
    await _viewThreePosts(postList);
    await _sharePost(postList);
    await _userApi.signIn();
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
  for (var i = 0; i < 5; i++) {
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
