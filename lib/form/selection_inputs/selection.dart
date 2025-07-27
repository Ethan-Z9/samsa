import 'package:flutter/material.dart';

class Selection extends StatefulWidget {
  final String label;
  final Map<int, String> options;
  final int? initialValue;
  final ValueChanged<int>? onChanged;
  final Size? size;

  const Selection({
    super.key,
    required this.label,
    required this.options,
    this.initialValue,
    this.onChanged,
    this.size,
  });

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  int? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? widget.options.keys.first;
  }

  void _onChanged(int? newValue) {
    setState(() => _selectedValue = newValue);
    if (newValue != null) widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? const Size(200, 100);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedValue,
                items: widget.options.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
