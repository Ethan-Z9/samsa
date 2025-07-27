import 'package:flutter/material.dart';

class RadioInput extends StatefulWidget {
  final String label;
  final Map<int, String> options;
  final int? initialValue;
  final ValueChanged<int>? onChanged;
  final Size? size;

  const RadioInput({
    super.key,
    required this.label,
    required this.options,
    this.initialValue,
    this.onChanged,
    this.size,
  });

  @override
  State<RadioInput> createState() => _RadioInputState();
}

class _RadioInputState extends State<RadioInput> {
  int? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue ?? widget.options.keys.first;
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selected = value;
    });
    if (value != null) {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? const Size(150, 100);

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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: widget.options.entries.map((entry) {
                    return RadioListTile<int>(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: _selected,
                      onChanged: _handleRadioValueChange,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
