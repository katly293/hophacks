import 'package:flutter/material.dart';
import '../models/medication.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final void Function(TimeOfDayType slotType) onToggleTaken;
  final VoidCallback onDelete;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onToggleTaken,
    required this.onDelete,
  });

  static const List<Map<String, String>> _allDays = [
    {'abbr': 'Mon', 'label': 'M'},
    {'abbr': 'Tue', 'label': 'T'},
    {'abbr': 'Wed', 'label': 'W'},
    {'abbr': 'Thu', 'label': 'T'},
    {'abbr': 'Fri', 'label': 'F'},
    {'abbr': 'Sat', 'label': 'S'},
    {'abbr': 'Sun', 'label': 'S'},
  ];

  Color _getSlotColor(TimeOfDayType type) {
    switch (type) {
      case TimeOfDayType.morning:
        return const Color(0xFFD97706);
      case TimeOfDayType.noon:
        return const Color(0xFF0284C7);
      case TimeOfDayType.evening:
        return const Color(0xFF7C3AED);
      case TimeOfDayType.night:
        return const Color(0xFF334155);
    }
  }

  Color _getSlotBg(TimeOfDayType type) {
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

  @override
  Widget build(BuildContext context) {
    final activeSlots = medication.activeSlots;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title, Dosage, and Options Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medication_rounded,
                    color: Color(0xFF0F766E),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        medication.dosage,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              color: Color(0xFFDC2626), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Instructions chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    medication.instructions,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 12),

            // Today's Time Slots with Taken Toggles
            const Text(
              'TODAY\'S DOSES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),

            if (activeSlots.isEmpty)
              const Text(
                'No time slots configured',
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: activeSlots.map((slot) {
                  final isTaken = medication.isTakenFor(slot.type);
                  final slotColor = _getSlotColor(slot.type);
                  final slotBg = _getSlotBg(slot.type);

                  return InkWell(
                    onTap: () => onToggleTaken(slot.type),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isTaken
                            ? const Color(0xFFF0FDF4) // Soft green for taken
                            : slotBg.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isTaken
                              ? const Color(0xFF86EFAC)
                              : slotColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isTaken
                                ? Icons.check_circle_rounded
                                : slot.type.icon,
                            size: 15,
                            color: isTaken
                                ? const Color(0xFF16A34A)
                                : slotColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${slot.type.displayName} • ${slot.formatTime(context)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              decoration:
                                  isTaken ? TextDecoration.lineThrough : null,
                              color: isTaken
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 14),

            // Active Days Row
            Row(
              children: [
                const Text(
                  'Days: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 6),
                ..._allDays.map((d) {
                  final isDayActive = medication.isScheduledForDay(d['abbr']!);
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isDayActive
                          ? const Color(0xFF0F766E)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      d['label']!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color:
                            isDayActive ? Colors.white : const Color(0xFF94A3B8),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
