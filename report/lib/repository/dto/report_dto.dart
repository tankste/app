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
      case "price_petrol":
        return ReportField.pricePetrol;
      case "price_petrol_super_e5":
        return ReportField.pricePetrolSuperE5;
      case "price_petrol_super_e10":
        return ReportField.pricePetrolSuperE10;
      case "price_petrol_super_plus":
        return ReportField.pricePetrolSuperPlus;
      case "price_petrol_super_e5_additive":
        return ReportField.pricePetrolSuperE5Additive;
      case "price_petrol_super_e10_additive":
        return ReportField.pricePetrolSuperE10Additive;
      case "price_petrol_super_plus_additive":
        return ReportField.pricePetrolSuperPlusAdditive;
      case "price_diesel":
        return ReportField.priceDiesel;
      case "price_diesel_hvo100":
        return ReportField.priceDieselHvo100;
      case "price_diesel_additive":
        return ReportField.priceDieselAdditive;
      case "price_diesel_hvo100_additive":
        return ReportField.priceDieselHvo100Additive;
      case "price_diesel_Truck":
        return ReportField.priceDieselTruck;
      case "price_diesel_hvo100_truck":
        return ReportField.priceDieselHvo100Truck;
      case "price_lpg":
        return ReportField.priceLpg;
      case "price_adblue":
        return ReportField.priceAdblue;
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
      case ReportField.availability:
        return "availability";
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
      case ReportField.note:
        return "note";
      case ReportField.pricePetrol:
        return "price_petrol";
      case ReportField.pricePetrolSuperE5:
        return "price_petrol_super_e5";
      case ReportField.pricePetrolSuperE10:
        return "price_petrol_super_e10";
      case ReportField.pricePetrolSuperPlus:
        return "price_petrol_super_plus";
      case ReportField.pricePetrolSuperE5Additive:
        return "price_petrol_super_e5_additive";
      case ReportField.pricePetrolSuperE10Additive:
        return "price_petrol_super_e10_additive";
      case ReportField.pricePetrolSuperPlusAdditive:
        return "price_petrol_super_plus_additive";
      case ReportField.priceDiesel:
        return "price_diesel";
      case ReportField.priceDieselHvo100:
        return "price_diesel_hvo100";
      case ReportField.priceDieselAdditive:
        return "price_diesel_additive";
      case ReportField.priceDieselHvo100Additive:
        return "price_diesel_hvo100_additive";
      case ReportField.priceDieselTruck:
        return "price_diesel_Truck";
      case ReportField.priceDieselHvo100Truck:
        return "price_diesel_hvo100_truck";
      case ReportField.priceLpg:
        return "price_lpg";
      case ReportField.priceAdblue:
        return "price_adblue";
      case ReportField.unknown:
        return "unknown";
    }
  }
}
