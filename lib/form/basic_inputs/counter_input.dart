import 'package:flutter/material.dart';

class CounterInput extends StatefulWidget {
  final String label;
  final int initialValue;
  final ValueChanged<int>? onChanged;

  const CounterInput({
    super.key,
    required this.label,
    this.initialValue = 0,
    this.onChanged,
  });

  @override
  State<CounterInput> createState() => _CounterInputState();
}

class _CounterInputState extends State<CounterInput> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
  }

  void _updateCount(int newCount) {
    setState(() {
      _count = newCount;
    });
    widget.onChanged?.call(_count);
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
              IconButton(
                onPressed: () => _updateCount(_count - 1),
                icon: const Icon(Icons.remove),
              ),
              Text(_count.toString()),
              IconButton(
                onPressed: () => _updateCount(_count + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
