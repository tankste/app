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

  CommentModel copyWith(
      {int? id, String? name, String? comment, double? value}) {
    return CommentModel(
        id: id ?? this.id,
        name: name ?? this.name,
        comment: comment ?? this.comment,
        value: value ?? this.value);
  }

  @override
  String toString() {
    return 'CommentModel{id: $id, name: $name, comment: $comment, value: $value}';
  }
}
