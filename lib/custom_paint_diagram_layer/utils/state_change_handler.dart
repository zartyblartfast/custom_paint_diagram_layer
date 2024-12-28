import 'package:flutter/material.dart';
import '../state/diagram_state_manager.dart';
import '../core_diagram_base.dart';

/// A utility class to handle state change callbacks
class StateChangeHandler {
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

  /// Creates a standard set of callbacks
  static StateChangeHandler createStandard({
    required DiagramStateManager state,
    required ValueChanged<String> onStateChange,
  }) {
    return StateChangeHandler(
      state: state,
      onStateChange: onStateChange,
      specificCallbacks: {
        DiagramStateManager.kAxes: (update) {
          print('Axes visibility changed: ${update.isVisible}');
        },
        DiagramStateManager.kGrid: (update) {
          print('Grid visibility changed: ${update.isVisible}');
        },
        DiagramStateManager.kFrame: (update) {
          print('Frame visibility changed: ${update.isVisible}');
        },
      },
    );
  }
}
