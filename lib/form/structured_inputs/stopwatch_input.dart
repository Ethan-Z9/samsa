import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchInput extends StatefulWidget {
  final String label;
  final ValueChanged<Duration>? onChanged;

  const StopwatchInput({
    super.key,
    required this.label,
    this.onChanged,
  });

  @override
  State<StopwatchInput> createState() => _StopwatchInputState();
}

class _StopwatchInputState extends State<StopwatchInput> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  void _stop() {
    _stopwatch.stop();
    _timer?.cancel();
    widget.onChanged?.call(_stopwatch.elapsed);
  }

  void _reset() {
    _stopwatch.reset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final time = _stopwatch.elapsed;
    final display = time.toString().split('.').first;

    return Card(
      child: Column(
        children: [
          Text(widget.label),
          Text(display, style: const TextStyle(fontSize: 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: _start, icon: const Icon(Icons.play_arrow)),
              IconButton(onPressed: _stop, icon: const Icon(Icons.pause)),
              IconButton(onPressed: _reset, icon: const Icon(Icons.stop)),
            ],
          ),
        ],
      ),
    );
  }
}
