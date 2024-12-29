import 'package:flutter/material.dart';
import '../elements/elements.dart';
import '../utils/diagnostic_helper.dart';
import '../config/diagram_config.dart';
import '../coordinate_system.dart';

/// A builder class specialized in creating group-based diagram elements
/// such as labeled rectangles and connectors between groups.
class GroupDiagramElementBuilder with DiagnosticHelper {
  @override
  String get diagnosticSource => 'GroupDiagramElementBuilder';

  @override
  DiagnosticCallback? get onDiagnostic => null;

  final Map<String, Color> colors;
  final DiagramConfig config;
  final CoordinateSystem coordinates;

  /// Creates a new builder with the given theme colors and config
  GroupDiagramElementBuilder({
    required this.colors,
    required this.config,
  }) : coordinates = CoordinateSystem(
         origin: Offset(config.width / 2, config.height / 2),
         xRangeMin: config.xRangeMin,
         xRangeMax: config.xRangeMax,
         yRangeMin: config.yRangeMin,
         yRangeMax: config.yRangeMax,
         scale: 1.0,
       );

  /// Creates a group containing a centered rectangle with a label
  GroupElement createLabeledGroup({
    required double x,
    required double y,
    required String text,
    double? width,
    double? height,
    double? borderRadius,
    double fillOpacity = 0.2,
    Color? elementColor,
    Color? fillColor,
    Color? textColor,
  }) {
    // Use coordinate system to determine default dimensions if not provided
    final defaultWidth = (config.xRangeMax - config.xRangeMin) * 0.2; // 20% of x range
    final defaultHeight = (config.yRangeMax - config.yRangeMin) * 0.15; // 15% of y range
    final defaultRadius = defaultWidth * 0.1; // 10% of width
    
    return GroupElement(
      x: x,
      y: y,
      children: [
        RectangleElement.centered(
          centerX: 0,
          centerY: 0,
          width: width ?? defaultWidth,
          height: height ?? defaultHeight,
          color: elementColor ?? colors['element'] ?? Colors.blue,
          fillColor: fillColor ?? colors['elementFill'] ?? Colors.blue.shade100,
          fillOpacity: fillOpacity,
          borderRadius: borderRadius ?? defaultRadius,
        ),
        TextElement(
          x: 0,
          y: 0,
          text: text,
          color: textColor ?? colors['text'] ?? Colors.black87,
        ),
      ],
    );
  }

  /// Creates a connector between two groups using socket positions
  ConnectorElement createConnectorWithSockets({
    required GroupElement startGroup,
    required Socket startSocket,
    required GroupElement endGroup,
    required Socket endSocket,
    ConnectorEndpoint startEndpoint = ConnectorEndpoint.none,
    ConnectorEndpoint endEndpoint = ConnectorEndpoint.arrow,
    double strokeWidth = 2,
    Color? color,
  }) {
    final (start, end) = ConnectorElement.calculateConnectionPoints(
      startGroup: startGroup,
      startSocket: startSocket,
      endGroup: endGroup,
      endSocket: endSocket,
      coordSystem: coordinates,
    );
    
    return ConnectorElement(
      start: start,
      end: end,
      color: color ?? colors['element'] ?? Colors.blue,
      routing: ConnectorRouting.direct,  // Let's keep it simple for now
      startEndpoint: startEndpoint,
      endEndpoint: endEndpoint,
      strokeWidth: strokeWidth,
    );
  }
}
