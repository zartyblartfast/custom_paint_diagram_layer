import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

void main() {
  group('GroupElement', () {
    late CoordinateSystem coordinateSystem;

    setUp(() {
      coordinateSystem = const CoordinateSystem(
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        scale: 1.0,
        origin: Offset(100, 100),
      );
    });

    test('constructor sets properties correctly', () {
      final children = [
        CircleElement(x: 0, y: 0, radius: 1, color: Colors.blue),
        RectangleElement(x: 2, y: 2, width: 1, height: 1, color: Colors.red),
      ];

      final group = GroupElement(
        x: 1,
        y: 1,
        children: children,
        color: Colors.black,
      );

      expect(group.x, equals(1));
      expect(group.y, equals(1));
      expect(group.children, equals(children));
      expect(group.color, equals(Colors.black));
    });

    test('copyWith creates new instance with updated properties', () {
      final children = [
        CircleElement(x: 0, y: 0, radius: 1, color: Colors.blue),
      ];

      final group = GroupElement(
        x: 1,
        y: 1,
        children: children,
        color: Colors.black,
      );

      final newGroup = group.copyWith(
        x: 2,
        y: 3,
      );

      expect(newGroup.x, equals(2));
      expect(newGroup.y, equals(3));
      expect(newGroup.children, equals(children));
      expect(newGroup.color, equals(Colors.black));
    });

    test('equals compares properties correctly', () {
      final children1 = [
        CircleElement(x: 0, y: 0, radius: 1, color: Colors.blue),
      ];

      final children2 = [
        CircleElement(x: 0, y: 0, radius: 1, color: Colors.blue),
      ];

      final group1 = GroupElement(
        x: 1,
        y: 1,
        children: children1,
        color: Colors.black,
      );

      final group2 = GroupElement(
        x: 1,
        y: 1,
        children: children2,
        color: Colors.black,
      );

      expect(group1, equals(group2));
    });
  });
} 