class CameraPositionModel {
  final double latitude;
  final double longitude;
  final double zoom;
  final double bearing;

  CameraPositionModel(
      {required this.latitude, required this.longitude, required this.zoom, required this.bearing});

  @override
  String toString() {
    return 'CameraPosition(latitude: $latitude, longitude: $longitude, zoom: $zoom, bearing: $bearing)';
  }
}
