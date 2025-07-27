import 'package:flutter/material.dart';

class NumberInput extends StatefulWidget {
  final String label;
  final int? initialValue;
  final ValueChanged<int?>? onChanged;

  const NumberInput({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toString() ?? '',
    );
  }

  void _onChanged(String value) {
    final parsed = int.tryParse(value);
    widget.onChanged?.call(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.label),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }
}
