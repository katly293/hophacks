import 'package:flutter/material.dart';
import '../models/medication.dart';

class TimeSlotPicker extends StatelessWidget {
  final List<TimeSlotConfig> slots;
  final void Function(TimeOfDayType type, bool isEnabled) onToggleSlot;
  final void Function(TimeOfDayType type, TimeOfDay newTime) onTimeChanged;

  const TimeSlotPicker({
    super.key,
    required this.slots,
    required this.onToggleSlot,
    required this.onTimeChanged,
  });

  String _getSubtitle(TimeOfDayType type) {
    switch (type) {
      case TimeOfDayType.morning:
        return 'With breakfast or upon waking';
      case TimeOfDayType.noon:
        return 'Lunchtime or midday';
      case TimeOfDayType.evening:
        return 'Dinnertime or early evening';
      case TimeOfDayType.night:
        return 'Before bedtime';
    }
  }

  Color _getSlotColor(TimeOfDayType type) {
    switch (type) {
      case TimeOfDayType.morning:
        return const Color(0xFFD97706); // Warm Amber
      case TimeOfDayType.noon:
        return const Color(0xFF0284C7); // Sky Blue
      case TimeOfDayType.evening:
        return const Color(0xFF7C3AED); // Twilight Violet
      case TimeOfDayType.night:
        return const Color(0xFF334155); // Slate / Indigo
    }
  }

  Color _getSlotBgColor(TimeOfDayType type) {
    switch (type) {
      case TimeOfDayType.morning:
        return const Color(0xFFFEF3C7);
      case TimeOfDayType.noon:
        return const Color(0xFFE0F2FE);
      case TimeOfDayType.evening:
        return const Color(0xFFEDE9FE);
      case TimeOfDayType.night:
        return const Color(0xFFF1F5F9);
    }
  }

  Future<void> _selectTime(
      BuildContext context, TimeOfDayType type, TimeOfDay currentTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F766E),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeChanged(type, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time of Day',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Toggle each time slot and tap to adjust the scheduled time',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 12),
        ...slots.map((slot) {
          final slotColor = _getSlotColor(slot.type);
          final slotBgColor = _getSlotBgColor(slot.type);

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: slot.isEnabled ? Colors.white : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: slot.isEnabled
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFFE2E8F0),
                width: slot.isEnabled ? 1.5 : 1,
              ),
              boxShadow: slot.isEnabled
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Slot icon badge
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: slotBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    slot.type.icon,
                    size: 20,
                    color: slotColor,
                  ),
                ),
                const SizedBox(width: 12),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slot.type.displayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: slot.isEnabled
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getSubtitle(slot.type),
                        style: TextStyle(
                          fontSize: 11,
                          color: slot.isEnabled
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle switch
                Switch(
                  value: slot.isEnabled,
                  activeColor: const Color(0xFF0F766E),
                  onChanged: (bool value) => onToggleSlot(slot.type, value),
                ),
                const SizedBox(width: 4),
                // Time setter button
                InkWell(
                  onTap: slot.isEnabled
                      ? () => _selectTime(context, slot.type, slot.time)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: slot.isEnabled
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFFF1F5F9).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: slot.isEnabled
                            ? const Color(0xFFCBD5E1)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: slot.isEnabled
                              ? const Color(0xFF0F766E)
                              : const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          slot.formatTime(context),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: slot.isEnabled
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
