import 'package:flutter/material.dart';

class CheckboxInput extends StatefulWidget {
  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CheckboxInput({
    super.key,
    required this.label,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<CheckboxInput> createState() => _CheckboxInputState();
}

class _CheckboxInputState extends State<CheckboxInput> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.initialValue;
  }

  void _toggle(bool? value) {
    final newVal = value ?? false;
    setState(() {
      _checked = newVal;
    });
    widget.onChanged?.call(newVal);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        title: Text(widget.label),
        value: _checked,
        onChanged: _toggle,
      ),
    );
  }
}
