import 'package:flutter/material.dart';
import 'demos/engineering_coords_test.dart';
import 'demos/spring_balance_demo.dart';

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
        title: const Text('Diagram Layer Demos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Engineering Coordinates Demo'),
            subtitle: const Text('Demonstrates element positioning with engineering-style coordinates'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EngineeringCoordsTest()),
              );
            },
          ),
          ListTile(
            title: const Text('Spring Balance Demo'),
            subtitle: const Text('Interactive spring balance with adjustable length'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpringBalanceDiagram()),
              );
            },
          ),
        ],
      ),
    );
  }
}
