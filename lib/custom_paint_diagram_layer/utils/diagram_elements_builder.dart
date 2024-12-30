import 'package:flutter/material.dart';
import '../drawable_element.dart';
import '../config/diagram_config.dart';
import '../utils/diagram_theme_builder.dart';
import '../utils/diagram_element_factory.dart';
import '../utils/diagnostic_helper.dart';

/// A utility class that handles the assembly of all diagram elements in the correct order.
/// This ensures consistent element layering across different diagram implementations.
class DiagramElementsBuilder with DiagnosticHelper {
  @override
  String get diagnosticSource => 'DiagramElementsBuilder';

  @override
  DiagnosticCallback? get onDiagnostic => null;

  final DiagramConfig config;
  final Map<String, Color> themeColors;
  final bool showGrid;
  final bool showFrame;
  final bool showAxes;
  final double value;

  const DiagramElementsBuilder({
    required this.config,
    required this.themeColors,
    required this.showGrid,
    required this.showFrame,
    required this.showAxes,
    required this.value,
  });

  /// Creates a standard diagram elements builder
  static DiagramElementsBuilder createStandard({
    required DiagramConfig config,
    required Map<String, Color> themeColors,
    required double value,
    bool showGrid = true,
    bool showFrame = true,
    bool showAxes = true,
  }) {
    return DiagramElementsBuilder(
      config: config,
      themeColors: themeColors,
      showGrid: showGrid,
      showFrame: showFrame,
      showAxes: showAxes,
      value: value,
    );
  }

  /// Builds all elements in the correct order:
  /// 1. Background
  /// 2. Grid (if enabled)
  /// 3. Diagram elements
  /// 4. Frame (if enabled)
  /// 5. Axes (if enabled)
  List<DrawableElement> buildElements() {
    final elements = <DrawableElement>[];

    reportInfo('buildElements', 'Building elements with theme colors: $themeColors');

    // Add background rectangle
    elements.add(DiagramThemeBuilder.createBackgroundElement(config, themeColors));

    // Add grid if enabled
    if (showGrid) {
      elements.add(DiagramThemeBuilder.createGridElement(themeColors));
    }

    // Add diagram elements
    elements.addAll(DiagramElementFactory.createStandard(
      value: value,
      fillColor: themeColors['elementFill']!,
      borderColor: themeColors['element']!,
    ).createElements());

    // Add standard elements
    if (showFrame) {
      elements.add(DiagramThemeBuilder.createFrameElement(themeColors));
    }

    if (showAxes) {
      elements.addAll(DiagramThemeBuilder.createAxisElements(themeColors));
    }

    return elements;
  }
}
