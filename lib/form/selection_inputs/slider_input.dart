import 'package:flutter/material.dart';

class SliderInput extends StatefulWidget {
  final String label;
  final double min;
  final double max;
  final double divisions;
  final double? initialValue;
  final ValueChanged<double>? onChanged;

  const SliderInput({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    required this.divisions,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<SliderInput> createState() => _SliderInputState();
}

class _SliderInputState extends State<SliderInput> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? widget.min;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text('${widget.label}: ${_value.toStringAsFixed(1)}'),
          Slider(
            value: _value,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions.toInt(),
            label: _value.toStringAsFixed(1),
            onChanged: (val) {
              setState(() {
                _value = val;
              });
              widget.onChanged?.call(val);
            },
          ),
        ],
      ),
    );
  }
}
