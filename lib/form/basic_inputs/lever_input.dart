import 'package:flutter/material.dart';

class LeverInput extends StatefulWidget {
  final String label;
  final String leftLabel;
  final String rightLabel;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const LeverInput({
    super.key,
    required this.label,
    this.leftLabel = 'Off',
    this.rightLabel = 'On',
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<LeverInput> createState() => _LeverInputState();
}

class _LeverInputState extends State<LeverInput> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _toggle(bool newValue) {
    setState(() {
      _value = newValue;
    });
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.label),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.leftLabel),
              Switch(value: _value, onChanged: _toggle),
              Text(widget.rightLabel),
            ],
          ),
        ],
      ),
    );
  }
}
