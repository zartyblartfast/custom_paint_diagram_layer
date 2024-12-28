import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/widgets/diagram_widget_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/widgets/diagram_controls_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/utils/diagram_elements_builder.dart';

/// Set to true to enable diagnostic output
const bool _DEBUG = false;

/// Initialize global diagnostic settings
void main() {
  diagnosticsEnabled = _DEBUG;
  runApp(const MaterialApp(
    home: StateManagedDiagram2Demo(),
  ));
}

/// A test diagram that uses the state management system with theme support.
class StateManagedDiagram2 extends StateManagedDiagramBase {
  static const String valueKey = 'value';
  static const double _sliderStartValue = 0.5;
  late final DiagramStateInitializer _stateInitializer;

  StateManagedDiagram2({
    required super.config,
  }) {
    // Initialize state with validation and diagnostics
    _stateInitializer = DiagramStateInitializer.createStandard(
      diagram: this,
      initialValues: {
        valueKey: _sliderStartValue,
        DiagramStateManager.kTheme: 0,  // Start with light theme
      },
      onStateChange: (change) {
        if (isDiagnosticsEnabled) {
          reportInfo('onStateChange', 'State changed: $change');
        }
      },
    );
  }

  void setValue(double value) {
    state.updateValue(valueKey, value);
    updateElements();
  }

  double get value => state.getValue(valueKey) ?? _sliderStartValue;
  bool get isDarkTheme => state.isDarkTheme;

  @override
  List<DrawableElement> createElements() {
    final colors = state.themeColors;
    final elements = <DrawableElement>[];

    // Add background rectangle
    elements.add(DiagramThemeBuilder.createBackgroundElement(config, colors));

    // Add grid if enabled
    if (showGrid) {
      elements.add(DiagramThemeBuilder.createGridElement(colors));
    }

    // Add diagram elements
    elements.addAll(DiagramElementBuilder.createStandard(
      value: value,
      fillColor: colors['elementFill']!,
      borderColor: colors['element']!,
    ).buildElements());

    // Add a rectangle that responds to the slider
    elements.add(RectangleElement(
      x: -1.0,  // Center the rectangle
      y: -0.5,
      width: 2.0 * value,  // Width changes with slider
      height: 1.0,
      color: colors['element']!,
      fillColor: colors['elementFill']!,
      fillOpacity: 0.2,
      borderRadius: 0.2,
    ));

    // Add standard elements
    if (showFrame) {
      elements.add(DiagramThemeBuilder.createFrameElement(colors));
    }

    if (showAxes) {
      elements.addAll(DiagramThemeBuilder.createAxisElements(colors));
    }

    return elements;
  }

  @override
  List<DrawableElement> createDiagramElements() {
    final colors = state.themeColors;
    return DiagramElementBuilder.createStandard(
      value: value,
      fillColor: colors['elementFill']!,
      borderColor: colors['element']!,
    ).buildElements();
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

/// Widget that displays StateManagedDiagram2 with controls
class StateManagedDiagram2Demo extends StatefulWidget {
  final bool useStandalone;
  
  const StateManagedDiagram2Demo({
    super.key,
    this.useStandalone = true,
  });

  @override
  State<StateManagedDiagram2Demo> createState() => _StateManagedDiagram2DemoState();
}

class _StateManagedDiagram2DemoState extends State<StateManagedDiagram2Demo> {
  late final StateManagedDiagram2 diagram;
  late final StateChangeHandler stateHandler;
  double get _sliderValue => diagram.value;
  String _lastStateChange = 'No changes yet';

  @override
  void initState() {
    super.initState();
    
    // Create diagram instance with custom coordinate system
    diagram = StateManagedDiagram2(
      config: DiagramConfigBuilder.createStandardConfig(
        // Size based on standalone mode
        width: widget.useStandalone ? 600 : 400,
        height: widget.useStandalone ? 400 : 300,
        
        // Custom coordinate system
        xRangeMin: -5,
        xRangeMax: 5,
        yRangeMin: -5,
        yRangeMax: 5,
        origin: const Offset(0, 0),
        scale: 1.0,
        
        // Default visibility
        showGrid: false,  // Grid starts hidden
        showFrame: true,  // Frame starts visible
        showAxes: true,   // Axes start visible
      ),
    );

    // Setup state change handling
    stateHandler = StateChangeHandler.createStandard(
      state: diagram.state,
      onStateChange: (change) => setState(() => _lastStateChange = change),
    );
  }

  @override
  void dispose() {
    stateHandler.dispose();
    diagram.dispose();
    super.dispose();
  }

  Widget _buildControls() {
    return DiagramControlsBuilder(
      diagram: diagram,
      stateChangeText: _lastStateChange,
      sliderControls: {
        'value': (value) => setState(() {
          diagram.setValue(value);
        }),
      },
      visibilityToggles: VisibilityToggle.standardToggles(diagram),
      extraControls: [
        IconButton(
          icon: Icon(diagram.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => setState(() {
            diagram.state.toggleTheme();
          }),
          tooltip: diagram.isDarkTheme ? 'Switch to light theme' : 'Switch to dark theme',
        ),
      ],
    ).build(context);
  }

  @override
  Widget build(BuildContext context) {
    return DiagramWidgetBuilder(
      diagram: diagram,
      standalone: widget.useStandalone,
      title: widget.useStandalone ? 'State Managed Diagram with Themes' : null,
      width: widget.useStandalone ? null : diagram.canvasWidth,
      height: widget.useStandalone ? null : diagram.canvasHeight,
      controls: _buildControls(),
    ).build(context);
  }
}