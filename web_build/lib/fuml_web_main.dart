import 'package:flutter/material.dart';
import '../../devtest/demos/migrated_fuml_process_flow.dart';

void main() {
  runApp(const MaterialApp(
    home: Center(
      child: FUMLProcessFlowDemo(useStandalone: false),
    ),
  ));
}
