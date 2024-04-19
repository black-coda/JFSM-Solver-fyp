import 'dart:math' as math;

import 'package:frontend/playground/tester.dart';
import 'package:frontend/src/app/view_models/linear_multistep_solver.dart';
import 'package:frontend/src/utils/extension/approximation.dart';

void main() {
  // Define the function to be used
  func(double x, double y) {
    // Example function: dy/dx = x^2 + y^2
    return 3 * math.pow(x, 2) * y;
  }

  double y0 = 1;
  double x0 = 0;
  double stepSize = 0.1;
  int N = 5;

  // Define the alpha and beta values
  // final List<double> alpha = [0, 0, -1, 1];
  // final List<double> beta = <double>[5 / 12, -16 / 12, 23 / 12, 0];
  // final b = [1,2];
  // List anew = List.filled(5, 0, growable: true);

  final List<double> alpha = [0, 0, 0, -1, 1];
  final List<double> beta = [
    -19 / 720,
    106 / 720,
    -264 / 720,
    646 / 720,
    251 / 720,
  ];

  final solverTester = Playground();
  // final t = solver.explicitLinearMultistepMethod(
  //   stepNumber: 3,
  //   alpha: alpha,
  //   beta: beta,
  //   func: func,
  //   y0: y0,
  //   x0: x0,
  //   stepSize: stepSize,
  //   N: N,
  // );

  // final ans = solverTester.explicitLinearMultistepMethod(
  //   stepNumber: 3,
  //   alpha: alpha,
  //   beta: beta,
  //   func: func,
  //   y0: y0,
  //   x0: x0,
  //   stepSize: stepSize,
  //   N: N,
  // );

  // print(ans);

  final ans = solverTester.implicitLinearMultistepMethod(
    stepNumber: 4,
    alpha: alpha,
    beta: beta,
    func: func,
    y0: y0,
    x0: x0,
    stepSize: stepSize,
    N: N,
  );

  print(ans);

  final rk =
      solverTester.fourthOrderRungeKuttaMethod(func, y0, x0, stepSize, N);

  // print(rk);

  final th = solverTester.generateXValues(x0, stepSize, 4);
  // print(th);

  // print("implicit RK: $implicitRK");
}
