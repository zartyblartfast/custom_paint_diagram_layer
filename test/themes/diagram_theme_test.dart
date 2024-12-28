import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/themes/themes.dart';

void main() {
  group('DiagramTheme', () {
    test('default constructor creates instance with default values', () {
      final theme = DiagramTheme();
      
      expect(theme.elementStyles, isA<ElementStyles>());
      expect(theme.backgroundStyle, isA<BackgroundStyle>());
      expect(theme.gridStyle, isA<GridStyle>());
      expect(theme.axisStyle, isA<AxisStyle>());
      expect(theme.frameStyle, isA<FrameStyle>());
    });

    test('light theme has expected values', () {
      final theme = DiagramTheme.light();
      
      expect(theme.backgroundStyle.color, isNull);
      expect(theme.elementStyles.defaultPaint.color.value, equals(Colors.black.value));
      expect(theme.gridStyle.majorColor.value, equals(Colors.grey.value));
    });

    test('dark theme has expected values', () {
      final theme = DiagramTheme.dark();
      
      expect(theme.backgroundStyle.color?.value, equals(const Color(0xFF1E1E1E).value));
      expect(theme.elementStyles.defaultPaint.color.value, equals(Colors.white.value));
      expect(theme.gridStyle.majorColor.value, equals(Colors.white.value));
      expect(theme.gridStyle.majorOpacity, equals(0.3));
    });

    test('copyWith creates new instance with specified changes', () {
      final original = DiagramTheme.light();
      final newElementStyles = ElementStyles(
        defaultPaint: Paint()..color = Colors.blue,
      );
      final newBackgroundStyle = BackgroundStyle(
        color: Colors.grey,
      );

      final modified = original.copyWith(
        elementStyles: newElementStyles,
        backgroundStyle: newBackgroundStyle,
      );

      expect(modified.elementStyles.defaultPaint.color.value, equals(Colors.blue.value));
      expect(modified.backgroundStyle.color?.value, equals(Colors.grey.value));
      expect(modified.gridStyle, same(original.gridStyle));
    });
  });
}
