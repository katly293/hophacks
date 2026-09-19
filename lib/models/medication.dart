import 'package:flutter/material.dart';

enum TimeOfDayType {
  morning,
  noon,
  evening,
  night;

  String get displayName {
    switch (this) {
      case TimeOfDayType.morning:
        return 'Morning';
      case TimeOfDayType.noon:
        return 'Noon';
      case TimeOfDayType.evening:
        return 'Evening';
      case TimeOfDayType.night:
        return 'Night';
    }
  }

  IconData get icon {
    switch (this) {
      case TimeOfDayType.morning:
        return Icons.wb_sunny_outlined;
      case TimeOfDayType.noon:
        return Icons.wb_sunny_rounded;
      case TimeOfDayType.evening:
        return Icons.wb_twilight_rounded;
      case TimeOfDayType.night:
        return Icons.bedtime_outlined;
    }
  }

  TimeOfDay get defaultTime {
    switch (this) {
      case TimeOfDayType.morning:
        return const TimeOfDay(hour: 8, minute: 0);
      case TimeOfDayType.noon:
        return const TimeOfDay(hour: 12, minute: 0);
      case TimeOfDayType.evening:
        return const TimeOfDay(hour: 18, minute: 0);
      case TimeOfDayType.night:
        return const TimeOfDay(hour: 22, minute: 0);
    }
  }
}

class TimeSlotConfig {
  final TimeOfDayType type;
  bool isEnabled;
  TimeOfDay time;

  TimeSlotConfig({
    required this.type,
    this.isEnabled = false,
    required this.time,
  });

  TimeSlotConfig copyWith({
    bool? isEnabled,
    TimeOfDay? time,
  }) {
    return TimeSlotConfig(
      type: type,
      isEnabled: isEnabled ?? this.isEnabled,
      time: time ?? this.time,
    );
  }

  String formatTime(BuildContext context) {
    return time.format(context);
  }
}

class Medication {
  final String id;
  final String name;
  final String dosage;
  final String instructions;
  final List<TimeSlotConfig> slots;
  final Set<String> days; // e.g. {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'}
  final Set<TimeOfDayType> takenSlotsToday; // slots marked taken today

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.slots,
    required this.days,
    Set<TimeOfDayType>? takenSlotsToday,
  }) : takenSlotsToday = takenSlotsToday ?? <TimeOfDayType>{};

  List<TimeSlotConfig> get activeSlots =>
      slots.where((s) => s.isEnabled).toList();

  bool isScheduledForDay(String dayAbbr) => days.contains(dayAbbr);

  bool isTakenFor(TimeOfDayType type) => takenSlotsToday.contains(type);

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? instructions,
    List<TimeSlotConfig>? slots,
    Set<String>? days,
    Set<TimeOfDayType>? takenSlotsToday,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      instructions: instructions ?? this.instructions,
      slots: slots ?? this.slots,
      days: days ?? this.days,
      takenSlotsToday: takenSlotsToday ?? this.takenSlotsToday,
    );
  }

  static List<Medication> get initialSampleData => [
        Medication(
          id: 'med-1',
          name: 'Amoxicillin',
          dosage: '500 mg (1 capsule)',
          instructions: 'Take with food',
          days: {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'},
          slots: [
            TimeSlotConfig(
              type: TimeOfDayType.morning,
              isEnabled: true,
              time: const TimeOfDay(hour: 8, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.noon,
              isEnabled: true,
              time: const TimeOfDay(hour: 13, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.evening,
              isEnabled: true,
              time: const TimeOfDay(hour: 20, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.night,
              isEnabled: false,
              time: const TimeOfDay(hour: 22, minute: 0),
            ),
          ],
          takenSlotsToday: {TimeOfDayType.morning},
        ),
        Medication(
          id: 'med-2',
          name: 'Vitamin D3',
          dosage: '2000 IU (1 softgel)',
          instructions: 'Take with water',
          days: {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'},
          slots: [
            TimeSlotConfig(
              type: TimeOfDayType.morning,
              isEnabled: true,
              time: const TimeOfDay(hour: 9, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.noon,
              isEnabled: false,
              time: const TimeOfDay(hour: 12, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.evening,
              isEnabled: false,
              time: const TimeOfDay(hour: 18, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.night,
              isEnabled: false,
              time: const TimeOfDay(hour: 21, minute: 0),
            ),
          ],
          takenSlotsToday: {TimeOfDayType.morning},
        ),
        Medication(
          id: 'med-3',
          name: 'Magnesium Glycinate',
          dosage: '200 mg (2 tablets)',
          instructions: 'Take on empty stomach',
          days: {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'},
          slots: [
            TimeSlotConfig(
              type: TimeOfDayType.morning,
              isEnabled: false,
              time: const TimeOfDay(hour: 8, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.noon,
              isEnabled: false,
              time: const TimeOfDay(hour: 12, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.evening,
              isEnabled: false,
              time: const TimeOfDay(hour: 18, minute: 0),
            ),
            TimeSlotConfig(
              type: TimeOfDayType.night,
              isEnabled: true,
              time: const TimeOfDay(hour: 22, minute: 30),
            ),
          ],
          takenSlotsToday: {},
        ),
      ];
}
