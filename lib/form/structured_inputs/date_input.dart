import 'package:flutter/material.dart';

class DateInput extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onChanged;

  const DateInput({
    super.key,
    required this.label,
    this.initialDate,
    this.onChanged,
  });

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _selectedDate ?? widget.initialDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = _selectedDate?.toLocal().toString().split(' ')[0] ?? 'Select Date';

    return Card(
      child: ListTile(
        title: Text(widget.label),
        subtitle: Text(display),
        trailing: const Icon(Icons.calendar_today),
        onTap: _pickDate,
      ),
    );
  }
}
