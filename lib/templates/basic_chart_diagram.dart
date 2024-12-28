import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

/// A template for creating basic chart diagrams.
/// This template provides a standard implementation that can be customized
/// through configuration rather than inheritance.
class BasicChartDiagram extends StateManagedDiagramBase {
  /// Data points to display in the chart
  final List<Point> dataPoints;
  
  /// Style configuration for the chart
  final ChartStyle style;

  BasicChartDiagram({
    required super.config,
    required this.dataPoints,
    ChartStyle? style,
  }) : style = style ?? const ChartStyle(),
       super() {
    // Register any additional states needed
    state.registerVisibility('dataLabels', style.showDataLabels);
    state.registerVisibility('legend', style.showLegend);
  }

  @override
  List<DrawableElement> createDiagramElements() {
    final elements = <DrawableElement>[];
    
    // Add data points
    for (final point in dataPoints) {
      elements.add(
        CircleElement(
          x: point.x,
          y: point.y,
          radius: style.pointSize,
          color: style.pointColor,
        ),
      );
      
      // Add labels if enabled
      if (state.isVisible('dataLabels')) {
        elements.add(
          TextElement(
            x: point.x,
            y: point.y + style.labelOffset,
            text: point.label ?? '',
            color: style.labelColor,
            style: style.labelTextStyle,
          ),
        );
      }
    }
    
    return elements;
  }
}

/// Configuration for chart appearance
class ChartStyle {
  final double pointSize;
  final Color pointColor;
  final double labelOffset;
  final Color labelColor;
  final TextStyle labelTextStyle;
  final bool showDataLabels;
  final bool showLegend;

  const ChartStyle({
    this.pointSize = 5.0,
    this.pointColor = Colors.blue,
    this.labelOffset = 15.0,
    this.labelColor = Colors.black,
    this.labelTextStyle = const TextStyle(fontSize: 12),
    this.showDataLabels = true,
    this.showLegend = true,
  });
}

/// Represents a data point in the chart
class Point {
  final double x;
  final double y;
  final String? label;

  const Point(this.x, this.y, [this.label]);
}
