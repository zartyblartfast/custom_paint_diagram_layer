import 'dart:convert';
import 'package:flutter/material.dart';
import '../custom_paint_diagram_layer.dart';

/// Exports diagram components to IDG (Interactive Diagram Graphics) format
class DiagramExporter {
  /// Export a diagram to IDG format
  static String exportToIDG(
    String name,
    CoordinateSystem coords,
    List<DrawableElement> elements,
    Map<String, dynamic> controls,
  ) {
    final idg = {
      "format": "idg-1.0",
      "metadata": {
        "name": name,
        "created": DateTime.now().toIso8601String(),
      },
      "canvas": {
        "width": 800,
        "height": 600,
        "coordinateSystem": {
          "origin": {
            "x": coords.origin.dx,
            "y": coords.origin.dy,
          },
          "scale": coords.scale,
          "xRange": {
            "min": coords.xRangeMin,
            "max": coords.xRangeMax,
          },
          "yRange": {
            "min": coords.yRangeMin,
            "max": coords.yRangeMax,
          },
        },
      },
      "controls": controls,
      "elements": elements.map((e) => _elementToIDG(e)).toList(),
    };

    return JsonEncoder.withIndent('  ').convert(idg);
  }

  /// Convert a single element to IDG format
  static Map<String, dynamic> _elementToIDG(DrawableElement element) {
    if (element is LineElement) {
      return {
        "type": "line",
        "x1": element.x1,
        "y1": element.y1,
        "x2": element.x2,
        "y2": element.y2,
        "style": {
          "color": element.color.value.toRadixString(16),
          "strokeWidth": element.strokeWidth,
        },
      };
    } else if (element is PolygonElement) {
      return {
        "type": "polygon",
        "points": element.points
            .map((p) => {"x": p.x, "y": p.y})
            .toList(),
        "closed": element.closed,
        "style": {
          "color": element.color.value.toRadixString(16),
          "strokeWidth": element.strokeWidth,
        },
      };
    }
    // Add more element types as needed
    return {};
  }
}
