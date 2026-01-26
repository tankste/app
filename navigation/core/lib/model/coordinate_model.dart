class CoordinateModel {
  final double latitude;
  final double longitude;

  CoordinateModel({required this.latitude, required this.longitude});

  @override
  String toString() {
    return 'CoordinateModel{latitude: $latitude, longitude: $longitude}';
  }
}
