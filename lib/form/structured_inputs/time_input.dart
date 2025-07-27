import 'package:flutter/material.dart';

class TimeInput extends StatefulWidget {
  final String label;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onChanged;

  const TimeInput({
    super.key,
    required this.label,
    this.initialTime,
    this.onChanged,
  });

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  TimeOfDay? _selectedTime;

  Future<void> _pickTime() async {
    final initial = _selectedTime ?? widget.initialTime ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = _selectedTime?.format(context) ?? 'Select Time';

    return Card(
      child: ListTile(
        title: Text(widget.label),
        subtitle: Text(display),
        trailing: const Icon(Icons.access_time),
        onTap: _pickTime,
      ),
    );
  }
}
