import 'package:flutter/material.dart';
import 'package:frontend/src/app/view/screens/dashboard.dart';
import 'package:frontend/src/app/view/screens/solver/solver_parameter_screen_collector.dart';
import '../../app/view/screens/splash_screen.dart';

class RouteManager {
  static const String loginView = '/login';
  static const String dashboardView = '/dashboard';
  static const String solverView = '/solver';
  static const String updateView = '/create';
  static const String logoutView = '/logout';
  static const String splashScreen = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboardView:
        return MaterialPageRoute(
          builder: (context) => const DashboardView(),
        );
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case solverView:
        return MaterialPageRoute(
          builder: (context) => const SolverView(),
        );

      default:
        throw const FormatException();
    }
  }
}
