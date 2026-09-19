import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final Set<String> selectedDays;
  final void Function(Set<String> newDays) onDaysChanged;

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
  });

  static const List<Map<String, String>> _days = [
    {'abbr': 'Mon', 'label': 'M'},
    {'abbr': 'Tue', 'label': 'T'},
    {'abbr': 'Wed', 'label': 'W'},
    {'abbr': 'Thu', 'label': 'T'},
    {'abbr': 'Fri', 'label': 'F'},
    {'abbr': 'Sat', 'label': 'S'},
    {'abbr': 'Sun', 'label': 'S'},
  ];

  void _toggleDay(String dayAbbr) {
    final updated = Set<String>.from(selectedDays);
    if (updated.contains(dayAbbr)) {
      if (updated.length > 1) {
        // Keep at least one day selected
        updated.remove(dayAbbr);
      }
    } else {
      updated.add(dayAbbr);
    }
    onDaysChanged(updated);
  }

  void _applyPreset(Set<String> preset) {
    onDaysChanged(preset);
  }

  @override
  Widget build(BuildContext context) {
    final isEveryDay = selectedDays.length == 7;
    final isWeekdays = selectedDays.length == 5 &&
        !selectedDays.contains('Sat') &&
        !selectedDays.contains('Sun');
    final isWeekends = selectedDays.length == 2 &&
        selectedDays.contains('Sat') &&
        selectedDays.contains('Sun');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Days of the Week',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
            Text(
              isEveryDay
                  ? 'Every day'
                  : isWeekdays
                      ? 'Weekdays'
                      : isWeekends
                          ? 'Weekends'
                          : '${selectedDays.length} days/week',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F766E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Day circle buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _days.map((d) {
            final abbr = d['abbr']!;
            final label = d['label']!;
            final isSelected = selectedDays.contains(abbr);

            return InkWell(
              onTap: () => _toggleDay(abbr),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 42,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F766E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0F766E)
                        : const Color(0xFFCBD5E1),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF0F766E).withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      abbr.substring(0, 3),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white.withOpacity(0.85)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        // Quick Presets
        Row(
          children: [
            _PresetChip(
              label: 'Every day',
              isSelected: isEveryDay,
              onTap: () => _applyPreset({
                'Mon',
                'Tue',
                'Wed',
                'Thu',
                'Fri',
                'Sat',
                'Sun',
              }),
            ),
            const SizedBox(width: 8),
            _PresetChip(
              label: 'Weekdays',
              isSelected: isWeekdays,
              onTap: () => _applyPreset({
                'Mon',
                'Tue',
                'Wed',
                'Thu',
                'Fri',
              }),
            ),
            const SizedBox(width: 8),
            _PresetChip(
              label: 'Weekends',
              isSelected: isWeekends,
              onTap: () => _applyPreset({
                'Sat',
                'Sun',
              }),
            ),
          ],
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFCCFBF1)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0F766E).withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF0F766E)
                : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
