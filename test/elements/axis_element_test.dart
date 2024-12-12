import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';

void main() {
  group('AxisElement', () {
    late CoordinateSystem coordinateSystem;

    setUp(() {
      coordinateSystem = CoordinateSystem(
        xRangeMin: -10,
        xRangeMax: 10,
        yRangeMin: -10,
        yRangeMax: 10,
        scale: 1.0,
        origin: const Offset(100, 100),
      );
    });

    group('XAxisElement', () {
      test('constructor sets properties correctly', () {
        const axis = XAxisElement(yValue: 0);
        expect(axis.x, equals(0));
        expect(axis.y, equals(0));
        expect(axis.type, equals(AxisType.x));
        expect(axis.tickInterval, equals(1.0));
        expect(axis.color, equals(Colors.black));
      });

      test('equals compares properties correctly', () {
        const axis1 = XAxisElement(yValue: 0);
        const axis2 = XAxisElement(yValue: 0);
        const axis3 = XAxisElement(yValue: 1);

        expect(axis1, equals(axis2));
        expect(axis1, isNot(equals(axis3)));
      });
    });

    group('YAxisElement', () {
      test('constructor sets properties correctly', () {
        const axis = YAxisElement(xValue: 0);
        expect(axis.x, equals(0));
        expect(axis.y, equals(0));
        expect(axis.type, equals(AxisType.y));
        expect(axis.tickInterval, equals(1.0));
        expect(axis.color, equals(Colors.black));
      });

      test('equals compares properties correctly', () {
        const axis1 = YAxisElement(xValue: 0);
        const axis2 = YAxisElement(xValue: 0);
        const axis3 = YAxisElement(xValue: 1);

        expect(axis1, equals(axis2));
        expect(axis1, isNot(equals(axis3)));
      });
    });
  });
}
