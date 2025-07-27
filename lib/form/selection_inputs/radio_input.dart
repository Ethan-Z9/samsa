import 'package:flutter/material.dart';

class RadioInput extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const RadioInput({
    super.key,
    required this.label,
    required this.options,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<RadioInput> createState() => _RadioInputState();
}

class _RadioInputState extends State<RadioInput> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  void _update(String? value) {
    if (value != null) {
      setState(() {
        _selected = value;
      });
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.label),
          for (final option in widget.options)
            RadioListTile(
              title: Text(option),
              value: option,
              groupValue: _selected,
              onChanged: _update,
            ),
        ],
      ),
    );
  }
}
