import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/widgets/diagram_widget_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/widgets/diagram_controls_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/utils/diagram_elements_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/utils/group_diagram_element_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/connector_element.dart' show Socket;
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/grid_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/frame_element.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/elements/axis_element.dart';

/// Set to true to enable diagnostic output
const bool _DEBUG = true;

/// Initialize global diagnostic settings
void main() {
  diagnosticsEnabled = _DEBUG;
  runApp(const MaterialApp(
    home: StateManagedDiagram3Demo(),
  ));
}

/// A test diagram showing two labeled rectangles with a connector
class StateManagedDiagram3 extends StateManagedDiagramBase {
  static const String rect1Key = 'rect1';
  static const String rect2Key = 'rect2';
  static const String rect3Key = 'rect3';  // New key for third rectangle
  static const double _defaultRect1 = 0.25;
  static const double _defaultRect2 = 0.75;
  static const double _defaultRect3 = 0.5;
  late final DiagramStateInitializer _stateInitializer;

  StateManagedDiagram3({
    required super.config,
  }) {
    // Initialize state with validation and diagnostics
    _stateInitializer = DiagramStateInitializer.createStandard(
      diagram: this,
      initialValues: {
        rect1Key: _defaultRect1,
        rect2Key: _defaultRect2,
        rect3Key: _defaultRect3,
        DiagramStateManager.kTheme: 0,  // Start with light theme
      },
      onStateChange: (change) {
        if (isDiagnosticsEnabled) {
          reportInfo('onStateChange', 'State changed: $change');
        }
      },
    );
  }

  // Helper to map slider value (0-1) to coordinate space
  double mapToCoordinate(double value) {
    return -2.5 + (value * 5.0); // Map 0-1 to -2.5 to 2.5
  }

  // Value getters and setters
  double get rect1Value => state.getValue(rect1Key) ?? _defaultRect1;
  double get rect2Value => state.getValue(rect2Key) ?? _defaultRect2;
  double get rect3Value => state.getValue(rect3Key) ?? _defaultRect3;
  bool get isDarkTheme => state.isDarkTheme;

  void setRect1Value(double value) {
    state.updateValue(rect1Key, value);
    updateElements();
  }

  void setRect2Value(double value) {
    state.updateValue(rect2Key, value);
    updateElements();
  }

  void setRect3Value(double value) {
    state.updateValue(rect3Key, value);
    updateElements();
  }

  @override
  List<DrawableElement> createElements() {
    final colors = state.themeColors;
    final elements = <DrawableElement>[];

    // Add background rectangle
    elements.add(DiagramThemeBuilder.createBackgroundElement(config, colors));

    // Add grid if enabled
    if (showGrid) {
      elements.add(createGridElement());
    }

    // Add diagram-specific elements
    elements.addAll(createDiagramElements());

    // Add standard elements
    if (showFrame) {
      elements.add(createFrameElement());
    }

    if (showAxes) {
      elements.addAll(createAxisElements());
    }

    return elements;
  }

  @override
  List<DrawableElement> createDiagramElements() {
    final colors = state.themeColors;
    final elements = <DrawableElement>[];
    final builder = GroupDiagramElementBuilder(
      colors: colors,
      config: config,
    );

    // Map slider values to coordinate space
    final rect1X = mapToCoordinate(rect1Value);
    final rect2X = mapToCoordinate(rect2Value);
    final rect3X = mapToCoordinate(rect3Value);

    // Create groups with labels
    final group1 = builder.createLabeledGroup(
      x: rect1X,
      y: 0,
      text: 'Group 1',
    );
    elements.add(group1);

    final group2 = builder.createLabeledGroup(
      x: rect2X,
      y: 0,
      text: 'Group 2',
    );
    elements.add(group2);

    final group3 = builder.createLabeledGroup(
      x: rect3X,
      y: 1.5,  // Offset vertically
      text: 'Group 3',
    );
    elements.add(group3);

    // Add connectors between groups using socket positions
    elements.add(builder.createConnectorWithSockets(
      startGroup: group1,
      startSocket: Socket.R,  // Right side of group 1
      endGroup: group2,
      endSocket: Socket.L,    // Left side of group 2
    ));

    elements.add(builder.createConnectorWithSockets(
      startGroup: group1,
      startSocket: Socket.T,  // Top of group 1
      endGroup: group3,
      endSocket: Socket.B,    // Bottom of group 3
    ));

    elements.add(builder.createConnectorWithSockets(
      startGroup: group2,
      startSocket: Socket.T,  // Top of group 2
      endGroup: group3,
      endSocket: Socket.B,    // Bottom of group 3
    ));

    return elements;
  }

