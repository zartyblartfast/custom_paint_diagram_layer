import 'package:flutter/material.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/widgets/diagram_widget_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/widgets/diagram_controls_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/utils/diagram_config_builder.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/utils/state_change_handler.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/utils/diagram_element_factory.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/utils/diagram_state_initializer.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/utils/diagnostic_helper.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/state/diagram_state_manager.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/config/diagram_config.dart';
import 'package:custom_paint_diagram_layer/custom_paint_diagram_layer/state/state_managed_diagram_base.dart';

/// Set to true to enable diagnostic output
const bool _DEBUG = false;

/// Initialize global diagnostic settings
void main() {
  diagnosticsEnabled = _DEBUG;
  runApp(const MaterialApp(
    home: StateManagedDiagram1Demo(),
  ));
}

/// A test diagram that uses the new state management system.
/// This diagram provides the same functionality as CoreDiagram1 but uses
/// the new state management approach.
class StateManagedDiagram1 extends StateManagedDiagramBase {
  static const String valueKey = 'value';
  static const double _sliderStartValue = 0.5;
  late final DiagramStateInitializer _stateInitializer;

  StateManagedDiagram1({
    required super.config,
  }) {
    // Initialize state with validation and diagnostics
    _stateInitializer = DiagramStateInitializer.createStandard(
      diagram: this,
      initialValues: {valueKey: _sliderStartValue},
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

  @override
  List<DrawableElement> createDiagramElements() {
    List<DrawableElement> elements = [];
    elements.addAll(DiagramElementFactory.createStandard(
      value: value,
      fillColor: const Color.fromRGBO(0, 0, 255, 0.2),
      borderColor: const Color.fromRGBO(238, 238, 238, 1),
    ).createElements());
    return elements;
  }
}

/// Widget that displays StateManagedDiagram1 with controls
class StateManagedDiagram1Demo extends StatefulWidget {
  final bool useStandalone;
  
  const StateManagedDiagram1Demo({
    super.key,
    this.useStandalone = true,
  });

  @override
  State<StateManagedDiagram1Demo> createState() => _StateManagedDiagram1DemoState();
}

class _StateManagedDiagram1DemoState extends State<StateManagedDiagram1Demo> {
  late final StateManagedDiagram1 diagram;
  late final StateChangeHandler stateHandler;
  double get _sliderValue => diagram.value;
  String _lastStateChange = 'No changes yet';

  @override
  void initState() {
    super.initState();
    
    // Create diagram instance with custom coordinate system
    diagram = StateManagedDiagram1(
      config: DiagramConfigBuilder.createStandardConfig(
        // Size based on standalone mode
        width: widget.useStandalone ? 600 : 400,
        height: widget.useStandalone ? 400 : 300,
        
        // Original coordinate system
        xRangeMin: 0,
        xRangeMax: 10,
        yRangeMin: 0,
        yRangeMax: 10,
        origin: const Offset(0, 0),
        scale: 1.0,
        
        // Default visibility
        showGrid: true,   // Grid starts visible
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
    ).build(context);
  }

  @override
  Widget build(BuildContext context) {
    return DiagramWidgetBuilder(
      diagram: diagram,
      standalone: widget.useStandalone,
      title: widget.useStandalone ? 'State Managed Diagram Test' : null,
      width: widget.useStandalone ? null : diagram.canvasWidth,
      height: widget.useStandalone ? null : diagram.canvasHeight,
      controls: _buildControls(),
    ).build(context);
  }
}
