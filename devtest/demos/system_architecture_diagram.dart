import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import '../utils/diagram_test_base.dart';

class SystemArchitectureDiagram extends DiagramTestBase {
  const SystemArchitectureDiagram({super.key}) : super(
    title: 'System Architecture',
    coordRange: 400.0,
  );

  @override
  DiagramTestBaseState<SystemArchitectureDiagram> createState() => _SystemArchitectureDiagramState();
}

class _SystemArchitectureDiagramState extends DiagramTestBaseState<SystemArchitectureDiagram> {
  @override
  List<DrawableElement> createElements(double sliderValue) {
    final elements = <DrawableElement>[];
    
    // Define colors
    const webAppColor = Color(0xFFFFD700);  // Golden yellow
    const cloudColor = Color(0xFF87CEEB);   // Sky blue
    const serviceColor = Color(0xFF90EE90);  // Light green
    const dbColor = Color(0xFFDEB887);      // Burlywood
    const textColor = Colors.black;

    // Web Apps (Left side)
    _addRectWithText(elements, -300, 150, 'Web App', webAppColor);
    _addRectWithText(elements, -300, 50, 'Public Profile\nWeb App', webAppColor);
    _addRectWithText(elements, -300, -50, 'Recruiter\nWeb App', webAppColor);
    _addRectWithText(elements, -300, -150, 'Ads Server', webAppColor);

    // The Cloud (Center)
    _addCloudShape(elements, 0, 100, 'The Cloud', cloudColor);

    // Services (Center-right)
    _addRectWithText(elements, 100, 200, 'Search', serviceColor);
    _addRectWithText(elements, 100, 100, 'Profile\nService', serviceColor);
    _addRectWithText(elements, 100, 0, 'Comm\nService', serviceColor);
    _addRectWithText(elements, 100, -100, 'Groups\nService', serviceColor);
    _addRectWithText(elements, 100, -200, 'News\nService', serviceColor);

    // Databases (Right side)
    _addRectWithText(elements, 300, 200, 'DB', dbColor);
    _addRectWithText(elements, 300, 100, 'DB', dbColor);
    _addRectWithText(elements, 300, 0, 'DB', dbColor);
    _addRectWithText(elements, 300, -100, 'DB', dbColor);

    // Right-most components
    _addRectWithText(elements, 400, 200, 'Replica\nDB', dbColor);
    _addRectWithText(elements, 400, 100, 'RepDB Server', serviceColor);
    _addRectWithText(elements, 400, 0, 'Databus', Color(0xFFB8B8B8));
    _addRectWithText(elements, 400, -100, 'Core\nDatabase', Color(0xFFFFA500));

    // Add connection lines
    _addConnections(elements);

    // Add labels for connections
    _addLabel(elements, -150, 150, 'http-rpc or\njms calls', textColor);
    _addLabel(elements, 50, 200, 'graph', textColor);
    _addLabel(elements, 200, 250, 'read only', textColor);
    _addLabel(elements, 200, 150, 'connection\nupdates', textColor);
    _addLabel(elements, 200, 50, 'profile\nupdates', textColor);
    _addLabel(elements, 200, -50, 'r/w', textColor);
    _addLabel(elements, 350, 50, 'jdbc', textColor);
    _addLabel(elements, 350, -150, 'read/write', textColor);
    _addLabel(elements, 450, 50, 'relay', textColor);

    return elements;
  }

  void _addRectWithText(List<DrawableElement> elements, double x, double y, String text, Color color) {
    elements.add(RectangleElement(
      x: x,
      y: y,
      width: 80,
      height: 40,
      color: Colors.black,
      fillColor: color,
      strokeWidth: 1,
    ));

    elements.add(TextElement(
      x: x,
      y: y,
      text: text,
      color: Colors.black,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ));
  }

  void _addCloudShape(List<DrawableElement> elements, double x, double y, String text, Color color) {
    // Create cloud shape using multiple overlapping circles
    final cloudRadius = 40.0;
    final positions = [
      Point2D(x, y),
      Point2D(x - cloudRadius * 0.7, y - cloudRadius * 0.3),
      Point2D(x + cloudRadius * 0.7, y - cloudRadius * 0.3),
      Point2D(x, y + cloudRadius * 0.3),
    ];

    for (final pos in positions) {
      elements.add(CircleElement(
        x: pos.x,
        y: pos.y,
        radius: cloudRadius,
        color: Colors.black,
        fillColor: color,
        strokeWidth: 1,
      ));
    }

    elements.add(TextElement(
      x: x,
      y: y,
      text: text,
      color: Colors.black,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ));
  }

  void _addLabel(List<DrawableElement> elements, double x, double y, String text, Color color) {
    elements.add(TextElement(
      x: x,
      y: y,
      text: text,
      color: color,
      style: const TextStyle(
        fontSize: 10,
      ),
    ));
  }

  void _addConnections(List<DrawableElement> elements) {
    // Add connection lines between components
    // Web Apps to Cloud
    for (var y in [150.0, 50.0, -50.0, -150.0]) {
      elements.add(LineElement(
        x1: -260,
        y1: y,
        x2: -100,
        y2: 100,
        color: Colors.black,
        strokeWidth: 1,
      ));
    }

    // Cloud to Services
    for (var y in [200.0, 100.0, 0.0, -100.0, -200.0]) {
      elements.add(LineElement(
        x1: 40,
        y1: 100,
        x2: 60,
        y2: y,
        color: Colors.black,
        strokeWidth: 1,
      ));
    }

    // Services to DBs
    for (var y in [200.0, 100.0, 0.0, -100.0]) {
      elements.add(LineElement(
        x1: 140,
        y1: y,
        x2: 260,
        y2: y,
        color: Colors.black,
        strokeWidth: 1,
      ));
    }

    // Right-side connections
    elements.add(LineElement(
      x1: 340,
      y1: 200,
      x2: 360,
      y2: 200,
      color: Colors.black,
      strokeWidth: 1,
    ));

    elements.add(LineElement(
      x1: 340,
      y1: -100,
      x2: 360,
      y2: -100,
      color: Colors.black,
      strokeWidth: 1,
    ));

    // Databus connections
    elements.add(LineElement(
      x1: 400,
      y1: 100,
      x2: 400,
      y2: 20,
      color: Colors.black,
      strokeWidth: 1,
    ));

    elements.add(LineElement(
      x1: 400,
      y1: -20,
      x2: 400,
      y2: -80,
      color: Colors.black,
      strokeWidth: 1,
    ));
  }

  @override
  double get elementHeight => 400.0;
}
