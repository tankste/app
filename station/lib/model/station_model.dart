import 'package:navigation/coordinate_model.dart';

class StationModel {
  final int id;
  final String name;
  final String brand;
  final StationAddressModel address;
  final CoordinateModel coordinate;

  StationModel(
      {required this.id,
      required this.name,
      required this.brand,
      required this.address,
      required this.coordinate});

  @override
  String toString() {
    return 'StationModel{id: $id, name: $name, brand: $brand, address: $address, coordinate: $coordinate}';
  }
}

class StationAddressModel {
  final String street;
  final String houseNumber;
  final String postCode;
  final String city;
  final String country;

  StationAddressModel(
      {required this.street,
      required this.houseNumber,
      required this.postCode,
      required this.city,
      required this.country});

  @override
  String toString() {
    return 'StationAddressModel{street: $street, houseNumber: $houseNumber, postCode: $postCode, city: $city, country: $country}';
  }
}
