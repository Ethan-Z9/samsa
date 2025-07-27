import 'package:flutter/material.dart';

class GridInput extends StatefulWidget {
  final String label;
  final List<String> options;
  final int crossAxisCount;
  final ValueChanged<String>? onChanged;

  const GridInput({
    super.key,
    required this.label,
    required this.options,
    this.crossAxisCount = 3,
    this.onChanged,
  });

  @override
  State<GridInput> createState() => _GridInputState();
}

class _GridInputState extends State<GridInput> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(title: Text(widget.label)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: widget.crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.options.map((option) {
                final isSelected = _selected == option;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selected = option);
                    widget.onChanged?.call(option);
                  },
                  child: Card(
                    color: isSelected ? Colors.green[300] : Colors.grey[200],
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
