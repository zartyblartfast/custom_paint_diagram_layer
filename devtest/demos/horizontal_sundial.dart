import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import '../utils/static_diagram_base.dart';

/// A demonstration of a horizontal sundial with polar coordinates
class HorizontalSundialDemo extends StaticDiagramBase {
  const HorizontalSundialDemo({super.key})
      : super(
          title: 'Horizontal Sundial',
          coordRange: 10.0,
          margin: 1.0,
        );

  @override
  StaticDiagramBaseState<StaticDiagramBase> createState() => _HorizontalSundialDemoState();
}

class _HorizontalSundialDemoState extends StaticDiagramBaseState<HorizontalSundialDemo> {
  final TextEditingController _latitudeController = TextEditingController();
  double? _latitude;
  String? _latitudeError;

  @override
  void initState() {
    showAxes = false; // Set before super.initState() which will create the diagram
    super.initState();
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    super.dispose();
  }

  // Calculate hour line angle based on latitude and hour from noon
  double _calculateHourAngle(double latitude, int hour) {
    final latRad = latitude * math.pi / 180;
    final hourAngleRad = 15 * hour * math.pi / 180;
    return math.atan(math.sin(latRad) * math.tan(hourAngleRad));
  }

  void _handleLatitudeChange(String value) {
    try {
      final lat = double.parse(value);
      if ((lat >= 10 && lat <= 70) || (lat <= -10 && lat >= -70)) {
        setState(() {
          _latitudeError = null;
          _latitude = lat;
        });
      } else {
        setState(() {
          _latitudeError = 'Must be between +10 to +70 or -10 to -70';
          _latitude = null;
        });
      }
    } catch (e) {
      setState(() {
        _latitudeError = 'Please enter a valid number';
        _latitude = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(showAxes ? Icons.grid_off : Icons.grid_on),
            onPressed: () => setState(() => showAxes = !showAxes),
            tooltip: 'Toggle Axes',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Latitude: '),
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _latitudeController,
                    decoration: InputDecoration(
                      hintText: '+/-nn.nnn',
                      errorText: _latitudeError,
                      isDense: true,
                    ),
                    onChanged: _handleLatitudeChange,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: CustomPaintRenderer(diagramLayer),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }

  @override
  List<DrawableElement> createElements() {
    final elements = <DrawableElement>[];
    final strokeColor = Colors.black87;

    // Add polar coordinate system circle
    elements.add(CircleElement(
      x: 0,
      y: 0,
      radius: 8,
      color: strokeColor,
      strokeWidth: 1,
      fillColor: Colors.grey.shade200.withOpacity(0.3),
    ));

    // Only draw hour lines if we have a valid latitude
    if (_latitude != null) {
      for (int hour = -6; hour <= 6; hour++) {
        // Skip noon (0 hour) as it's always vertical
        if (hour == 0) continue;
        
        // Calculate the hour line angle
        final angle = _calculateHourAngle(_latitude!, hour);
        
        // Convert to our coordinate system (0° at top, clockwise)
        final radians = math.pi/2 - angle;
        final radius = 8.0;
        final x = radius * math.cos(radians);
        final y = radius * math.sin(radians);
        
        // Add hour line
        elements.add(LineElement(
          x1: 0,
          y1: 0,
          x2: x,
          y2: y,
          color: strokeColor,
          strokeWidth: 2,
        ));

        // Add hour label
        elements.add(TextElement(
          x: 1.2 * x,
          y: 1.2 * y,
          text: '${hour}h',
          color: strokeColor,
        ));
      }

      // Add noon line (always vertical)
      elements.add(LineElement(
        x1: 0,
        y1: 0,
        x2: 0,
        y2: 8,
        color: strokeColor,
        strokeWidth: 2,
      ));
      elements.add(TextElement(
        x: 0,
        y: 9,
        text: '12h',
        color: strokeColor,
      ));
    }

    // Add center point
    elements.add(CircleElement(
      x: 0,
      y: 0,
      radius: 0.2,
      color: strokeColor,
      fillColor: Colors.grey.shade200.withOpacity(0.3),
    ));

    return elements;
  }

  @override
  double get elementHeight => 1.0;

  @override
  CoordinateSystem createCoordinateSystem() {
    return CoordinateSystem(
      origin: Offset.zero,
      xRangeMin: -widget.coordRange,
      xRangeMax: widget.coordRange,
      yRangeMin: -widget.coordRange,
      yRangeMax: widget.coordRange,
      scale: 1.0,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: HorizontalSundialDemo(),
        ),
      ),
    ),
  ));
}
