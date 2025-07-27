import 'package:flutter/material.dart';

class CheckboxInput extends StatefulWidget {
  final String label;
  final ValueChanged<bool>? onChanged;
  final Size? size;

  const CheckboxInput({
    super.key,
    required this.label,
    this.onChanged,
    this.size,
  });

  @override
  State<CheckboxInput> createState() => _CheckboxInputState();
}

class _CheckboxInputState extends State<CheckboxInput> {
  bool _value = false;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _value,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _value = val);
                    widget.onChanged?.call(_value);
                  }
                },
              ),
              Text(widget.label),
            ],
          ),
        ),
      ),
    );
  }
}
