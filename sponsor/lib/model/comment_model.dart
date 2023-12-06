class CommentModel {
  int id;
  String name;
  String comment;
  double value;

  CommentModel(
      {required this.id,
      required this.name,
      required this.comment,
      required this.value});

  @override
  String toString() {
    return 'CommentModel{id: $id, name: $name, comment: $comment, value: $value}';
  }
}
