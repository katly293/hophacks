import 'package:flutter/material.dart';
import 'models/medication.dart';
import 'widgets/medication_card.dart';
import 'widgets/add_medication_sheet.dart';

void main() {
  runApp(const MedicationTrackerApp());
}

class MedicationTrackerApp extends StatelessWidget {
  const MedicationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          primary: const Color(0xFF0F766E),
          secondary: const Color(0xFF0D9488),
          surface: Colors.white,
          background: const Color(0xFFF8FAFC),
        ),
        fontFamily: null, // Uses system font with clean proportions
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
        ),
      ),
      home: const MedicationTrackerHomePage(),
    );
  }
}

class MedicationTrackerHomePage extends StatefulWidget {
  const MedicationTrackerHomePage({super.key});

  @override
  State<MedicationTrackerHomePage> createState() =>
      _MedicationTrackerHomePageState();
}

class _MedicationTrackerHomePageState extends State<MedicationTrackerHomePage> {
  List<Medication> _medications = Medication.initialSampleData;
  int _selectedFilterIndex = 0; // 0: Today's Schedule, 1: All Medications

  // Current day abbreviation for schedule filtering
  String get _currentDayAbbr {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[now.weekday - 1];
  }

  String get _formattedCurrentDate {
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    return '$weekday, $month ${now.day}';
  }

  List<Medication> get _displayedMedications {
    if (_selectedFilterIndex == 0) {
      // Filter for today
      return _medications
          .where((m) => m.isScheduledForDay(_currentDayAbbr))
          .toList();
    }
    return _medications;
  }

  int get _totalDosesToday {
    int total = 0;
    for (final med in _medications) {
      if (med.isScheduledForDay(_currentDayAbbr)) {
        total += med.activeSlots.length;
      }
    }
    return total;
  }

  int get _takenDosesToday {
    int taken = 0;
    for (final med in _medications) {
      if (med.isScheduledForDay(_currentDayAbbr)) {
        taken += med.takenSlotsToday.length;
      }
    }
    return taken;
  }

  void _openAddMedicationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.90,
          child: AddMedicationSheet(
            onSave: (newMedication) {
              setState(() {
                _medications.insert(0, newMedication);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${newMedication.name} added successfully!'),
                  backgroundColor: const Color(0xFF0F766E),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _toggleTaken(Medication medication, TimeOfDayType slotType) {
    setState(() {
      final updatedTaken = Set<TimeOfDayType>.from(medication.takenSlotsToday);
      if (updatedTaken.contains(slotType)) {
        updatedTaken.remove(slotType);
      } else {
        updatedTaken.add(slotType);
      }

      final index = _medications.indexWhere((m) => m.id == medication.id);
      if (index != -1) {
        _medications[index] =
            medication.copyWith(takenSlotsToday: updatedTaken);
      }
    });
  }

  void _deleteMedication(Medication medication) {
    final deletedIndex = _medications.indexWhere((m) => m.id == medication.id);
    setState(() {
      _medications.removeWhere((m) => m.id == medication.id);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medication.name} deleted'),
        backgroundColor: const Color(0xFF334155),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFF2DD4BF),
          onPressed: () {
            setState(() {
              _medications.insert(deletedIndex, medication);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedList = _displayedMedications;
    final totalDoses = _totalDosesToday;
    final takenDoses = _takenDosesToday;
    final progress = totalDoses > 0 ? (takenDoses / totalDoses) : 0.0;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date & Status row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formattedCurrentDate.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCCFBF1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0F766E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Active Tracking',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F766E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Title
                    const Text(
                      'Medication Tracker',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Keep track of your daily doses and schedules',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Today's Adherence Summary Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Today\'s Progress',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    totalDoses == 0
                                        ? 'No doses scheduled for today'
                                        : '$takenDoses of $totalDoses doses completed',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F766E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF0F766E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Segmented Filter Controls
                    Row(
                      children: [
                        _FilterButton(
                          label: 'Today\'s Schedule',
                          count: _medications
                              .where((m) => m.isScheduledForDay(_currentDayAbbr))
                              .length,
                          isSelected: _selectedFilterIndex == 0,
                          onTap: () {
                            setState(() {
                              _selectedFilterIndex = 0;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterButton(
                          label: 'All Medications',
                          count: _medications.length,
                          isSelected: _selectedFilterIndex == 1,
                          onTap: () {
                            setState(() {
                              _selectedFilterIndex = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Medication List or Empty State
            if (displayedList.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.medication_outlined,
                            size: 32,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilterIndex == 0
                              ? 'No medications scheduled for today'
                              : 'No medications added yet',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tap the + button below to add your first medication.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final medication = displayedList[index];
                      return MedicationCard(
                        key: ValueKey(medication.id),
                        medication: medication,
                        onToggleTaken: (slotType) =>
                            _toggleTaken(medication, slotType),
                        onDelete: () => _deleteMedication(medication),
                      );
                    },
                    childCount: displayedList.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddMedicationSheet,
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Medication',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0F172A)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
