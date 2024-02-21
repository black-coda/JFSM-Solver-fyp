import 'package:flutter/material.dart';
import 'package:frontend/src/app/view/screens/dashboard_screen.dart';
import '../../app/view/screens/splash_screen.dart';

class RouteManager {
  static const String loginView = '/login';
  static const String dashboardView = '/dashboard';
  static const String createView = '/create';
  static const String updateView = '/create';
  static const String logoutView = '/logout';
  static const String splashScreen = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboardView:
        return MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        );
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      
      default:
        throw const FormatException();
    }
  }
}