import 'package:flutter/material.dart';

class GridInput extends StatefulWidget {
  final String label;
  final int rows;
  final int columns;
  final List<String> rowLabels;

  const GridInput({
    super.key,
    required this.label,
    required this.rows,
    required this.columns,
    required this.rowLabels,
  });

  @override
  State<GridInput> createState() => _GridInputState();
}

class _GridInputState extends State<GridInput> {
  late List<List<bool>> gridState;

  @override
  void initState() {
    super.initState();
    gridState = List.generate(
      widget.rows,
      (_) => List.generate(widget.columns, (_) => false),
    );
  }

  void _toggleCell(int row, int col) {
    setState(() {
      gridState[row][col] = !gridState[row][col];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Column(
              children: List.generate(widget.rows, (rowIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(widget.rowLabels[rowIndex]),
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(widget.columns, (colIndex) {
                      final selected = gridState[rowIndex][colIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: GestureDetector(
                          onTap: () => _toggleCell(rowIndex, colIndex),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: selected ? Colors.green : Colors.grey[300],
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
