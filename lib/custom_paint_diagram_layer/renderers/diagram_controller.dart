import 'package:flutter/material.dart';

/// Controller for managing diagram state and external control bindings
class DiagramController {
  /// Callback when values change
  final Function(Map<String, dynamic>)? onValuesChanged;
  
  /// Current values for diagram properties
  final Map<String, dynamic> _values = {};
  
  DiagramController({
    this.onValuesChanged,
    Map<String, dynamic>? initialValues,
  }) {
    if (initialValues != null) {
      _values.addAll(initialValues);
    }
  }

  /// Check if a value exists
  bool hasValue(String key) => _values.containsKey(key);

  /// Update a single value
  void setValue(String key, dynamic value) {
    _values[key] = value;
    onValuesChanged?.call(_values);
  }

  /// Update multiple values at once
  void setValues(Map<String, dynamic> newValues) {
    _values.addAll(newValues);
    onValuesChanged?.call(_values);
  }

  /// Get current value
  T? getValue<T>(String key) {
    return _values[key] as T?;
  }

  /// Expose a control point for external binding
  void exposeControl(String key, {dynamic defaultValue}) {
    if (!_values.containsKey(key)) {
      _values[key] = defaultValue;
    }
  }
}

/// Mixin to add controller support to diagram renderers
mixin DiagramControllerMixin {
  /// The diagram's controller
  late final DiagramController controller;

  /// Initialize controller with named control points
  void initializeController({
    Map<String, dynamic>? defaultValues,
    Function(Map<String, dynamic>)? onValuesChanged,
  }) {
    controller = DiagramController(onValuesChanged: onValuesChanged);
    if (defaultValues != null) {
      controller.setValues(defaultValues);
    }
  }

  /// Update diagram from controller values
  void updateFromController();
}
