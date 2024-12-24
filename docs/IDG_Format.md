# IDG (Interactive Diagram Graphics) Format

## Overview
The IDG format is a proposed specification for a human and AI-friendly diagram definition language, built on the Custom Paint Diagram Layer framework. It aims to provide a structured, unambiguous way to define interactive diagrams that can be easily created, modified, and understood by both humans and AI assistants.

## Vision and Goals

1. **Human-AI Collaboration**
   - Natural language to diagram conversion
   - AI-assisted diagram creation and modification
   - Semantic understanding of diagram components
   - Context-aware element relationships

2. **Structured Definition**
   - Clear, unambiguous element specifications
   - Semantic relationships between elements
   - State and behavior definitions
   - Coordinate system abstractions

3. **Interactive Capabilities**
   - Controller-based state management
   - Event handling and animations
   - User interaction patterns
   - Real-time updates

## Proposed Format Structure

### Basic Structure
```json
{
  "version": "2.0",
  "metadata": {
    "name": "Example Diagram",
    "description": "A sample interactive diagram",
    "author": "Human-AI Collaboration",
    "created": "2024-12-24T10:27:31Z"
  },
  "renderer": {
    "type": "DiagramRendererBase",
    "config": {
      "coordinateSystem": {
        "origin": {"x": 0, "y": 0},
        "xRange": {"min": -10, "max": 10},
        "yRange": {"min": -10, "max": 10},
        "scale": 1.0
      }
    }
  },
  "controller": {
    "type": "DiagramControllerMixin",
    "state": {
      "value": 0.5,
      "otherValue": 100
    },
    "bindings": [
      {
        "stateKey": "value",
        "elementId": "circle1",
        "property": "radius",
        "transform": "value * 2 + 1"
      }
    ]
  },
  "elements": [
    {
      "id": "circle1",
      "type": "CircleElement",
      "properties": {
        "x": 0,
        "y": 0,
        "radius": 1,
        "color": "#FF0000",
        "fillColor": {"color": "#FF0000", "opacity": 0.3}
      }
    },
    {
      "id": "group1",
      "type": "GroupElement",
      "properties": {
        "x": 2,
        "y": 2
      },
      "children": [
        {
          "type": "RectangleElement",
          "properties": {
            "x": -1,
            "y": -1,
            "width": 2,
            "height": 2,
            "color": "#0000FF"
          }
        }
      ]
    }
  ],
  "interactions": {
    "onValueChanged": {
      "type": "SliderInteraction",
      "stateKey": "value",
      "min": 0,
      "max": 1,
      "label": "Adjust Size"
    }
  }
}
```

### Semantic Layer
```json
{
  "relationships": [
    {
      "type": "connection",
      "from": "circle1",
      "to": "group1",
      "style": "arrow"
    }
  ],
  "constraints": [
    {
      "type": "alignment",
      "elements": ["circle1", "group1"],
      "axis": "vertical"
    }
  ],
  "layout": {
    "type": "flowchart",
    "direction": "LR",
    "spacing": 2
  }
}
```

## Integration with New Architecture

### 1. DiagramRendererBase Integration
```dart
class IDGRenderer extends DiagramRendererBase {
  final String idgContent;
  
  IDGRenderer(this.idgContent) {
    final idg = IDGParser.parse(idgContent);
    initializeFromIDG(idg);
  }
  
  @override
  List<DrawableElement> createElements() {
    return idg.elements.map((e) => e.toDrawableElement()).toList();
  }
}
```

### 2. Controller State Management
```dart
mixin IDGControllerMixin on DiagramControllerMixin {
  void initializeFromIDG(IDGDocument idg) {
    initializeController(
      defaultValues: idg.controller.state,
      bindings: idg.controller.bindings,
    );
  }
}
```

## AI Assistance Features

1. **Natural Language Processing**
   ```
   "Create a flowchart with three boxes connected by arrows"
   ↓
   {
     "elements": [...],
     "relationships": [...],
     "layout": {"type": "flowchart"}
   }
   ```

2. **Semantic Understanding**
   - Element purpose and meaning
   - Relationship types
   - Layout intentions
   - Interactive behaviors

3. **Context-Aware Modifications**
   - Smart element placement
   - Automatic layout adjustments
   - Style consistency
   - Constraint maintenance

## Development Roadmap

### Phase 1: Core Format
- [ ] Define base format specification
- [ ] Implement basic serialization/deserialization
- [ ] Create format validation tools
- [ ] Add example diagrams

### Phase 2: AI Integration
- [ ] Develop natural language processing
- [ ] Add semantic understanding
- [ ] Create AI assistance tools
- [ ] Build diagram suggestion system

### Phase 3: Interactive Features
- [ ] Implement state management
- [ ] Add animation support
- [ ] Create interaction patterns
- [ ] Build real-time updates

### Phase 4: Tools and Ecosystem
- [ ] Create IDG editor
- [ ] Build format converter
- [ ] Develop validation tools
- [ ] Create component library

## Contributing

To contribute to the IDG format development:

1. **Format Enhancement**
   - Propose new format features
   - Create example diagrams
   - Test with AI assistants
   - Document use cases

2. **Tool Development**
   - Build format validators
   - Create conversion tools
   - Develop editing utilities
   - Write test suites

3. **Documentation**
   - Update specifications
   - Add examples
   - Write tutorials
   - Create reference guides

## Resources

- [Element Architecture](Element_Architecture.md)
- [Diagram Integration Architecture](diagram_integration_architecture.md)
- [Creating New Demos](Creating_New_Demos.md)
- [DL Compliance](Diagram_DL_Compliance.md)

## Version History

### v2.0 (Proposed)
- AI-friendly format structure
- Controller state management
- Semantic layer
- Interactive features

### v1.0 (Initial Concept)
- Basic format structure
- Element serialization
- File-based operations
- Simple examples
