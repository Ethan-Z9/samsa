import 'package:flutter/material.dart';

class DraggableResizableCard extends StatefulWidget {
  final Widget child;
  final double initialWidth;
  final double initialHeight;

  const DraggableResizableCard({
    super.key,
    required this.child,
    this.initialWidth = 250,
    this.initialHeight = 200,
  });

  @override
  State<DraggableResizableCard> createState() => _DraggableResizableCardState();
}

class _DraggableResizableCardState extends State<DraggableResizableCard> {
  late double width;
  late double height;
  Offset position = const Offset(100, 100);

  @override
  void initState() {
    super.initState();
    width = widget.initialWidth;
    height = widget.initialHeight;
  }

  void _onDrag(DragUpdateDetails details) {
    setState(() => position += details.delta);
  }

  void _onResize(DragUpdateDetails details) {
    setState(() {
      width = (width + details.delta.dx).clamp(150, 600);
      height = (height + details.delta.dy).clamp(100, 600);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: _onDrag,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.child,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: _onResize,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.drag_handle, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
