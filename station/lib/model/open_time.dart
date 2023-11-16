class OpenTimeModel {
  final int id;
  final OpenTimeDay day;
  final DateTime startTime; //TODO: find other format (only time, without date)
  final DateTime endTime; //TODO: find other format (only time, without date)

  OpenTimeModel(
      {required this.id,
      required this.day,
      required this.startTime,
      required this.endTime});

  @override
  String toString() {
    return 'OpenTimeModel{id: $id, day: $day, startTime: $startTime, endTime: $endTime}';
  }
}

enum OpenTimeDay {
  unknown,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
  publicHoliday;

  int toDayOfWeek() {
    switch (this) {
      case OpenTimeDay.unknown:
        return 0;
      case OpenTimeDay.monday:
        return 1;
      case OpenTimeDay.tuesday:
        return 2;
      case OpenTimeDay.wednesday:
        return 3;
      case OpenTimeDay.thursday:
        return 4;
      case OpenTimeDay.friday:
        return 5;
      case OpenTimeDay.saturday:
        return 6;
      case OpenTimeDay.sunday:
        return 7;
      case OpenTimeDay.publicHoliday:
        return -1;
    }
  }
}
