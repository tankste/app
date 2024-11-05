import 'package:sponsor/model/comment_model.dart';
import 'package:sponsor/model/sponsorship_model.dart';

class SponsorshipDto {
  final int? id;
  final String? activeSubscriptionId;
  final double? value;

  SponsorshipDto({
    required this.id,
    required this.activeSubscriptionId,
    required this.value,
  });

  factory SponsorshipDto.fromJson(Map<String, dynamic> parsedJson) {
    return SponsorshipDto(
      id: parsedJson['id'],
      activeSubscriptionId: parsedJson['activeSubscriptionId'],
      value: parsedJson['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activeSubscriptionId': activeSubscriptionId,
      'value': value,
    };
  }

  factory SponsorshipDto.fromModel(CommentModel model) {
    return SponsorshipDto(
      id: model.id,
      activeSubscriptionId: model.name,
      value: model.value,
    );
  }

  SponsorshipModel toModel() {
    return SponsorshipModel(
      id: id ?? -1,
      activeSubscriptionId: activeSubscriptionId,
      value: value ?? 0,
    );
  }

  @override
  String toString() {
    return 'SponsorshipDto{id: $id, activeSubscriptionId: $activeSubscriptionId, value: $value}';
  }
}
