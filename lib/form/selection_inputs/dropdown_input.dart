import 'package:flutter/material.dart';

class DropdownInput extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const DropdownInput({
    super.key,
    required this.label,
    required this.options,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue ?? widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.label),
          DropdownButton<String>(
            value: _selected,
            items: widget.options
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selected = value;
                });
                widget.onChanged?.call(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
