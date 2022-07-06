
class GasStationModel {
  final String id;
  final double lat;
  final double lng;
  final String name;
  final String brand;
  final String street;
  final String place;
  final double price;
  final bool isOpen;

  GasStationModel(this.id, this.lat, this.lng, this.name, this.brand, this.street, this.place, this.price, this.isOpen);

  factory GasStationModel.fromJson(Map<String, dynamic> parsedJson) {
    return GasStationModel(
        parsedJson['id'] ?? "",
        parsedJson['lat'] ?? 0.0,
        parsedJson['lng'] ?? 0.0,
        parsedJson['name'] ?? "",
        parsedJson['brand'] ?? "",
        parsedJson['street'] ?? "",
        parsedJson['place'] ?? "",
        parsedJson['price'] ?? 0.0,
        parsedJson['isOpen'] ?? false,
    );
  }
}