# IDG (Interactive Diagram Graphics) Format

## Overview
The IDG format is a JSON-based specification for storing and sharing interactive diagrams created with the Custom Paint Diagram Layer framework. It enables serialization and deserialization of diagram elements, coordinate systems, and properties.

## Current Implementation Status

### Completed Features

1. **Core Format Structure**
   - JSON-based serialization
   - Support for basic diagram elements
   - Coordinate system export/import
   - Element properties preservation

2. **Element Support**
   - LineElement with position and color properties
   - Basic styling (colors, stroke widths)
   - Element positioning within coordinate system

3. **CLI Tool**
   - Command-line interface for import/export
   - File-based operations
   - Basic error handling

4. **Import/Export Pipeline**
   - DiagramExporter for converting diagrams to IDG
   - DiagramLoader for creating diagrams from IDG
   - JSON parsing and validation

5. **Demo Implementation**
   - Working example with imported diagram
   - Visual verification of imported elements
   - Cross-platform compatibility

### Current Limitations

1. **Element Types**
   - Limited to basic elements (currently Lines)
   - Complex elements not yet supported
   - No support for compound elements

2. **Properties**
   - Basic property set only
   - Advanced styling options not implemented
   - No animation state preservation

3. **Interactivity**
   - Static diagram import only
   - No preservation of interactive behaviors
   - Limited state management

## Technical Details

### File Format
```json
{
  "version": "1.0",
  "coordinateSystem": {
    "origin": {"x": 400, "y": 300},
    "xRange": {"min": -400, "max": 400},
    "yRange": {"min": -300, "max": 300},
    "scale": 1.0
  },
  "elements": [
    {
      "type": "line",
      "properties": {
        "x1": 0,
        "y1": 0,
        "x2": 100,
        "y2": 100,
        "color": "#FF0000",
        "strokeWidth": 2.0
      }
    }
    // ... more elements
  ]
}
```

### Usage Example
```dart
// Export a diagram
final exporter = DiagramExporter();
final idgContent = exporter.exportDiagram(myDiagram);
await File('diagram.idg').writeAsString(idgContent);

// Import a diagram
final loader = DiagramLoader();
final diagram = await loader.loadFromFile('diagram.idg');
```

## Next Steps

### Short Term Goals

1. **Element Support Expansion**
   - Add CircleElement support
   - Implement PolygonElement export/import
   - Add BezierCurveElement capabilities
   - Support for text elements

2. **Property Enhancement**
   - Full color property support (including opacity)
   - Gradient and pattern fills
   - Extended stroke properties
   - Transform matrices

3. **Testing and Validation**
   - Comprehensive test suite for all elements
   - Edge case handling
   - Format validation tools
   - Performance benchmarking

### Medium Term Goals

1. **Interactive Features**
   - State preservation in IDG format
   - Animation keyframe support
   - Event handler serialization
   - Interactive property binding

2. **Tool Enhancement**
   - GUI for IDG file manipulation
   - Preview capability in CLI
   - Batch processing support
   - Format conversion utilities

3. **Integration Features**
   - Library of reusable components
   - Template system
   - Component composition tools
   - Version control integration

### Long Term Vision

1. **Ecosystem Development**
   - Standard library of shareable components
   - Online repository of IDG diagrams
   - Community contribution system
   - Integration with other tools

2. **Advanced Features**
   - Real-time collaboration support
   - Version control for diagrams
   - Differential updates
   - Plugin system

3. **Platform Expansion**
   - Web-based IDG viewer
   - Mobile support
   - Desktop applications
   - Cross-platform tools

## Contributing

To contribute to the IDG format development:

1. **Adding New Elements**
   - Implement element serialization in `diagram_exporter.dart`
   - Add deserialization in `diagram_loader.dart`
   - Create tests in `diagram_exporter_test.dart`
   - Update documentation

2. **Testing**
   - Run existing tests: `flutter test`
   - Add new test cases
   - Verify cross-platform compatibility
   - Test with real-world diagrams

3. **Documentation**
   - Update this document with new features
   - Add examples for new capabilities
   - Document best practices
   - Provide migration guides

## Resources

- [Element Architecture](Element_Architecture.md)
- [Implementation Approach](Implementation_Approach.md)
- [Creating New Demos](Creating_New_Demos.md)

## Version History

### v1.0 (Current)
- Initial implementation
- Basic element support
- File-based import/export
- CLI tool
- Demo implementation
