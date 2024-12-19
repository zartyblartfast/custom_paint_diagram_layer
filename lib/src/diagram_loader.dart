import 'dart:convert';
import 'package:flutter/material.dart';
import '../custom_paint_diagram_layer.dart';

/// Loads diagrams from IDG (Interactive Diagram Graphics) format
class DiagramLoader {
  /// Load a diagram from IDG format string
  static ({
    String name,
    CoordinateSystem coords,
    List<DrawableElement> elements,
    Map<String, dynamic> controls,
  }) loadFromIDG(String idgContent) {
    try {
      print('Parsing IDG content: $idgContent');
      final idg = jsonDecode(idgContent) as Map<String, dynamic>;
      print('Parsed IDG: $idg');
      
      final name = idg['metadata']['name'] as String;
      print('Name: $name');

      // Parse coordinate system
      final canvas = idg['canvas'] as Map<String, dynamic>;
      final coordsData = canvas['coordinateSystem'] as Map<String, dynamic>;
      final origin = coordsData['origin'] as Map<String, dynamic>;
      final xRange = coordsData['xRange'] as Map<String, dynamic>;
      final yRange = coordsData['yRange'] as Map<String, dynamic>;
      print('Coordinate system data: $coordsData');

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
      print('Created coordinate system: $coords');

      // Parse controls
      final controls = idg['controls'] as Map<String, dynamic>;
      print('Controls: $controls');

      // Parse elements
      final elementsList = idg['elements'] as List;
      print('Elements list: $elementsList');
      final elements = elementsList
          .map((e) => _elementFromIDG(e as Map<String, dynamic>))
          .whereType<DrawableElement>()
          .toList();
      print('Parsed elements: $elements');

      return (
        name: name,
        coords: coords,
        elements: elements,
        controls: controls,
      );
    } catch (e, stack) {
      print('Error in loadFromIDG: $e');
      print('Stack trace: $stack');
      rethrow;
    }
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
