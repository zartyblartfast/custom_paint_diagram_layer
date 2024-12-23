import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/layers/basic_diagram_layer.dart';

class WebEngineeringCoords extends StatefulWidget {
  const WebEngineeringCoords({super.key});

  @override
  WebEngineeringCoordsState createState() => WebEngineeringCoordsState();
}

class TestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    // Draw diagonal line
    canvas.drawLine(
      Offset.zero,
      Offset(size.width, size.height),
      paint,
    );

    // Draw rectangle
    canvas.drawRect(
      Rect.fromLTWH(50, 50, 100, 100),
      paint,
    );

    // Draw circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      50,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WebEngineeringCoordsState extends State<WebEngineeringCoords> {
  bool showCustomPaint = false;
  late IDiagramLayer diagramLayer;

  @override
  void initState() {
    super.initState();
    diagramLayer = BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(300, 300),
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        scale: 20,
      ),
      elements: [
        // Add a red circle at (2, 3)
        CircleElement(
          x: 2,
          y: 3,
          radius: 1,
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.3),
        ),
        // Add a blue rectangle from (-5, -5) to (-2, -2)
        RectangleElement(
          startX: -5,
          startY: -5,
          endX: -2,
          endY: -2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.3),
        ),
        // Add a green line from (-1, -1) to (4, 4)
        LineElement(
          startX: -1,
          startY: -1,
          endX: 4,
          endY: 4,
          strokeColor: Colors.green,
          strokeWidth: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 600,
          height: 600,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 5),
            color: Colors.white,
          ),
          child: showCustomPaint 
            ? CustomPaint(
                painter: CustomPaintRenderer(diagramLayer),
                size: const Size(600, 600),
              )
            : CustomPaint(
                painter: TestPainter(),
                size: const Size(600, 600),
              ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                showCustomPaint = !showCustomPaint;
                print('Toggle CustomPaint: $showCustomPaint');
              });
            },
            child: const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}