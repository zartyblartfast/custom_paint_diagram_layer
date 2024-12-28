import 'package:flutter/material.dart';
import '../drawable_element.dart';
import '../elements/circle_element.dart';
import '../elements/text_element.dart';
import 'diagnostic_helper.dart';

/// A utility class to build diagram elements in a structured way.
/// 
/// This builder provides a type-safe and maintainable way to create
/// common diagram elements with customizable styling.
class DiagramElementBuilder with DiagnosticHelper {
  @override
  String get diagnosticSource => 'DiagramElementBuilder';

  @override
  final DiagnosticCallback? onDiagnostic;

  /// The current value to display (usually from a slider)
  final double value;

  /// Style configuration for elements
  final Color borderColor;
  final Color fillColor;
  final Color textColor;
  final TextStyle labelStyle;
  
  /// Position configuration
  final double circleX;
  final double circleY;
  final double labelX;
  final double labelY;
  
  /// Scaling factors
  final double radiusScale;
  final int decimalPlaces;

  /// Creates a diagram element builder with customizable styling
  const DiagramElementBuilder({
    required this.value,
    this.borderColor = const Color.fromRGBO(238, 238, 238, 1),
    this.fillColor = const Color.fromRGBO(0, 0, 255, 0.2),
    this.textColor = Colors.black,
    this.labelStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.circleX = 5,
    this.circleY = 5,
    this.labelX = 0,
    this.labelY = -6,
    this.radiusScale = 5.0,
    this.decimalPlaces = 1,
    this.onDiagnostic,
  });

  /// Creates a copy of this builder with some properties updated
  DiagramElementBuilder copyWith({
    double? value,
    Color? borderColor,
    Color? fillColor,
    Color? textColor,
    TextStyle? labelStyle,
    double? circleX,
    double? circleY,
    double? labelX,
    double? labelY,
    double? radiusScale,
    int? decimalPlaces,
    DiagnosticCallback? onDiagnostic,
  }) {
    return DiagramElementBuilder(
      value: value ?? this.value,
      borderColor: borderColor ?? this.borderColor,
      fillColor: fillColor ?? this.fillColor,
      textColor: textColor ?? this.textColor,
      labelStyle: labelStyle ?? this.labelStyle,
      circleX: circleX ?? this.circleX,
      circleY: circleY ?? this.circleY,
      labelX: labelX ?? this.labelX,
      labelY: labelY ?? this.labelY,
      radiusScale: radiusScale ?? this.radiusScale,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      onDiagnostic: onDiagnostic ?? this.onDiagnostic,
    );
  }

  /// Builds all diagram elements
  List<DrawableElement> buildElements() {
    reportInfo('buildElements', 'Building diagram elements', {
      'value': value,
      'radiusScale': radiusScale,
    });

    final elements = [
      buildCircle(),
      buildLabel(),
    ];

    reportInfo('buildElements', 'Built ${elements.length} elements');
    return elements;
  }

  /// Builds just the circle element
  CircleElement buildCircle() {
    final radius = value * radiusScale;
    
    reportInfo('buildCircle', 'Building circle element', {
      'radius': radius,
      'position': 'x: $circleX, y: $circleY',
    });

    return CircleElement(
      x: circleX,
      y: circleY,
      radius: radius,
      color: borderColor,
      fillColor: fillColor,
    );
  }

  /// Builds just the label element
  TextElement buildLabel() {
    final text = 'Value: ${(value * 100).toStringAsFixed(decimalPlaces)}%';
    
    reportInfo('buildLabel', 'Building text element', {
      'text': text,
      'position': 'x: $labelX, y: $labelY',
    });

    return TextElement(
      x: labelX,
      y: labelY,
      text: text,
      color: textColor,
      style: labelStyle,
    );
  }

  /// Creates a builder with standard settings for value display
  static DiagramElementBuilder createStandard({
    required double value,
    Color? borderColor,
    Color? fillColor,
    DiagnosticCallback? onDiagnostic,
  }) {
    final builder = DiagramElementBuilder(
      value: value,
      borderColor: borderColor ?? const Color.fromRGBO(238, 238, 238, 1),
      fillColor: fillColor ?? const Color.fromRGBO(0, 0, 255, 0.2),
      onDiagnostic: onDiagnostic,
    );

    builder.reportInfo('createStandard', 'Created standard builder', {
      'value': value,
      'borderColor': borderColor?.toString() ?? 'default',
      'fillColor': fillColor?.toString() ?? 'default',
    });

    return builder;
  }

  /// Creates a builder for a minimal display (just circle, no label)
  static DiagramElementBuilder createMinimal({
    required double value,
    Color fillColor = const Color.fromRGBO(0, 0, 255, 0.2),
    DiagnosticCallback? onDiagnostic,
  }) {
    final builder = DiagramElementBuilder(
      value: value,
      borderColor: Colors.transparent,
      fillColor: fillColor,
      labelStyle: const TextStyle(fontSize: 0), // Hide label
      onDiagnostic: onDiagnostic,
    );

    builder.reportInfo('createMinimal', 'Created minimal builder', {
      'value': value,
      'fillColor': fillColor.toString(),
    });

    return builder;
  }
}