  @override
  GridElement createGridElement() {
    return DiagramThemeBuilder.createGridElement(state.themeColors);
  }

  @override
  FrameElement createFrameElement() {
    return DiagramThemeBuilder.createFrameElement(state.themeColors);
  }

  @override
  List<AxisElement> createAxisElements() {
    return DiagramThemeBuilder.createAxisElements(state.themeColors);
  }
}

/// Widget that displays StateManagedDiagram3 with controls
class StateManagedDiagram3Demo extends StatefulWidget {
  final bool useStandalone;
  
  const StateManagedDiagram3Demo({
    super.key,
    this.useStandalone = true,
  });

  @override
  State<StateManagedDiagram3Demo> createState() => _StateManagedDiagram3DemoState();
}

class _StateManagedDiagram3DemoState extends State<StateManagedDiagram3Demo> {
  late StateManagedDiagram3 _diagram;
  late StateChangeHandler _stateHandler;
  String _lastStateChange = 'No changes yet';

  @override
  void initState() {
    super.initState();
    
    // Create diagram instance with custom coordinate system
    _diagram = StateManagedDiagram3(
      config: DiagramConfigBuilder.createStandardConfig(
        // Size based on standalone mode
        width: widget.useStandalone ? 600 : 400,
        height: widget.useStandalone ? 400 : 300,
        
        // Custom coordinate system
        xRangeMin: -5,
        xRangeMax: 5,
        yRangeMin: -3,
        yRangeMax: 3,
        origin: const Offset(0, 0),
        scale: 1.0,
        
        // Default visibility
        showGrid: false,  // Grid starts hidden
        showFrame: true,  // Frame starts visible
        showAxes: true,   // Axes start visible
      ),
    );

    // Setup state change handling
    _stateHandler = StateChangeHandler.createStandard(
      state: _diagram.state,
      onStateChange: (change) => setState(() => _lastStateChange = change),
    );
  }

  @override
  void dispose() {
    _stateHandler.dispose();
    _diagram.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DiagramWidgetBuilder(
      diagram: _diagram,
      standalone: widget.useStandalone,
      title: widget.useStandalone ? 'State Managed Diagram 3 Demo' : null,
      width: widget.useStandalone ? null : _diagram.config.width,
      height: widget.useStandalone ? null : _diagram.config.height,
      controls: _buildControls(),
    ).build(context);
  }

  Widget _buildControls() {
    return DiagramControlsBuilder(
      diagram: _diagram,
      stateChangeText: _lastStateChange,
      sliderControls: {
        StateManagedDiagram3.rect1Key: (value) => setState(() {
          _diagram.setRect1Value(value);
        }),
        StateManagedDiagram3.rect2Key: (value) => setState(() {
          _diagram.setRect2Value(value);
        }),
        StateManagedDiagram3.rect3Key: (value) => setState(() {
          _diagram.setRect3Value(value);
        }),
      },
      visibilityToggles: VisibilityToggle.standardToggles(_diagram),
      extraControls: [
        IconButton(
          icon: Icon(_diagram.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => setState(() {
            _diagram.state.toggleTheme();
          }),
          tooltip: _diagram.isDarkTheme ? 'Switch to light theme' : 'Switch to dark theme',
        ),
      ],
    ).build(context);
  }
}
