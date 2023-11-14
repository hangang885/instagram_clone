import 'comment_model.dart';

class Post {
  final String id;
  final String image;
  final List<dynamic> tag;
  final List<dynamic>? favorite;
  final String content;
  final List<Comment>? comment;
  final bool commentVisible;
  final bool like;
  final bool bookmark;
  final double scale;

  Post({
    required this.id,
    required this.image,
    required this.tag,
    required this.favorite,
    required this.content,
    required this.comment,
    required this.like,
    required this.bookmark,
    required this.scale,
    this.commentVisible = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'image': image,
    'tag': tag,
    'favorite': favorite,
    'content': content,
    'comment': comment!.map((item) => item.toMap()).toList(),
    'commentVisible': commentVisible,
    'like': like,
    'scale': scale,
    'bookmark': bookmark
  };

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Map<String, dynamic>> commentData =
        (json['comment'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    return Post(
      id: json["id"],
      image: json["image"],
      tag: json['tag'],
      content: json['content'],
      like: json['like'],
      bookmark: json['bookmark'],
      comment: commentData
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
      scale: json['scale'] ?? 0.0,
      favorite: json['favorite'] ?? [],
      commentVisible: false,
    );
  }

  Post copyWith(
      {String? image,
        List<String>? favorite,
        String? id,
        String? content,
        List<Comment>? comment,
        List<String>? tag,
        bool? commentVisible,
        bool? like,
        bool? bookmark,
        double? scale}) {
    return Post(
        image: image ?? this.image,
        favorite: favorite ?? this.favorite,
        id: id ?? this.id,
        content: content ?? this.content,
        comment: comment ?? this.comment,
        tag: tag ?? this.tag,
        like: like ?? this.like,
        commentVisible: commentVisible ?? this.commentVisible,
        bookmark: bookmark ?? this.bookmark,
        scale: scale ?? this.scale);
  }
}
