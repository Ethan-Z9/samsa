// lib/form/basic_inputs/toggle_switch.dart

import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final String label;
  final String leftLabel;
  final String rightLabel;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final Size? size;

  const ToggleSwitch({
    super.key,
    required this.label,
    required this.leftLabel,
    required this.rightLabel,
    this.initialValue = false,
    this.onChanged,
    this.size,
  });

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _onChanged(bool newValue) {
    setState(() => _value = newValue);
    widget.onChanged?.call(newValue);
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.leftLabel),
                  const SizedBox(width: 8),
                  Switch(
                    value: _value,
                    onChanged: _onChanged,
                  ),
                  const SizedBox(width: 8),
                  Text(widget.rightLabel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
