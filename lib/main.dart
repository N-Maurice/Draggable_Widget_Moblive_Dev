import 'package:flutter/material.dart';
import 'unlock_screen.dart';

/// Entry point of the app.
///
/// This small project demonstrates Flutter's drag-and-drop APIs
/// ([Draggable] + [DragTarget]) across two screens:
///
///  1. [UnlockScreen] – a slide-to-unlock interaction where dragging
///     is constrained to a single axis.
///  2. [SecondScreen] – a free drag-and-drop interaction where a card
///     can be moved anywhere and dropped onto a target zone.
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
