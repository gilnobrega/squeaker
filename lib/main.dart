import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const SqueakerApp());
}

class SqueakerApp extends StatelessWidget {
  const SqueakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'squeaker',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WatchShape(
        builder: (BuildContext context, WearShape shape, Widget? child) {
          return AmbientMode(
            builder: (context, mode, child) {
              return const Center(
                child: Text(
                  'squeaker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
