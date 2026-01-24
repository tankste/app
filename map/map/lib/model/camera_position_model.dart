class CameraPositionModel {
  final double latitude;
  final double longitude;
  final double zoom;

  CameraPositionModel(
      {required this.latitude, required this.longitude, required this.zoom});

  @override
  String toString() {
    return 'CameraPosition(latitude: $latitude, longitude: $longitude, zoom: $zoom)';
  }
}
