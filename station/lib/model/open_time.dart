class OpenTimeModel {
  final int id;
  final int originId;
  final OpenTimeDay day;
  final DateTime startTime; //TODO: find other format (only time, without date)
  final DateTime endTime; //TODO: find other format (only time, without date)
  final bool isToday;

  OpenTimeModel(
      {required this.id,
      required this.originId,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.isToday});

  @override
  String toString() {
    return 'OpenTimeModel{id: $id, originId: $originId, day: $day, startTime: $startTime, endTime: $endTime, isToday: $isToday}';
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
}
