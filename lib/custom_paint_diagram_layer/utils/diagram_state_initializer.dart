import 'package:flutter/foundation.dart';
import '../state/diagram_state_manager.dart';
import '../state/state_managed_diagram_base.dart';
import 'diagnostic_helper.dart';

/// A utility class to handle state initialization in a structured way
/// with built-in validation and diagnostics.
class DiagramStateInitializer with DiagnosticHelper {
  @override
  String get diagnosticSource => 'DiagramStateInitializer';

  @override
  final DiagnosticCallback? onDiagnostic;

  final StateManagedDiagramBase diagram;
  final Map<String, double> initialValues;
  final ValueChanged<String>? onStateChange;
  final bool validateRanges;
  final Map<String, (double, double)>? validRanges;

  /// Creates a state initializer with validation and diagnostics
  /// 
  /// Parameters:
  /// - [diagram]: The diagram to initialize state for
  /// - [initialValues]: Map of initial values for state keys
  /// - [onStateChange]: Optional callback for state changes
  /// - [onDiagnostic]: Optional callback for diagnostic information
  /// - [validateRanges]: Whether to validate value ranges
  /// - [validRanges]: Optional map of valid ranges for values (min, max)
  DiagramStateInitializer({
    required this.diagram,
    required this.initialValues,
    this.onStateChange,
    this.onDiagnostic,
    this.validateRanges = true,
    this.validRanges,
  }) {
    reportInfo('constructor', 'Initializing state manager', {
      'initialValues': initialValues,
      'validateRanges': validateRanges,
      'validRanges': validRanges?.toString(),
    });
    _initializeState();
  }

  /// Initialize all state values with validation
  void _initializeState() {
    // Check for duplicate keys
    _checkForDuplicateKeys();

    // Validate and register initial values
    for (final entry in initialValues.entries) {
      _validateAndRegisterValue(entry.key, entry.value);
    }

    // Setup state change handling
    if (onStateChange != null) {
      _setupStateChangeHandling();
    }
  }

  void _checkForDuplicateKeys() {
    final standardKeys = {
      DiagramStateManager.kGrid,
      DiagramStateManager.kFrame,
      DiagramStateManager.kAxes,
    };

    for (final key in initialValues.keys) {
      if (standardKeys.contains(key)) {
        reportWarning('_checkForDuplicateKeys', 
          'Key conflicts with standard diagram key: $key');
      }
    }
  }

  void _validateAndRegisterValue(String key, double value) {
    // Validate range if needed
    if (validateRanges) {
      final range = validRanges?[key];
      if (range != null) {
        final (min, max) = range;
        if (value < min || value > max) {
          reportError('_validateAndRegisterValue',
            'Value $value is outside valid range [$min, $max] for key: $key');
          // Use clamped value
          value = value.clamp(min, max);
        }
      }
    }

    try {
      // Register the value
      diagram.state.registerValue(key, value);
      reportInfo('_validateAndRegisterValue',
        'Successfully registered value for key: $key',
        {'value': value});
    } catch (e) {
      reportError('_validateAndRegisterValue',
        'Failed to register value for key: $key',
        {'error': e.toString(), 'value': value});
    }
  }

  void _setupStateChangeHandling() {
    diagram.state.addGlobalCallback((update) {
      onStateChange?.call(update.toString());
      
      // Validate new value if needed
      if (validateRanges) {
        final range = validRanges?[update.key];
        if (range != null) {
          reportInfo('_setupStateChangeHandling',
            'State change occurred for key: ${update.key}',
            {'update': update.toString()});
        }
      }
    });

    reportInfo('_setupStateChangeHandling',
      'Setup state change handling');
  }

  /// Creates a standard initializer with common settings
  static DiagramStateInitializer createStandard({
    required StateManagedDiagramBase diagram,
    required Map<String, double> initialValues,
    ValueChanged<String>? onStateChange,
    DiagnosticCallback? onDiagnostic,
  }) {
    return DiagramStateInitializer(
      diagram: diagram,
      initialValues: initialValues,
      onStateChange: onStateChange,
      onDiagnostic: onDiagnostic,
      validateRanges: true,
      validRanges: {
        'value': (0.0, 1.0),  // Standard slider range
      },
    );
  }
}
