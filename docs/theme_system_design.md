# Diagram Theme System Design

## Overview
The theme system provides a way to customize the visual appearance of diagrams, supporting both light and dark themes. The system is integrated directly into the existing state management infrastructure rather than operating as a separate system.

## Design Goals
1. **Simplicity**: Integrate theming directly into the existing state management system
2. **Consistency**: Use the same patterns that work well in the existing codebase
3. **Performance**: Minimize unnecessary repaints and state updates
4. **Extensibility**: Allow for future theme customization without major refactoring

## Implementation

### Core Components

#### 1. State Integration
The theme state is managed directly by `DiagramStateManager`:
```dart
class DiagramStateManager {
  static const String kTheme = 'theme';  // Theme state key
  
  // Theme state is stored as a double (0 = light, 1 = dark, etc.)
  double get currentTheme => getValue(kTheme) ?? 0;
  
  // Toggle to next theme
  void toggleTheme() {
    final current = currentTheme;
    final next = (current + 1) % availableThemes;  // Cycle through themes
    updateValue(kTheme, next);
  }
}
```

#### 2. Theme Colors
Colors are defined as constant maps in DiagramStateManager:
```dart
// Light theme colors
static const _lightTheme = <String, Color>{
  'background': Colors.white,
  'element': Colors.black,
  'elementFill': Color(0x33448AFF),  // Light blue with opacity
  'grid': Color(0x8A000000),         // Black with opacity
  'gridMinor': Color(0x42000000),    // Black with less opacity
};

// Dark theme colors
static const _darkTheme = <String, Color>{
  'background': Color(0xFF1E1E1E),
  'element': Colors.white,
  'elementFill': Color(0x4DFFFFFF),  // White with opacity
  'grid': Color(0x8AFFFFFF),         // White with opacity
  'gridMinor': Color(0x42FFFFFF),    // White with less opacity
};
```

#### 3. Theme Application
Themes are applied through the DiagramStateManager's themeColors getter:
```dart
/// Get current theme colors
Map<String, Color> get themeColors {
  final themeIndex = _valueState[kTheme]?.toInt() ?? 0;
  switch (themeIndex) {
    case 0:
      return _lightTheme;
    case 1:
      return _darkTheme;
    default:
      return _lightTheme;
  }
}
```

### Adding New Themes

To add a new theme to the system:

1. **Define Theme Colors**:
```dart
// In DiagramStateManager
static const _customTheme = <String, Color>{
  'background': Colors.black,
  'element': Colors.green,
  'elementFill': Color(0x3300FF00),  // Semi-transparent green
  'grid': Color(0x8A00FF00),         // Semi-transparent green
  'gridMinor': Color(0x4200FF00),    // More transparent green
};
```

2. **Update Theme Getter**:
```dart
Map<String, Color> get themeColors {
  final themeIndex = _valueState[kTheme]?.toInt() ?? 0;
  switch (themeIndex) {
    case 0:
      return _lightTheme;
    case 1:
      return _darkTheme;
    case 2:
      return _customTheme;  // Add new theme case
    default:
      return _lightTheme;
  }
}
```

3. **Update Theme Toggle**:
```dart
void toggleTheme() {
  final currentTheme = _valueState[kTheme] ?? 0;
  final nextTheme = (currentTheme + 1) % 3;  // Update modulo for new theme count
  updateValue(kTheme, nextTheme.toDouble());
}
```

4. **Update UI Controls** (if needed):
```dart
IconButton(
  icon: Icon(_getThemeIcon()),  // Add method to get appropriate icon
  onPressed: () => setState(() {
    diagram.state.toggleTheme();
  }),
  tooltip: _getThemeTooltip(),  // Add method to get appropriate tooltip
),
```

### Benefits
1. **Centralized**: All theme colors managed in one place
2. **Automatic**: Elements automatically use theme colors
3. **Extensible**: Easy to add new themes
4. **Consistent**: Theme changes trigger standard update flow

### Future Extensions
1. **Theme Builder**: UI for creating custom themes
2. **Theme Import/Export**: Save and load custom themes
3. **Theme Transitions**: Smooth transitions between themes
4. **Theme Presets**: Additional built-in themes beyond light/dark
5. **Per-Element Theming**: Allow elements to override theme colors

## Testing Strategy
1. **Unit Tests**: 
   - Verify theme state management
   - Test theme cycling
   - Validate color values
2. **Integration Tests**: 
   - Ensure proper theme application
   - Test theme persistence
3. **Visual Tests**: 
   - Confirm correct rendering in all themes
   - Verify element appearance
4. **Performance Tests**: 
   - Verify no degradation from theme changes
   - Test theme switching performance

## Migration Plan
1. Update `DiagramStateManager` to include theme state
2. Modify base diagram classes to use theme colors
3. Update existing demos to support themes
4. Add theme toggle controls to demo UIs

## Documentation
1. Update integration guide with theme support
2. Document theme customization API
3. Add theme examples to demo documentation
4. Include theme best practices in developer guide
