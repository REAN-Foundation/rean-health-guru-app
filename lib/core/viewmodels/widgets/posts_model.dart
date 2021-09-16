import 'package:meta/meta.dart';
import 'package:paitent/core/models/post.dart';
import 'package:paitent/core/services/api.dart';

import '../base_model.dart';

class PostsModel extends BaseModel {
  final Api _api;

  PostsModel({
    @required Api api,
  }) : _api = api;

  List<Post> posts;

  Future getPosts(int userId) async {
    setBusy(true);
    posts = await _api.getPostsForUser(userId);
    setBusy(false);
  }
}
