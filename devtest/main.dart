import 'package:flutter/material.dart';
import 'demos/engineering_coords_test.dart';
import 'demos/spring_balance_demo.dart';
import 'demos/butterfly_art.dart';
import 'demos/color_harmony_art.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diagram Layer Demos',
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
        title: const Text('Diagram Layer Demos'),
      ),
      body: ListView(
        children: [
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ColorHarmonyArt()),
              );
            },
          ),
        ],
      ),
    );
  }
}
