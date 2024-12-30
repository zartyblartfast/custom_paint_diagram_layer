/// @Deprecated('Use DiagramElementFactory instead. This class will be removed in a future version.')
/// A utility class to build diagram elements in a structured way.
/// 
/// This builder provides a type-safe and maintainable way to create
/// common diagram elements with customizable styling.
/// 
/// @deprecated This file is kept only for backward compatibility and will be removed soon.
/// Please migrate to using DiagramElementFactory instead.
@Deprecated('Use DiagramElementFactory instead. This class will be removed in a future version.')
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

  const DiagramElementBuilder({
    required this.value,
    required this.borderColor,
    required this.fillColor,
    this.textColor = Colors.black,
    this.labelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
    this.circleX = 0,
    this.circleY = 0,
    this.labelX = 0,
    this.labelY = 0,
    this.radiusScale = 1.0,
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

  /// Creates a standard diagram element builder with theme colors
  static DiagramElementBuilder createStandard({
    required double value,
    required Color fillColor,
    required Color borderColor,
  }) {
    return DiagramElementBuilder(
      value: value,
      fillColor: fillColor,
      borderColor: borderColor,
    );
  }

  /// Creates a builder for a minimal display (just circle, no label)
  static DiagramElementBuilder createMinimal({
    required double value,
    Color fillColor = const Color.fromRGBO(0, 0, 255, 0.2),
    DiagnosticCallback? onDiagnostic,
  }) {
    return DiagramElementBuilder(
      value: value,
      fillColor: fillColor,
      borderColor: Colors.grey,
      onDiagnostic: onDiagnostic,
    );
  }

  /// Builds just the circle element
  CircleElement buildCircle() {
    reportInfo('buildCircle', 'Building circle element');
    return CircleElement(
      x: circleX,
      y: circleY,
      radius: value * radiusScale,
      color: borderColor,
      fillColor: fillColor,
    );
  }

  /// Builds the label element
  TextElement buildLabel() {
    reportInfo('buildLabel', 'Building label element');
    return TextElement(
      x: labelX,
      y: labelY,
      text: value.toStringAsFixed(decimalPlaces),
      color: textColor,
      style: labelStyle,
    );
  }

  /// Builds all diagram elements
  List<DrawableElement> buildElements() {
    reportInfo('buildElements', 'Building all elements');
    return [
      buildCircle(),
      buildLabel(),
    ];
  }
}
