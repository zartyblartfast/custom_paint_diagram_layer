import 'package:flutter/material.dart';
import 'migrated_fuml_process_flow.dart';

void main() {
  // Test standalone mode
  runApp(const MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FUMLProcessFlowDemo(useStandalone: true),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Standalone Mode'),
          ),
        ],
      ),
    ),
  ));
}
