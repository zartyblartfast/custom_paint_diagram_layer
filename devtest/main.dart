import 'package:flutter/material.dart';
import 'demos/engineering_coords_test.dart';
import 'demos/spring_balance_demo.dart';
import 'demos/butterfly_art.dart';
import 'demos/color_harmony_art.dart';
import 'demos/kaleidoscope_art.dart';
import 'demos/signal_waveform_art.dart';
import 'demos/harmony_wave_art.dart';
import 'demos/fuml_process_flow.dart';
import 'demos/rounded_rect_test.dart';
import 'demos/process_flow_diagram.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Paint Diagram Layer Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
            home: const DemoList(),
    );
  }
}

class DemoList extends StatelessWidget {
  const DemoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Custom Paint Diagram Layer Demo'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Process Flow Diagram'),
            subtitle: const Text('fUML-compliant process flow diagram'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProcessFlowDiagram()),
              );
            },
          ),
          ListTile(
            title: const Text('Engineering Coordinates Test'),
            subtitle: const Text('Basic coordinate system test'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EngineeringCoordsTest()),
              );
            },
          ),
          ListTile(
            title: const Text('Spring Balance Demo'),
            subtitle: const Text('Interactive physics demo'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpringBalanceDiagram()),
              );
            },
          ),
          ListTile(
            title: const Text('Butterfly Art Demo'),
            subtitle: const Text('Artistic butterfly composition'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ButterflyArt()),
              );
            },
          ),
          ListTile(
            title: const Text('Color Harmony Art'),
            subtitle: const Text('Abstract art with harmonious colors'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ColorHarmonyArt()),
            ),
          ),
          ListTile(
            title: const Text('Kaleidoscope Art'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KaleidoscopeArt()),
            ),
          ),
          ListTile(
            title: const Text('Signal Waveform Demo'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignalWaveformArt()),
            ),
          ),
          ListTile(
            title: const Text('Musical Harmony Visualization'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HarmonyWaveArt()),
            ),
          ),
        ],
      ),
    );
  }
}
