import 'package:flutter/material.dart';
import 'demos/migrated_butterfly_art.dart';

void main() {
  runApp(MaterialApp(
    title: 'Embedded Butterfly Demo',
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: Text('Butterfly Art (Embedded)'),
      ),
      body: Center(
        child: ButterflyArtDemo(
          useStandalone: false,
          showControls: true,
        ),
      ),
    ),
  ));
}
