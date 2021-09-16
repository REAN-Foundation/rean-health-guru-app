import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/comment.dart';
import 'package:paitent/core/models/post.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/networking/ApiProvider.dart';

/// The service responsible for networking requests
class Api {
  //static const endpoint = 'https://hca-bff-dev.services.tikme.app';

  //var client = new http.Client();

  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  Future<UserData> loginPatient(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';

    final response =
        await apiProvider.post('/user/login', body: body, header: map);

    print(response);

    // Convert and return
    return UserData.fromJson(response);
  }

  Future<PatientApiDetails> loginPatientWithOTP(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';

    final response =
        await apiProvider.post('/patient', body: body, header: map);

    print(response);

    // Convert and return
    return PatientApiDetails.fromJson(response);
  }

  Future<PatientApiDetails> verifyOTP(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';

    final response =
        await apiProvider.post('/user/validate-otp', body: body, header: map);

    print(response);

    // Convert and return
    return PatientApiDetails.fromJson(response);
  }

  Future<BaseResponse> signUpPatient(Map body) async {
    // Get user profile for id

    debugPrint(json.encode(body).toString());

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';

    final response =
        await apiProvider.post('/Patient', body: body, header: map);

    print(response);

    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse> updateProfilePatient(
      Map body, String userId, String auth) async {
    // Get user profile for id

    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = auth;

    final response =
        await apiProvider.put('/patient/' + userId, body: body, header: map);

    print(response);

    // Convert and return
    return BaseResponse.fromJson(response);
  }

  Future<List<Post>> getPostsForUser(int userId) async {
    final posts = <Post>[];
    // Get user posts for id
    final response = await apiProvider.get('/posts?userId=$userId');

    // parse into List
    final parsed = json.decode(response.body) as List<dynamic>;

    // loop and convert each item to Post
    for (final post in parsed) {
      posts.add(Post.fromJson(post));
    }

    return posts;
  }

  Future<List<Comment>> getCommentsForPost(int postId) async {
    final comments = <Comment>[];

    // Get comments for post
    final response = await apiProvider.get('/comments?postId=$postId');

    // Parse into List
    final parsed = json.decode(response.body) as List<dynamic>;

    // Loop and convert each item to a Comment
    for (final comment in parsed) {
      comments.add(Comment.fromJson(comment));
    }

    return comments;
  }
}
