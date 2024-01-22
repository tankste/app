import 'package:station/model/open_time.dart';
import 'package:intl/intl.dart';

class OpenTimeDto {
  final int? id;
  final int? originId;
  final String? day;
  final String? startTime;
  final String? endTime;
  final bool? isToday;

  OpenTimeDto({
    required this.id,
    required this.originId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.isToday,
  });

  factory OpenTimeDto.fromJson(Map<String, dynamic> parsedJson) {
    return OpenTimeDto(
      id: parsedJson['id'],
      originId: parsedJson['originId'],
      day: parsedJson['day'],
      startTime: parsedJson['startTime'],
      endTime: parsedJson['endTime'],
      isToday: parsedJson['isToday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originId': originId,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'isToday': isToday,
    };
  }

  factory OpenTimeDto.fromModel(OpenTimeModel model) {
    return OpenTimeDto(
      id: model.id,
      originId: model.originId,
      day: _dayToJson(model.day),
      startTime: DateFormat('HH:mm:ss').format(model.startTime),
      endTime: DateFormat('HH:mm:ss').format(model.endTime),
      isToday: model.isToday,
    );
  }

  OpenTimeModel toModel() {
    return OpenTimeModel(
      id: id ?? -1,
      originId: originId ?? -1,
      day: _parseDay(day),
      startTime: startTime != null
          ? DateFormat('HH:mm:ss').parse(startTime!)
          : DateTime(0),
      endTime: endTime != null
          ? DateFormat('HH:mm:ss').parse(endTime!)
          : DateTime(0),
      isToday: isToday ?? false,
    );
  }

  OpenTimeDay _parseDay(String? value) {
    switch (value) {
      case "monday":
        return OpenTimeDay.monday;
      case "tuesday":
        return OpenTimeDay.tuesday;
      case "wednesday":
        return OpenTimeDay.wednesday;
      case "thursday":
        return OpenTimeDay.thursday;
      case "friday":
        return OpenTimeDay.friday;
      case "saturday":
        return OpenTimeDay.saturday;
      case "sunday":
        return OpenTimeDay.sunday;
      case "public_holiday":
        return OpenTimeDay.publicHoliday;
      default:
        return OpenTimeDay.unknown;
    }
  }

  static String _dayToJson(OpenTimeDay value) {
    switch (value) {
      case OpenTimeDay.monday:
        return "monday";
      case OpenTimeDay.tuesday:
        return "tuesday";
      case OpenTimeDay.wednesday:
        return "wednesday";
      case OpenTimeDay.thursday:
        return "thursday";
      case OpenTimeDay.friday:
        return "friday";
      case OpenTimeDay.saturday:
        return "saturday";
      case OpenTimeDay.sunday:
        return "sunday";
      case OpenTimeDay.publicHoliday:
        return "public_holiday";
      default:
        return "unknown";
    }
  }

  @override
  String toString() {
    return 'OpenTimeDto{id: $id, day: $day, startTime: $startTime, endTime: $endTime}';
  }
}
