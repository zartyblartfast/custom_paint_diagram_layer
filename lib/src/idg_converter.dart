import 'dart:convert';
import 'package:flutter/material.dart';
import '../custom_paint_diagram_layer.dart';

/// IDG (Interactive Diagram Graphics) format converter
class IDGConverter {
  /// Convert a diagram layer to IDG format
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

    return jsonEncode(idg);
  }

  /// Convert an IDG format string back to diagram components
  static ({
    CoordinateSystem coords,
    List<DrawableElement> elements,
    Map<String, dynamic> controls,
  }) importFromIDG(String idgContent) {
    final idg = jsonDecode(idgContent) as Map<String, dynamic>;
    
    // Parse coordinate system
    final canvas = idg['canvas'] as Map<String, dynamic>;
    final coordsData = canvas['coordinateSystem'] as Map<String, dynamic>;
    final origin = coordsData['origin'] as Map<String, dynamic>;
    final xRange = coordsData['xRange'] as Map<String, dynamic>;
    final yRange = coordsData['yRange'] as Map<String, dynamic>;

    final coords = CoordinateSystem(
      origin: Offset(
        origin['x'] as double,
        origin['y'] as double,
      ),
      scale: coordsData['scale'] as double,
      xRangeMin: xRange['min'] as double,
      xRangeMax: xRange['max'] as double,
      yRangeMin: yRange['min'] as double,
      yRangeMax: yRange['max'] as double,
    );

    // Parse controls
    final controls = idg['controls'] as Map<String, dynamic>;

    // Parse elements
    final elementsList = idg['elements'] as List;
    final elements = elementsList
        .map((e) => _elementFromIDG(e as Map<String, dynamic>))
        .whereType<DrawableElement>()
        .toList();

    return (
      coords: coords,
      elements: elements,
      controls: controls,
    );
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

  /// Convert IDG format back to an element
  static DrawableElement? _elementFromIDG(Map<String, dynamic> data) {
    final type = data['type'] as String;
    final style = data['style'] as Map<String, dynamic>;
    final color = Color(int.parse(style['color'] as String, radix: 16));
    final strokeWidth = style['strokeWidth'] as double;

    switch (type) {
      case 'line':
        return LineElement(
          x1: data['x1'] as double,
          y1: data['y1'] as double,
          x2: data['x2'] as double,
          y2: data['y2'] as double,
          color: color,
          strokeWidth: strokeWidth,
        );
      case 'polygon':
        final pointsList = data['points'] as List;
        final points = pointsList.map((p) {
          final point = p as Map<String, dynamic>;
          return Point2D(point['x'] as double, point['y'] as double);
        }).toList();
        return PolygonElement(
          points: points,
          closed: data['closed'] as bool,
          color: color,
          strokeWidth: strokeWidth,
          x: 0,
          y: 0,
        );
    }
    return null;
  }
}
