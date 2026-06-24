import 'package:flutter/material.dart';
import 'unlock_screen.dart';

/// Entry point of the app.

void main() {
  runApp(const DragDemoApp());
}

class DragDemoApp extends StatelessWidget {
  const DragDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F7CFF),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const UnlockScreen(),
    );
  }
}
