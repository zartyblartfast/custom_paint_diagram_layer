import 'package:flutter/material.dart';
import 'state_managed_diagram3.dart';

/// Set to true to enable diagnostic output
const bool _DEBUG = false;

/// Initialize global diagnostic settings
void main() {
  diagnosticsEnabled = _DEBUG;
  runApp(const MaterialApp(
    home: StateManagedDiagram3Demo(),
  ));
}
