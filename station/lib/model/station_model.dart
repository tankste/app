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

  factory StationModel.fromJson(
      Map<String, dynamic> parsedJson, String? priceType) {
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
        (priceType == "e5"
                ? _parseDouble(parsedJson['price'])
                : _parseDouble(parsedJson['e5'])) ??
            0.0,
        StationPriceRange.unknown,
        (priceType == "e10"
                ? _parseDouble(parsedJson['price'])
                : _parseDouble(parsedJson['e10'])) ??
            0.0,
        StationPriceRange.unknown,
        (priceType == "diesel"
                ? _parseDouble(parsedJson['price'])
                : _parseDouble(parsedJson['diesel'])) ??
            0.0,
        StationPriceRange.unknown,
      ),
      CoordinateModel(
        _parseDouble(parsedJson['lat']) ?? 0.0,
        _parseDouble(parsedJson['lng']) ?? 0.0,
      ),
      _parseOpenTimes(parsedJson),
      parsedJson['isOpen'] ?? false,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return null;
  }

  static List<StationOpenTime> _parseOpenTimes(
      Map<String, dynamic> parsedJson) {
    if (parsedJson['wholeDay'] == true) {
      return [StationOpenTime("Täglich", "00:00", "24:00")];
    }

    if (parsedJson['openingTimes'] == null) {
      return [];
    }

    return (parsedJson['openingTimes'] as List<dynamic>)
        // TODO: Bad solution & substring can crash, should be parsed as local time instead of string type
        .map((e) => StationOpenTime(
            e['text'],
            e['start'].toString().substring(0, 5),
            e['end'].toString().substring(0, 5)))
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
  final StationPriceRange e5Range;
  final double e10;
  final StationPriceRange e10Range;
  final double diesel;
  final StationPriceRange dieselRange;

  StationPricesModel(this.e5, this.e5Range, this.e10, this.e10Range,
      this.diesel, this.dieselRange);

  // TODO: Currently only one price-range is fetched and available.
  //  Lookup only for selected filter price instead for checking all prices
  double? getFirstPrice() {
    if (e5 != 0.0) {
      return e5;
    }

    if (e10 != 0.0) {
      return e10;
    }

    if (diesel != 0.0) {
      return diesel;
    }

    return null;
  }

  // TODO: Currently only one price-range is fetched and available.
  //  Lookup only for selected filter price instead for checking all prices
  StationPriceRange? getFirstPriceRange() {
    if (e5Range != StationPriceRange.unknown) {
      return e5Range;
    }

    if (e10Range != StationPriceRange.unknown) {
      return e10Range;
    }

    if (dieselRange != StationPriceRange.unknown) {
      return dieselRange;
    }

    return null;
  }
}

enum StationPriceRange { unknown, cheap, normal, expensive }

class StationOpenTime {
  final String label;
  final String start;
  final String end;

  StationOpenTime(this.label, this.start, this.end);
}
