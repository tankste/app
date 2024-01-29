import 'package:core/device/model/device_model.dart';

class DeviceDto {
  final String? id;

  DeviceDto({
    required this.id,
  });

  factory DeviceDto.fromJson(Map<String, dynamic> parsedJson) {
    return DeviceDto(
      id: parsedJson['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  factory DeviceDto.fromModel(DeviceModel model) {
    return DeviceDto(
      id: model.id,
    );
  }

  DeviceModel toModel() {
    return DeviceModel(
      id: id ?? "",
    );
  }

  @override
  String toString() {
    return 'DeviceDto{id: $id}';
  }
}
