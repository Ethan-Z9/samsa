import 'package:flutter/material.dart';

class SliderInput extends StatefulWidget {
  final String label;
  final double min;
  final double max;
  final double? initialValue;
  final ValueChanged<double>? onChanged;
  final Size? size;

  const SliderInput({
    super.key,
    required this.label,
    this.min = 0,
    this.max = 100,
    this.initialValue,
    this.onChanged,
    this.size,
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
    final size = widget.size ?? const Size(200, 120);

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
              Slider(
                value: _value,
                min: widget.min,
                max: widget.max,
                onChanged: (val) {
                  setState(() => _value = val);
                  widget.onChanged?.call(val);
                },
              ),
              Text(_value.toStringAsFixed(1)),
            ],
          ),
        ),
      ),
    );
  }
}
