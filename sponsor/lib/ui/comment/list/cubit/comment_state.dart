abstract class CommentState {}

class LoadingCommentState extends CommentState {}

class CommentsCommentState extends CommentState {
  List<CommentItem> items;

  CommentsCommentState({required this.items});
}

class ErrorCommentState extends CommentState {
  String errorDetails;

  ErrorCommentState({required this.errorDetails});
}

class CommentItem {
  int id;
  String avatarChar;
  String name;
  String comment;
  String value;
  bool isEditable;

  CommentItem(
      {required this.id,
      required this.avatarChar,
      required this.name,
      required this.comment,
      required this.value,
      required this.isEditable});
}
