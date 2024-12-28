import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/diagnostic_helper.dart';

/// Represents a change in visibility state
class VisibilityUpdate {
  final String key;
  final bool isVisible;
  final bool previousValue;

  const VisibilityUpdate(this.key, this.isVisible, this.previousValue);
  
  @override
  String toString() => 'VisibilityUpdate(key: $key, isVisible: $isVisible, previousValue: $previousValue)';
}

/// Callback type for state changes
typedef VisibilityChangeCallback = void Function(VisibilityUpdate update);

/// Manages state for diagram elements and controls
class DiagramStateManager extends ChangeNotifier with DiagnosticHelper {
  @override
  String get diagnosticSource => 'DiagramStateManager';

  @override
  DiagnosticCallback? get onDiagnostic => null;

  // Visibility state
  final Map<String, bool> _visibilityState = {};
  
  // Value state
  final Map<String, double> _valueState = {};
  
  // Callbacks for specific state changes
  final Map<String, List<VisibilityChangeCallback>> _stateCallbacks = {};
  
  // Global callbacks for any state change
  final List<VisibilityChangeCallback> _globalCallbacks = [];
  
  // Standard visibility keys
  static const String kGrid = 'grid';
  static const String kFrame = 'frame';
  static const String kAxes = 'axes';
  static const String kTheme = 'theme';

  // Theme colors
  static const _lightTheme = <String, Color>{
    'background': Colors.white,
    'element': Colors.black,
    'elementFill': Color(0x33448AFF),  // Light blue with opacity
    'grid': Color(0x8A000000),  // Colors.black54
    'gridMinor': Color(0x42000000),  // Colors.black26
  };

  static const _darkTheme = <String, Color>{
    'background': Color(0xFF1E1E1E),
    'element': Colors.white,
    'elementFill': Color(0x4DFFFFFF),  // Colors.white30
    'grid': Color(0x8AFFFFFF),  // Colors.white54
    'gridMinor': Color(0x42FFFFFF),  // Colors.white26
  };

  DiagramStateManager() {
    // Initialize standard visibility states
    _visibilityState[kGrid] = false;
    _visibilityState[kFrame] = true;
    _visibilityState[kAxes] = true;
    _valueState[kTheme] = 0;  // 0 = light theme, 1 = dark theme
  }

  /// Update visibility state
  void updateVisibility(String key, bool isVisible) {
    final oldValue = _visibilityState[key] ?? false;
    if (oldValue != isVisible) {
      _visibilityState[key] = isVisible;
      if (isDiagnosticsEnabled) {
        reportInfo('updateVisibility', 'Visibility updated: $key = $isVisible');
      }
      _notifyStateCallbacks(key, isVisible, oldValue);
      notifyListeners();
    }
  }

  /// Toggle visibility state
  void toggleVisibility(String key) {
    final currentValue = _visibilityState[key] ?? false;
    if (isDiagnosticsEnabled) {
      reportInfo('toggleVisibility', 'Visibility toggled: $key = ${!currentValue}');
    }
    updateVisibility(key, !currentValue);
  }

  /// Add a callback for a specific state change
  void addStateCallback(String key, VisibilityChangeCallback callback) {
    _stateCallbacks.putIfAbsent(key, () => []).add(callback);
  }

  /// Remove a callback for a specific state change
  void removeStateCallback(String key, VisibilityChangeCallback callback) {
    _stateCallbacks[key]?.remove(callback);
    if (_stateCallbacks[key]?.isEmpty ?? false) {
      _stateCallbacks.remove(key);
    }
  }

  /// Add a callback for any state change
  void addGlobalCallback(VisibilityChangeCallback callback) {
    _globalCallbacks.add(callback);
  }

  /// Remove a callback for any state change
  void removeGlobalCallback(VisibilityChangeCallback callback) {
    _globalCallbacks.remove(callback);
  }

  /// Notify callbacks of state change
  void _notifyStateCallbacks(String key, bool newValue, bool oldValue) {
    final update = VisibilityUpdate(key, newValue, oldValue);
    
    if (isDiagnosticsEnabled) {
      reportInfo('_notifyStateCallbacks', 'State changed: $update');
    }
    
    // Notify specific callbacks for this key
    _stateCallbacks[key]?.forEach((callback) => callback(update));
    
    // Notify global callbacks
    _globalCallbacks.forEach((callback) => callback(update));
  }

  /// Register a new visibility state
  void registerVisibility(String key, bool initialValue) {
    if (!_visibilityState.containsKey(key)) {
      _visibilityState[key] = initialValue;
      if (isDiagnosticsEnabled) {
        reportInfo('registerVisibility', 'Registered visibility state', {
          'key': key,
          'value': initialValue,
        });
      }
      _notifyStateCallbacks(key, initialValue, false);
      notifyListeners();
    }
  }

  /// Register a new value state
  void registerValue(String key, double initialValue) {
    if (!_valueState.containsKey(key)) {
      _valueState[key] = initialValue;
      if (isDiagnosticsEnabled) {
        reportInfo('registerValue', 'Registered value state', {
          'key': key,
          'value': initialValue,
        });
      }
      notifyListeners();
    }
  }

  /// Get a value from state
  double? getValue(String key) => _valueState[key];

  /// Update a value in state
  void updateValue(String key, double value) {
    if (_valueState[key] != value) {
      _valueState[key] = value;
      if (isDiagnosticsEnabled) {
        reportInfo('updateValue', 'Updated value state', {
          'key': key,
          'value': value,
        });
      }
      notifyListeners();
    }
  }

  /// Get visibility state
  bool isVisible(String key) => _visibilityState[key] ?? false;

  /// Get all visibility states
  Map<String, bool> get visibilityStates => Map.unmodifiable(_visibilityState);

  /// Standard getters for common states
  bool get showGrid => isVisible(kGrid);
  bool get showFrame => isVisible(kFrame);
  bool get showAxes => isVisible(kAxes);

  /// Get whether dark theme is enabled
  bool get isDarkTheme => getValue(kTheme) == 1;

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (isDiagnosticsEnabled) {
      reportInfo('toggleTheme', 'Theme toggled: ${!isDarkTheme}');
    }
    updateValue(kTheme, isDarkTheme ? 0 : 1);
  }

  /// Get current theme colors based on theme state
  Map<String, Color> get themeColors => getValue(kTheme) == 1 ? _darkTheme : _lightTheme;

  @override
  void dispose() {
    _stateCallbacks.clear();
    _globalCallbacks.clear();
    super.dispose();
  }
}
