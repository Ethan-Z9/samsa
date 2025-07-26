import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final int maxLength;
  final Size? size;

  const TextInput({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.maxLength = 100,
    this.size,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLength: widget.maxLength,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  counterText: '', // hides default counter text
                ),
                onChanged: _onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
