import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const TextInput({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.label),
          TextField(
            controller: _controller,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
