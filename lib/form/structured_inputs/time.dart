import 'package:flutter/material.dart';

class TimeInput extends StatefulWidget {
  final String label;
  final Duration? initialTime;
  final ValueChanged<Duration>? onChanged;
  final Size? size;

  const TimeInput({
    super.key,
    required this.label,
    this.initialTime,
    this.onChanged,
    this.size,
  });

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  late int _hours;
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialTime ?? Duration.zero;
    _hours = initial.inHours;
    _minutes = initial.inMinutes.remainder(60);
    _seconds = initial.inSeconds.remainder(60);
  }

  void _updateTime() {
    final duration = Duration(hours: _hours, minutes: _minutes, seconds: _seconds);
    widget.onChanged?.call(duration);
  }

  void _setTimeValue(String value, void Function(int) setter) {
    final parsed = int.tryParse(value) ?? 0;
    setter(parsed.clamp(0, 59)); // clamp minutes/seconds
    _updateTime();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  _timeField('h', _hours, (v) => setState(() => _hours = v)),
                  const SizedBox(width: 8),
                  _timeField('m', _minutes, (v) => setState(() => _minutes = v)),
                  const SizedBox(width: 8),
                  _timeField('s', _seconds, (v) => setState(() => _seconds = v)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeField(String label, int value, void Function(int) setter) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        ),
        keyboardType: TextInputType.number,
        controller: TextEditingController(text: value.toString())
          ..selection = TextSelection.fromPosition(TextPosition(offset: value.toString().length)),
        onChanged: (val) => _setTimeValue(val, setter),
      ),
    );
  }
}
