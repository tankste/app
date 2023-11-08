import 'package:navigation/coordinate_model.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/model/station_model.dart';

class StationDto {
  final int? id;
  final String? name;
  final String? brand;
  final LocationDto location;
  final AddressDto address;

  StationDto({
    required this.id,
    required this.name,
    required this.brand,
    required this.location,
    required this.address,
  });

  factory StationDto.fromJson(Map<String, dynamic> parsedJson) {
    return StationDto(
      id: parsedJson['id'],
      name: parsedJson['name'],
      brand: parsedJson['brand'],
      location: LocationDto(
        locationLatitude: parsedJson['location']['latitude'],
        locationLongitude: parsedJson['location']['longitude'],
      ),
      address: AddressDto(
        addressStreet: parsedJson['address']['street'],
        addressHouseNumber: parsedJson['address']['houseNumber'],
        addressPostCode: parsedJson['address']['postCode'],
        addressCity: parsedJson['address']['city'],
        addressCountry: parsedJson['address']['country'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'location': {
        'latitude': location.locationLatitude,
        'longitude': location.locationLongitude,
      },
      'address': {
        'street': address.addressStreet,
        'houseNumber': address.addressHouseNumber,
        'postCode': address.addressPostCode,
        'city': address.addressCity,
        'country': address.addressCountry,
      },
    };
  }

  factory StationDto.fromModel(StationModel model) {
    return StationDto(
      id: model.id,
      name: model.name,
      brand: model.brand,
      location: LocationDto(
        locationLatitude: model.coordinate.latitude,
        locationLongitude: model.coordinate.longitude,
      ),
      address: AddressDto(
        addressStreet: model.address.street,
        addressHouseNumber: model.address.houseNumber,
        addressPostCode: model.address.postCode,
        addressCity: model.address.city,
        addressCountry: model.address.country,
      ),
    );
  }

  StationModel toModel() {
    return StationModel(
      id: id ?? -1,
      name: name ?? "",
      brand: brand ?? "",
      coordinate: CoordinateModel(
        latitude: location.locationLatitude ?? 0,
        longitude: location.locationLongitude ?? 0,
      ),
      address: StationAddressModel(
        street: address.addressStreet ?? "",
        houseNumber: address.addressHouseNumber ?? "",
        postCode: address.addressPostCode ?? "",
        city: address.addressCity ?? "",
        country: address.addressCountry ?? "",
      ),
    );
  }

  @override
  String toString() {
    return 'StationDto{id: $id, name: $name, brand: $brand, location: $location, address: $address}';
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
