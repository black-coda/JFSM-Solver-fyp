import 'dart:math' as math;

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
  List<double> alpha = [0, -1, 1];
  final beta = <double>[-0.5, 1.5, 0];

  final solver = SolverImplementation();
  final t = solver.explicitLinearMultistepMethod(
    stepNumber: 2,
    alpha: alpha,
    beta: beta,
    func: func,
    y0: y0,
    x0: x0,
    stepSize: stepSize,
    N: N,
  );

  print(t);
}
