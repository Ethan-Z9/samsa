import 'package:flutter/material.dart';

class SliderInput extends StatefulWidget {
  final String label;
  final double min;
  final double max;
  final int? divisions; // <-- int now, optional
  final double? initialValue;
  final ValueChanged<double>? onChanged;

  const SliderInput({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    this.divisions, // optional — pass null for smooth slider
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
    double val = widget.initialValue ?? widget.min;
    _value = val.clamp(widget.min, widget.max);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              '${widget.label}: ${_value.toStringAsFixed(widget.divisions != null ? 0 : 1)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _value,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              label: _value.toStringAsFixed(widget.divisions != null ? 0 : 1),
              onChanged: (val) {
                setState(() {
                  _value = val;
                });
                widget.onChanged?.call(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
