import 'dart:convert';

import 'package:training_three/data/model/post.dart';

class PostsResponse {
  PostsResponse({
    this.posts,
  });

  List<Post> posts;

  factory PostsResponse.fromRawJson(String str) =>
      PostsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostsResponse.fromJson(Map<String, dynamic> json) => PostsResponse(
        posts: json["posts"] == null
            ? null
            : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "posts": posts == null
            ? null
            : List<dynamic>.from(posts.map((x) => x.toJson())),
      };
}
