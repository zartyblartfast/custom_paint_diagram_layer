import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

class SpringBalanceDiagram extends StatefulWidget {
  const SpringBalanceDiagram({super.key});

  @override
  State<SpringBalanceDiagram> createState() => _SpringBalanceDiagramState();
}

class _SpringBalanceDiagramState extends State<SpringBalanceDiagram> {
  late IDiagramLayer _layer;
  double _springLength = 5.0; // Initial spring length
  bool _showAxes = true;

  @override
  void initState() {
    super.initState();
    _createDiagramLayer();
  }

  void _createDiagramLayer() {
    // Create coordinate system
    final coords = CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -10,
      xRangeMax: 10,
      yRangeMin: -10,
      yRangeMax: 10,
      scale: 1.0,
    );

    // Create initial layer with grid
    _layer = BasicDiagramLayer(
      coordinateSystem: coords,
      showAxes: _showAxes,
    ).addElement(
      GridElement(
        x: 0,
        y: 0,
        majorSpacing: 1.0,
        minorSpacing: 0.2,
        majorColor: Colors.grey.withOpacity(0.5),
        minorColor: Colors.grey.withOpacity(0.2),
      ),
    );

    // Add spring balance elements
    _updateSpringBalance();
  }

  void _updateSpringBalance() {
    // Remove old elements (except grid)
    final oldElements = _layer.elements
        .where((e) => e is! GridElement)
        .toList();
    
    // Create spring balance elements
    final newElements = [
      // Support bar at top
      LineElement(
        x1: -2,
        y1: 8,
        x2: 2,
        y2: 8,
        color: Colors.black,
        strokeWidth: 3,
      ),
      // Vertical support
      LineElement(
        x1: 0,
        y1: 8,
        x2: 0,
        y2: 6,
        color: Colors.black,
        strokeWidth: 2,
      ),
      // Spring (represented as zigzag)
      for (var i = 0; i < 5; i++) ...[
        LineElement(
          x1: 0,
          y1: 6 - i * _springLength/5,
          x2: 1,
          y2: 5.5 - i * _springLength/5,
          color: Colors.blue,
          strokeWidth: 2,
        ),
        LineElement(
          x1: 1,
          y1: 5.5 - i * _springLength/5,
          x2: -1,
          y2: 5 - i * _springLength/5,
          color: Colors.blue,
          strokeWidth: 2,
        ),
        LineElement(
          x1: -1,
          y1: 5 - i * _springLength/5,
          x2: 0,
          y2: 4.5 - i * _springLength/5,
          color: Colors.blue,
          strokeWidth: 2,
        ),
      ],
      // Weight at bottom
      RectangleElement(
        x: -1,
        y: 6 - _springLength - 2,
        width: 2,
        height: 2,
        color: Colors.red,
        fillColor: Colors.red.withOpacity(0.3),
      ),
    ];

    // Update layer
    setState(() {
      _layer = _layer.updateDiagram(
        elementUpdates: newElements,
        removeElements: oldElements,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spring Balance Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showAxes ? Icons.grid_off : Icons.grid_on),
            onPressed: () {
              setState(() {
                _showAxes = !_showAxes;
                _layer = _layer.toggleAxes();
              });
            },
            tooltip: 'Toggle Axes',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: CustomPaint(
                  painter: CustomPaintRenderer(_layer),
                  size: const Size(600, 600),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Spring Length:'),
                Expanded(
                  child: Slider(
                    min: 2.0,
                    max: 8.0,
                    value: _springLength,
                    onChanged: (value) {
                      setState(() {
                        _springLength = value;
                        _updateSpringBalance();
                      });
                    },
                  ),
                ),
                Text(_springLength.toStringAsFixed(1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
