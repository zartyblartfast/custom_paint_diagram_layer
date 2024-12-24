import 'package:flutter/material.dart';
import 'demos/migrated_butterfly_art.dart';

void main() {
  runApp(MaterialApp(
    title: 'Standalone Butterfly Demo',
    debugShowCheckedModeBanner: false,
    home: ButterflyArtDemo(
      useStandalone: true,
    ),
  ));
}
