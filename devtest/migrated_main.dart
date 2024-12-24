import 'package:flutter/material.dart';
import 'demos/migrated_butterfly_art.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Migrated Diagram Demos',
    debugShowCheckedModeBanner: false,
    home: DemoSelector(),
  ));
}

class DemoSelector extends StatelessWidget {
  const DemoSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrated Diagram Demos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ButterflyArtDemo(
                      useStandalone: true,
                    ),
                  ),
                );
              },
              child: const Text('Butterfly Art (Standalone)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Butterfly Art (Embedded)'),
                      ),
                      body: const Center(
                        child: ButterflyArtDemo(
                          useStandalone: false,
                          showControls: true,  // Enable slider control
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Butterfly Art (Embedded)'),
            ),
          ],
        ),
      ),
    );
  }
}
