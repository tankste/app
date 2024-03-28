import 'package:navigation/coordinate_model.dart';
import 'package:station/model/currency_model.dart';

class StationModel {
  final int id;
  final int originId;
  final String name;
  final String brand;
  final StationAddressModel address;
  final CoordinateModel coordinate;
  final bool isOpen;
  final CurrencyModel currency;

  StationModel(
      {required this.id,
      required this.originId,
      required this.name,
      required this.brand,
      required this.address,
      required this.coordinate,
      required this.isOpen,
      required this.currency});

  @override
  String toString() {
    return 'StationModel{id: $id, originId: $originId, name: $name, brand: $brand, address: $address, coordinate: $coordinate, isOpen: $isOpen, currency: $currency}';
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
