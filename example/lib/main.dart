import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

void main() {
  runApp(const DiagramApp());
}

class DiagramApp extends StatelessWidget {
  const DiagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dotted Line Patterns'),
        ),
        body: const Center(
          child: SingleDiagramWidget(),
        ),
      ),
    );
  }
}

class SingleDiagramWidget extends StatefulWidget {
  const SingleDiagramWidget({super.key});

  @override
  State<SingleDiagramWidget> createState() => _SingleDiagramWidgetState();
}

class _SingleDiagramWidgetState extends State<SingleDiagramWidget> {
  late IDiagramLayer _layer;
  bool _showAxes = true;

  @override
  void initState() {
    super.initState();
    _initializeDiagram();
  }

  void _initializeDiagram() {
    _layer = BasicDiagramLayer(
      coordinateSystem: CoordinateSystem(
        origin: const Offset(200, 200),
        xRangeMin: -5,
        xRangeMax: 5,
        yRangeMin: -5,
        yRangeMax: 5,
        scale: 40,
      ),
    );

    // Add axes if enabled
    if (_showAxes) {
      _layer = _layer
          .addElement(const XAxisElement(yValue: 0))
          .addElement(const YAxisElement(xValue: 0));
    }

    // Add grid for reference
    _layer = _layer.addElement(
      GridElement(
        x: -5,
        y: -5,
        majorSpacing: 1,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
        majorStrokeWidth: 1,
        minorStrokeWidth: 0.5,
      ),
    );

    // 1. Dotted pattern (default)
    _layer = _layer.addElement(
      DottedLineElement(
        x: -3,
        y: 3,
        endX: 3,
        endY: 3,
        color: Colors.blue,
        strokeWidth: 3,
        pattern: DashPattern.dotted,
        spacing: 0.3,  // Small spacing for dense dots
      ),
    );

    // 2. Dashed pattern
    _layer = _layer.addElement(
      DottedLineElement(
        x: -3,
        y: 1,
        endX: 3,
        endY: 1,
        color: Colors.red,
        strokeWidth: 3,
        pattern: DashPattern.dashed,
        spacing: 0.4,  // Medium spacing for dashes
      ),
    );

    // 3. Dash-dot pattern
    _layer = _layer.addElement(
      DottedLineElement(
        x: -3,
        y: -1,
        endX: 3,
        endY: -1,
        color: Colors.green,
        strokeWidth: 3,
        pattern: DashPattern.dashDot,
        spacing: 0.35,  // Balanced spacing for dash-dot
      ),
    );

    // 4. Custom pattern (alternating long and short dashes)
    _layer = _layer.addElement(
      DottedLineElement(
        x: -3,
        y: -3,
        endX: 3,
        endY: -3,
        color: Colors.purple,
        strokeWidth: 3,
        pattern: DashPattern.custom,
        customPattern: [0.8, 0.3, 0.4, 0.3],  // Long dash, gap, short dash, gap
      ),
    );

    // 5. Diagonal dotted line to show angle handling
    _layer = _layer.addElement(
      DottedLineElement(
        x: 2,
        y: -4,
        endX: 4,
        endY: -2,
        color: Colors.orange,
        strokeWidth: 3,
        pattern: DashPattern.dotted,
        spacing: 0.3,  // Same as horizontal dotted line
      ),
    );

    // Add labels for each pattern
    _layer = _layer
      .addElement(
        TextElement(
          x: 3.2,
          y: 3,
          text: 'Dotted',
          color: Colors.blue,
          style: TextStyle(fontSize: 14, color: Colors.blue),
        ),
      )
      .addElement(
        TextElement(
          x: 3.2,
          y: 1,
          text: 'Dashed',
          color: Colors.red,
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
      )
      .addElement(
        TextElement(
          x: 3.2,
          y: -1,
          text: 'Dash-dot',
          color: Colors.green,
          style: TextStyle(fontSize: 14, color: Colors.green),
        ),
      )
      .addElement(
        TextElement(
          x: 3.2,
          y: -3,
          text: 'Custom',
          color: Colors.purple,
          style: TextStyle(fontSize: 14, color: Colors.purple),
        ),
      )
      .addElement(
        TextElement(
          x: 4.2,
          y: -2,
          text: 'Diagonal',
          color: Colors.orange,
          style: TextStyle(fontSize: 14, color: Colors.orange),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
          ),
          child: CustomPaint(
            painter: CustomPaintRenderer(_layer),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showAxes = !_showAxes;
              _initializeDiagram();
            });
          },
          child: Text(_showAxes ? 'Hide Axes' : 'Show Axes'),
        ),
      ],
    );
  }
}
