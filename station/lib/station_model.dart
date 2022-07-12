import 'package:navigation/coordinate_model.dart';

class StationModel {
  final String id;
  final String name;
  final String company;
  final StationAddressModel address;
  final StationPricesModel prices;
  final CoordinateModel coordinate;
  final List<StationOpenTime> openTimes;
  final bool isOpen;

  StationModel(this.id, this.name, this.company, this.address, this.prices,
      this.coordinate, this.openTimes, this.isOpen);

  factory StationModel.fromJson(Map<String, dynamic> parsedJson) {
    return StationModel(
      parsedJson['id'] ?? "",
      parsedJson['name']?.trim() ?? "",
      parsedJson['brand']?.trim() ?? "",
      StationAddressModel(
        parsedJson['street']?.trim() ?? "",
        parsedJson['houseNumber']?.toString().trim() ?? "",
        parsedJson['postCode']?.toString().trim() ?? "",
        parsedJson['place']?.trim() ?? "",
      ),
      StationPricesModel(
        parsedJson['e5'] ?? 0.0,
        parsedJson['e10'] ?? 0.0,
        parsedJson['diesel'] ?? 0.0,
      ),
      CoordinateModel(
        parsedJson['lat'] ?? "",
        parsedJson['lng'] ?? "",
      ),
      _parseOpenTimes(parsedJson),
      parsedJson['isOpen'] ?? false,
    );
  }

  static List<StationOpenTime> _parseOpenTimes(Map<String, dynamic> parsedJson) {
    if (parsedJson['wholeDay']) {
      return [StationOpenTime("Täglich", "00:00", "24:00")];
    }

    return (parsedJson['openingTimes'] as List<dynamic>)
        // TODO: Bad solution & substring can crash, should be parsed as local time instead of string type
        .map((e) => StationOpenTime(e['text'], e['start'].toString().substring(0, 5), e['end'].toString().substring(0, 5)))
        .toList();
  }

  get label => company != "" ? company : name;
}

class StationAddressModel {
  final String street;
  final String houseNumber;
  final String postCode;
  final String city;

  StationAddressModel(this.street, this.houseNumber, this.postCode, this.city);
}

class StationPricesModel {
  final double e5;
  final double e10;
  final double diesel;

  StationPricesModel(this.e5, this.e10, this.diesel);
}

class StationOpenTime {
  final String label;
  final String start;
  final String end;

  StationOpenTime(this.label, this.start, this.end);
}
