import 'dart:convert';

class Post {
  Post({
    this.id,
    this.title,
    this.userId,
    this.content,
  });

  String id;
  String title;
  String userId;
  String content;

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        userId: json["userId"] == null ? null : json["userId"],
        content: json["content"] == null ? null : json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "userId": userId == null ? null : userId,
        "content": content == null ? null : content,
      };
}
