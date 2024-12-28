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
  static const String kTheme = 'theme';  // New state key
  
  // Theme state accessor
  bool get isDarkTheme => getValue(kTheme) ?? false;
  
  // Theme state mutator
  void toggleTheme() => updateValue(kTheme, !isDarkTheme);
}
```

#### 2. Theme Colors
Colors are defined based on the theme state:
```dart
// Light theme colors
static const lightTheme = {
  'background': Colors.white,
  'element': Colors.black,
  'grid': {
    'major': Colors.black54,
    'minor': Colors.black26,
  },
};

// Dark theme colors
static const darkTheme = {
  'background': Color(0xFF1E1E1E),
  'element': Colors.white,
  'grid': {
    'major': Colors.white54,
    'minor': Colors.white26,
  },
};
```

#### 3. Theme Application
Themes are applied in the diagram's paint and element creation methods:
```dart
class StateManagedDiagram extends StateManagedDiagramBase {
  @override
  void onPaint(Canvas canvas, Size size, CoordinateSystem coords) {
    final isDark = state.isDarkTheme;
    final colors = isDark ? darkTheme : lightTheme;
    
    // Apply theme colors during painting
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = colors['background'],
    );
    // ... rest of painting
  }
}
```

### State Flow
1. User clicks theme toggle button
2. `DiagramStateManager.toggleTheme()` is called
3. State change triggers normal state update flow
4. Diagram repaints with new theme colors

### Benefits
1. **Simplicity**: No parallel state systems or complex theme managers
2. **Integration**: Uses existing state management patterns
3. **Reliability**: Theme changes trigger the same well-tested update mechanisms
4. **Maintainability**: Minimal new code, mostly reusing existing patterns

### Future Extensions
1. **Custom Themes**: Allow users to define their own themes
2. **Theme Properties**: Add more customizable properties (fonts, strokes, etc.)
3. **Theme Transitions**: Smooth transitions between themes
4. **Theme Presets**: Additional built-in themes beyond light/dark

## Migration Plan
1. Update `DiagramStateManager` to include theme state
2. Modify base diagram classes to use theme colors
3. Update existing demos to support themes
4. Add theme toggle controls to demo UIs

## Testing Strategy
1. **Unit Tests**: Verify theme state management
2. **Integration Tests**: Ensure proper theme application
3. **Visual Tests**: Confirm correct rendering in both themes
4. **Performance Tests**: Verify no degradation from theme changes

## Documentation
1. Update integration guide with theme support
2. Document theme customization API
3. Add theme examples to demo documentation
4. Include theme best practices in developer guide
