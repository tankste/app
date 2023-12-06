import 'package:sponsor/model/balance_model.dart';
import 'package:sponsor/model/comment_model.dart';

class CommentDto {
  final int? id;
  final String? name;
  final String? comment;
  final double? value;

  CommentDto({
    required this.id,
    required this.name,
    required this.comment,
    required this.value,
  });

  factory CommentDto.fromJson(Map<String, dynamic> parsedJson) {
    return CommentDto(
      id: parsedJson['id'],
      name: parsedJson['name'],
      comment: parsedJson['comment'],
      value: parsedJson['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'comment': comment,
      'value': value,
    };
  }

  CommentModel toModel() {
    return CommentModel(
      id: id ?? -1,
      name: name ?? "",
      comment: comment ?? "",
      value: value ?? 0,
    );
  }

  @override
  String toString() {
    return 'CommentDto{id: $id, name: $name, comment: $comment, value: $value}';
  }
}
