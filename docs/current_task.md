# Current Task: Develop and Validate the CoordinateSystem Class

## Task Objective
The `CoordinateSystem` class is the foundation for the diagram layer. It handles all coordinate transformations, scaling, and origin placement, ensuring consistent mapping between app space and diagram space.

## Features to Implement

### Properties
- `origin: Offset` – The diagram's origin in the canvas space
- `xRangeMin: double`, `xRangeMax: double` – Range of values on the x-axis in diagram space
- `yRangeMin: double`, `yRangeMax: double` – Range of values on the y-axis in diagram space
- `scale: double` – Scaling factor for transforming diagram space to canvas space

### Methods
- `mapValueToDiagram(x: double, y: double): Offset`
  - Transforms app-level values to diagram space coordinates
- `mapDiagramToValue(x: double, y: double): Offset`
  - Transforms diagram space coordinates back to app-level values

## Implementation Steps

### 1. Define the Class
1. Create `lib/custom_paint_diagram_layer/coordinate_system.dart`
2. Add the required properties and a constructor for initialization

### 2. Implement Transformation Methods
1. `mapValueToDiagram`:
   - Apply scaling and offset adjustments to app-level coordinates
2. `mapDiagramToValue`:
   - Reverse the scaling and offset adjustments to recover app-level coordinates

### 3. Write Tests
1. Create test file: `test/coordinate_system_test.dart`
2. Add test cases for:
   - Default scaling and centered origin
   - Custom scaling factors
   - Negative axis ranges

## Code Implementation

### CoordinateSystem Class
```dart
import 'dart:ui';

class CoordinateSystem {
  final Offset origin;
  final double xRangeMin;
  final double xRangeMax;
  final double yRangeMin;
  final double yRangeMax;
  final double scale;

  CoordinateSystem({
    required this.origin,
    required this.xRangeMin,
    required this.xRangeMax,
    required this.yRangeMin,
    required this.yRangeMax,
    required this.scale,
  });

  Offset mapValueToDiagram(double x, double y) {
    double diagramX = origin.dx + (x - xRangeMin) * scale;
    double diagramY = origin.dy - (y - yRangeMin) * scale; // Invert Y for canvas
    return Offset(diagramX, diagramY);
  }

  Offset mapDiagramToValue(double x, double y) {
    double appX = (x - origin.dx) / scale + xRangeMin;
    double appY = (origin.dy - y) / scale + yRangeMin; // Invert Y for app
    return Offset(appX, appY);
  }
}
```

### Unit Tests
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_paint_diagram_layer/coordinate_system.dart';

void main() {
  group('CoordinateSystem', () {
    test('maps app values to diagram space correctly', () {
      final coordinateSystem = CoordinateSystem(
        origin: Offset(100, 100),
        xRangeMin: 0,
        xRangeMax: 200,
        yRangeMin: 0,
        yRangeMax: 100,
        scale: 2.0,
      );

      final diagramPoint = coordinateSystem.mapValueToDiagram(50, 25);
      expect(diagramPoint, Offset(200, 50)); // Scale and origin applied
    });

    test('maps diagram values back to app space correctly', () {
      final coordinateSystem = CoordinateSystem(
        origin: Offset(100, 100),
        xRangeMin: 0,
        xRangeMax: 200,
        yRangeMin: 0,
        yRangeMax: 100,
        scale: 2.0,
      );

      final appPoint = coordinateSystem.mapDiagramToValue(200, 50);
      expect(appPoint, Offset(50, 25)); // Reverse transformation
    });

    test('handles negative ranges', () {
      final coordinateSystem = CoordinateSystem(
        origin: Offset(0, 0),
        xRangeMin: -100,
        xRangeMax: 100,
        yRangeMin: -100,
        yRangeMax: 100,
        scale: 1.0,
      );

      final diagramPoint = coordinateSystem.mapValueToDiagram(-50, -50);
      expect(diagramPoint, Offset(-50, 50)); // Correctly maps negative space
    });
  });
}
```

## Success Criteria

### 1. Run Tests
- Execute `flutter test test/coordinate_system_test.dart`
- Ensure all tests pass for various configurations

### 2. Manual Verification
- Create a small Flutter app to visualize the transformations
- Render points on a canvas using `CustomPaint` to confirm mappings visually

### 3. Validate Edge Cases
- Confirm handling of:
  - Extreme values (e.g., very large or very small scale)
  - Negative or inverted axis ranges (e.g., `xRangeMax < xRangeMin`)

## Next Steps
1. Proceed to develop the `DrawableElement` abstract class and its first concrete subclass (e.g., `LineElement`)
2. Integrate the `CoordinateSystem` into these classes for handling coordinate transformations