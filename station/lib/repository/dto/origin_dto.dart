import 'package:station/model/origin_model.dart';

class OriginDto {
  final int? id;
  final String? name;
  final String? shortName;
  final String? iconImageUrl;
  final String? imageUrl;
  final String? websiteUrl;

  OriginDto(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.iconImageUrl,
      required this.imageUrl,
      required this.websiteUrl});

  factory OriginDto.fromJson(Map<String, dynamic> parsedJson) {
    return OriginDto(
      id: parsedJson['id'],
      name: parsedJson['name'],
      shortName: parsedJson['shortName'],
      iconImageUrl: parsedJson['iconImageUrl'],
      imageUrl: parsedJson['imageUrl'],
      websiteUrl: parsedJson['websiteUrl'],
    );
  }

  OriginModel toModel() {
    return OriginModel(
      id: id ?? -1,
      name: name ?? "",
      shortName: shortName ?? "",
      iconImageUrl: iconImageUrl != null ? Uri.parse(iconImageUrl!) : Uri(),
      imageUrl: imageUrl != null ? Uri.parse(imageUrl!) : Uri(),
      websiteUrl: websiteUrl != null ? Uri.parse(websiteUrl!) : Uri(),
    );
  }

  @override
  String toString() {
    return 'OriginDto{id: $id, name: $name, shortName: $shortName, iconImageUrl: $iconImageUrl, imageUrl: $imageUrl, websiteUrl: $websiteUrl}';
  }
}

class LocationDto {
  final double? locationLatitude;
  final double? locationLongitude;

  LocationDto({
    required this.locationLatitude,
    required this.locationLongitude,
  });

  @override
  String toString() {
    return 'LocationDto{locationLatitude: $locationLatitude, locationLongitude: $locationLongitude}';
  }
}

class AddressDto {
  final String? addressStreet;
  final String? addressHouseNumber;
  final String? addressPostCode;
  final String? addressCity;
  final String? addressCountry;

  AddressDto({
    required this.addressStreet,
    required this.addressHouseNumber,
    required this.addressPostCode,
    required this.addressCity,
    required this.addressCountry,
  });

  @override
  String toString() {
    return 'AddressDto{addressStreet: $addressStreet, addressHouseNumber: $addressHouseNumber, addressPostCode: $addressPostCode, addressCity: $addressCity, addressCountry: $addressCountry}';
  }
}
