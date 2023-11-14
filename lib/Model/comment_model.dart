class Comment {
  final String commentId;
  final String commentText;

  Comment({
    required this.commentId,
    required this.commentText,
  });

  Map<String, dynamic> toMap() =>
      {'commentId': commentId, 'commentText': commentText};

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json["commentId"],
      commentText: json["commentText"],
    );
  }
}
