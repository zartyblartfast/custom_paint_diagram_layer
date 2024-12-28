import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/themes/themes.dart';

void main() {
  group('DiagramThemeManager', () {
    test('default constructor creates instance with light theme', () {
      final manager = DiagramThemeManager();
      expect(manager.theme, isA<DiagramTheme>());
      expect(manager.theme.elementStyles.defaultPaint.color, equals(Colors.black));
    });

    test('constructor with theme parameter uses provided theme', () {
      final customTheme = DiagramTheme.dark();
      final manager = DiagramThemeManager(theme: customTheme);
      expect(manager.theme, same(customTheme));
    });

    test('light() factory creates manager with light theme', () {
      final manager = DiagramThemeManager.light();
      expect(manager.theme.elementStyles.defaultPaint.color, equals(Colors.black));
    });

    test('dark() factory creates manager with dark theme', () {
      final manager = DiagramThemeManager.dark();
      expect(manager.theme.backgroundStyle.color, equals(const Color(0xFF1E1E1E)));
    });

    test('setting theme updates current theme', () {
      final manager = DiagramThemeManager.light();
      final darkTheme = DiagramTheme.dark();
      
      manager.theme = darkTheme;
      
      expect(manager.theme, same(darkTheme));
    });
  });
}
