import 'package:flutter/material.dart';
import './web_engineering_coords.dart';

void main() {
  print('Starting Flutter web app...');
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: WebEngineeringCoords(),
      ),
    ),
  ));
}