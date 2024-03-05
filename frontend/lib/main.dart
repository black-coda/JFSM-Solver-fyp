import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/utils/routes/route_manager.dart';

void main() {
  runApp(
    const ProviderScope(child: MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theming(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteManager.generateRoute,
      initialRoute: RouteManager.splashScreen,
    );
  }

  ThemeData _theming() {
    return ThemeData(
      fontFamily: "Anta",
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff0fa968),
      ),
    );
  }
}
