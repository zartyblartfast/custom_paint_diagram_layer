import 'package:flutter/material.dart';
import '../state/diagram_state_manager.dart';
import '../core_diagram_base.dart';
import '../utils/diagnostic_helper.dart';

/// A utility class to handle state change callbacks
class StateChangeHandler with DiagnosticHelper {
  @override
  String get diagnosticSource => 'StateChangeHandler';

  @override
  DiagnosticCallback? get onDiagnostic => null;

  final DiagramStateManager state;
  final ValueChanged<String>? onStateChange;
  final Map<String, Function(VisibilityUpdate)>? specificCallbacks;

  StateChangeHandler({
    required this.state,
    this.onStateChange,
    this.specificCallbacks,
  }) {
    _setupCallbacks();
  }

  void _setupCallbacks() {
    // Add global callback
    if (onStateChange != null) {
      state.addGlobalCallback((update) {
        onStateChange!('Changed ${update.key} from ${update.previousValue} to ${update.isVisible}');
      });
    }

    // Add specific callbacks
    specificCallbacks?.forEach((key, callback) {
      state.addStateCallback(key, callback);
    });
  }

  /// Disposes of all callbacks
  void dispose() {
    // Specific callbacks will be cleaned up when state is disposed
  }

  /// Handle a visibility update with diagnostic logging
  void _handleVisibilityUpdate(String key, VisibilityUpdate update) {
    reportInfo('onStateChange', '$key visibility changed: ${update.isVisible}');
  }

  /// Creates a standard set of callbacks
  static StateChangeHandler createStandard({
    required DiagramStateManager state,
    required ValueChanged<String> onStateChange,
  }) {
    return StateChangeHandler(
      state: state,
      onStateChange: onStateChange,
      specificCallbacks: {
        DiagramStateManager.kAxes: (update) => state.reportInfo(
          'onStateChange',
          'Axes visibility changed: ${update.isVisible}',
        ),
        DiagramStateManager.kGrid: (update) => state.reportInfo(
          'onStateChange',
          'Grid visibility changed: ${update.isVisible}',
        ),
        DiagramStateManager.kFrame: (update) => state.reportInfo(
          'onStateChange',
          'Frame visibility changed: ${update.isVisible}',
        ),
      },
    );
  }
}
