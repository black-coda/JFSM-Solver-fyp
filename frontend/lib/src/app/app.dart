import 'package:flutter/material.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text(
          'Welcome to my app!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
