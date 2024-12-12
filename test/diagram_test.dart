import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:collection/collection.dart';

class MockDrawableElement implements DrawableElement {
  final List<bool> renderCalls;
  @override
  final double x;
  @override
  final double y;
  @override
  final Color color;

  MockDrawableElement({
    required this.x,
    required this.y,
    required this.color,
    required this.renderCalls,
  });

  @override
  void render(Canvas canvas, CoordinateSystem coordinateSystem) {
    renderCalls.add(true);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MockDrawableElement &&
        other.x == x &&
        other.y == y &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(x, y, color);
}

void main() {
  late CoordinateSystem coordinateSystem;

  setUp(() {
    coordinateSystem = CoordinateSystem(
      origin: const Offset(150, 300),  // Bottom-center of a 300x300 canvas
      xRangeMin: -10,
      xRangeMax: 10,
      yRangeMin: 0,    // Y starts at 0
      yRangeMax: 20,   // Y goes up to 20
      scale: 10,
    );
  });

  test('Diagram constructor sets properties correctly', () {
    final diagram = Diagram(coordinateSystem: coordinateSystem);
    expect(diagram.coordinateSystem, equals(coordinateSystem));
    expect(diagram.showAxes, isTrue);
    expect(diagram.elements, isEmpty);
  });

  test('Diagram copyWith creates new instance with updated properties', () {
    final originalDiagram = Diagram(coordinateSystem: coordinateSystem);
    final newCoordinateSystem = CoordinateSystem(
      origin: const Offset(100, 100),
      xRangeMin: -10,
      xRangeMax: 10,
      yRangeMin: -10,
      yRangeMax: 10,
      scale: 10,
    );

    final updatedDiagram = originalDiagram.copyWith(
      coordinateSystem: newCoordinateSystem,
      showAxes: false,
    );

    expect(updatedDiagram.coordinateSystem, equals(newCoordinateSystem));
    expect(updatedDiagram.showAxes, isFalse);
    expect(updatedDiagram.elements, isEmpty);
    expect(updatedDiagram, isNot(equals(originalDiagram)));
  });

  test('Diagram equality works correctly', () {
    final diagram1 = Diagram(coordinateSystem: coordinateSystem);
    final diagram2 = Diagram(coordinateSystem: coordinateSystem);
    final diagram3 = Diagram(
      coordinateSystem: coordinateSystem,
      showAxes: false,
    );

    expect(diagram1, equals(diagram2));
    expect(diagram1.hashCode, equals(diagram2.hashCode));
    expect(diagram1, isNot(equals(diagram3)));
  });

  test('Diagram renders elements', () {
    final renderCalls = <bool>[];
    final elements = [
      MockDrawableElement(x: 0, y: 0, color: Colors.black, renderCalls: renderCalls),
      MockDrawableElement(x: 1, y: 1, color: Colors.red, renderCalls: renderCalls),
    ];

    final diagram = Diagram(
      coordinateSystem: coordinateSystem,
      elements: elements,
    );

    // Create a mock canvas
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    diagram.render(canvas, const Size(300, 300));

    expect(renderCalls.length, equals(2));
    expect(renderCalls.every((call) => call == true), isTrue);
  });

  test('render calls render on all elements', () {
    final renderCalls1 = <bool>[];
    final renderCalls2 = <bool>[];

    final elements = [
      MockDrawableElement(
        x: 0,
        y: 0,
        color: Colors.red,
        renderCalls: renderCalls1,
      ),
      MockDrawableElement(
        x: 1,
        y: 1,
        color: Colors.blue,
        renderCalls: renderCalls2,
      ),
    ];

    final diagram = Diagram(
      coordinateSystem: coordinateSystem,
      elements: elements,
    );

    diagram.render(Canvas(PictureRecorder()), const Size(300, 300));

    expect(renderCalls1, equals([true]));
    expect(renderCalls2, equals([true]));
  });

  test('equality works correctly', () {
    final elements1 = [
      MockDrawableElement(
        x: 0,
        y: 0,
        color: Colors.red,
        renderCalls: [],
      ),
    ];

    final elements2 = [
      MockDrawableElement(
        x: 0,
        y: 0,
        color: Colors.red,
        renderCalls: [],
      ),
    ];

    final diagram1 = Diagram(
      coordinateSystem: coordinateSystem,
      elements: elements1,
    );

    final diagram2 = Diagram(
      coordinateSystem: coordinateSystem,
      elements: elements2,
    );

    expect(diagram1, equals(diagram2));
  });
}
