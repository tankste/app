import 'package:collection/collection.dart';
import 'package:report/model/report_model.dart';

class ReportDto {
  final int? id;
  final int? stationId;
  final String? field;
  final String? wrongValue;
  final String? correctValue;
  final String? status;
  final String? deviceId;

  ReportDto({
    this.id,
    this.stationId,
    this.field,
    this.wrongValue,
    this.correctValue,
    this.status,
    this.deviceId,
  });

  factory ReportDto.fromModel(ReportModel model, String deviceId) {
    return ReportDto(
      id: model.id,
      stationId: model.stationId,
      deviceId: deviceId,
      field: _keyFromField(model.field),
      wrongValue: model.wrongValue,
      correctValue: model.correctValue,
      status: model.status.name,
    );
  }

  ReportModel toModel() {
    return ReportModel(
      id: id ?? -1,
      stationId: stationId ?? -1,
      field: _fieldFromString(field),
      wrongValue: wrongValue ?? "",
      correctValue: correctValue ?? "",
      status: ReportStatus.values.firstWhereOrNull((e) => e.name == status) ??
          ReportStatus.unknown,
    );
  }

  factory ReportDto.fromJson(Map<String, dynamic> json) {
    return ReportDto(
      id: json['id'] as int?,
      stationId: json['stationId'] as int?,
      field: json['field'] as String?,
      wrongValue: json['wrongValue'] as String?,
      correctValue: json['correctValue'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'deviceId': deviceId,
      'field': field,
      'wrongValue': wrongValue,
      'correctValue': correctValue,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'ReportDto{id: $id, stationId: $stationId, field: $field, wrongValue: $wrongValue, correctValue: $correctValue, status: $status}';
  }

  ReportField _fieldFromString(String? key) {
    switch (key) {
      case "name":
        return ReportField.name;
      case "brand":
        return ReportField.brand;
      case "location_latitude":
        return ReportField.locationLatitude;
      case "location_longitude":
        return ReportField.locationLongitude;
      case "address_street":
        return ReportField.addressStreet;
      case "address_house_number":
        return ReportField.addressHouseNumber;
      case "address_post_code":
        return ReportField.addressPostCode;
      case "address_city":
        return ReportField.addressCity;
      case "address_country":
        return ReportField.addressCountry;
      case "open_times_state":
        return ReportField.openTimesState;
      case "open_times":
        return ReportField.openTimes;
      case "price_e5":
        return ReportField.priceE5;
      case "price_e10":
        return ReportField.priceE10;
      case "price_diesel":
        return ReportField.priceDiesel;
      default:
        return ReportField.unknown;
    }
  }

  static String _keyFromField(ReportField field) {
    switch (field) {
      case ReportField.name:
        return "name";
      case ReportField.brand:
        return "brand";
      case ReportField.locationLatitude:
        return "location_latitude";
      case ReportField.locationLongitude:
        return "location_longitude";
      case ReportField.addressStreet:
        return "address_street";
      case ReportField.addressHouseNumber:
        return "address_house_number";
      case ReportField.addressPostCode:
        return "address_post_code";
      case ReportField.addressCity:
        return "address_city";
      case ReportField.addressCountry:
        return "address_country";
      case ReportField.openTimesState:
        return "open_times_state";
      case ReportField.openTimes:
        return "open_times";
        case ReportField.priceE5:
        return "price_e5";
        case ReportField.priceE10:
        return "price_e10";
        case ReportField.priceDiesel:
        return "price_diesel";
      default:
        return "unknown";
    }
  }
}
