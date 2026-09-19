import 'package:flutter/material.dart';
import '../models/medication.dart';
import 'time_slot_picker.dart';
import 'day_selector.dart';

class AddMedicationSheet extends StatefulWidget {
  final void Function(Medication newMedication) onSave;

  const AddMedicationSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends State<AddMedicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();

  static const List<String> _instructionOptions = [
    'Take with food',
    'Take with water',
    'Take on empty stomach',
    'Take before bed',
    'Take as needed',
  ];

  String _selectedInstruction = _instructionOptions.first;

  late List<TimeSlotConfig> _slots;
  Set<String> _selectedDays = {
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  };

  @override
  void initState() {
    super.initState();
    _slots = [
      TimeSlotConfig(
        type: TimeOfDayType.morning,
        isEnabled: true,
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
        isEnabled: false,
        time: const TimeOfDay(hour: 22, minute: 0),
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  void _handleToggleSlot(TimeOfDayType type, bool isEnabled) {
    setState(() {
      final index = _slots.indexWhere((s) => s.type == type);
      if (index != -1) {
        _slots[index] = _slots[index].copyWith(isEnabled: isEnabled);
      }
    });
  }

  void _handleTimeChanged(TimeOfDayType type, TimeOfDay newTime) {
    setState(() {
      final index = _slots.indexWhere((s) => s.type == type);
      if (index != -1) {
        _slots[index] = _slots[index].copyWith(time: newTime);
      }
    });
  }

  void _handleDaysChanged(Set<String> newDays) {
    setState(() {
      _selectedDays = newDays;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final hasActiveSlot = _slots.any((s) => s.isEnabled);
    if (!hasActiveSlot) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable at least one time of day slot.'),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day of the week.'),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final medication = Medication(
      id: 'med-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      dosage: _doseController.text.trim(),
      instructions: _selectedInstruction,
      slots: _slots.map((s) => s.copyWith()).toList(),
      days: Set<String>.from(_selectedDays),
    );

    widget.onSave(medication);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Medication',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.of(context).pop(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medication Name
                        const Text(
                          'Medication Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Amoxicillin, Lisinopril',
                            prefixIcon: const Icon(
                              Icons.medication_outlined,
                              color: Color(0xFF0F766E),
                              size: 20,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF0F766E), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a medication name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Recommended Dose
                        const Text(
                          'Recommended Dose',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _doseController,
                          decoration: InputDecoration(
                            hintText: 'e.g. 500 mg, 1 tablet',
                            prefixIcon: const Icon(
                              Icons.straighten_rounded,
                              color: Color(0xFF0F766E),
                              size: 20,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF0F766E), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a dose (e.g. 500 mg)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Instructions Dropdown
                        const Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedInstruction,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFF0F766E),
                              size: 20,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF0F766E), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                          items: _instructionOptions.map((instruction) {
                            return DropdownMenuItem<String>(
                              value: instruction,
                              child: Text(
                                instruction,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedInstruction = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Time of Day Section
                        TimeSlotPicker(
                          slots: _slots,
                          onToggleSlot: _handleToggleSlot,
                          onTimeChanged: _handleTimeChanged,
                        ),
                        const SizedBox(height: 24),

                        // Days of the Week Section
                        DaySelector(
                          selectedDays: _selectedDays,
                          onDaysChanged: _handleDaysChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Save button container
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Save Medication',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
