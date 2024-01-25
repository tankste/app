class ReportModel {
  final int id;
  final int stationId;
  final ReportField field;
  final String wrongValue;
  final String correctValue;
  final ReportStatus status;

  ReportModel({
    required this.id,
    required this.stationId,
    required this.field,
    required this.wrongValue,
    required this.correctValue,
    required this.status,
  });

  @override
  String toString() {
    return 'ReportModel(id: $id, stationId: $stationId, field: $field, wrongValue: $wrongValue, correctValue: $correctValue, status: $status)';
  }
}

enum ReportField {
  unknown,
  name,
  brand,
  availability,
  addressStreet,
  addressHouseNumber,
  addressPostCode,
  addressCity,
  addressCountry,
  locationLatitude,
  locationLongitude,
  priceE5,
  priceE10,
  priceDiesel,
  openTimesState,
  openTimes,
  note
}

enum ReportStatus { unknown, open, corrected, invalid, ignored }
