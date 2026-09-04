/// A fundi's working availability schedule.
class Availability {
  final String fundiId;
  final bool isAvailable;
  final List<String> workingDays;
  final String startTime;
  final String endTime;

  const Availability({
    required this.fundiId,
    required this.isAvailable,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
  });

  Availability copyWith({
    bool? isAvailable,
    List<String>? workingDays,
    String? startTime,
    String? endTime,
  }) {
    return Availability(
      fundiId: fundiId,
      isAvailable: isAvailable ?? this.isAvailable,
      workingDays: workingDays ?? this.workingDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}