import 'package:frontend/src/module/linear_multistep_solver.dart';
import 'package:frontend/src/utils/extension/approximation.dart';

class SolverImplementation implements LinearMultistepSolver {
  @override
  List<double> explicitLinearMultistepMethod({
    required int stepNumber,
    required List<double> alpha,
    required List<double> beta,
    required double Function(double initialValueX, double initialValueY) func,
    required double y0,
    required double x0,
    required double stepSize,
    required int N,
  }) {
    // Initialize the result list with size N and filled with 0s
    List<double> result = List.filled(N, 0);

    switch (stepNumber) {
      case 1:
        // Single-step method
        for (int i = 0; i < N; i++) {
          // Calculate the approximate function value at the current point
          double evaluateApproximateFunction = func(x0, y0);
          // Calculate the next value of y
          double y =
              stepSize * (beta.elementAt(0) * evaluateApproximateFunction) -
                  (alpha.elementAt(0) * y0);
          // Store the calculated value in the result list
          result[i] = y;
          // Update x and y for the next iteration
          x0 += stepSize;
          y0 = y;
        }
        break;

      default:
        // Multi-step method using initial approximation from fourth-order Runge-Kutta
        List<double> yRKMethod =
            fourthOrderRungeKuttaMethod(func, y0, x0, stepSize, stepNumber);
        result[0] =
            yRKMethod[0].approximate(6); // Store the first value from RK method
        double y1 =
            result[0]; // Initialize y1 with the first value from RK method
        double x1 = x0 + stepSize; // Initialize x1 for the next point

        // Iterate starting from the second point
        for (int i = 1; i < N; i++) {
          // Calculate the approximate function value at the current point
          double evaluateApproximateFunction = func(x0.approximate(2), y0);

          // Calculate function values at the next step
          double fValuesOfRKResultF1 =
              func(x1.approximate(2), y1.approximate(6));

          // Calculate the new y value using explicit linear multistep method
          double y = stepSize *
                  ((beta.elementAt(0) *
                          evaluateApproximateFunction.approximate(6)) +
                      (beta.elementAt(1) *
                          fValuesOfRKResultF1.approximate(6))) -
              ((alpha.elementAt(1) * y1) + alpha.elementAt(0) * y0);

          // Store the calculated value in the result list
          result[i] = y.approximate(6);

          // Update x0, y0, and y1 for the next iteration
          x0 = x1.approximate(2);
          y0 = y1.approximate(6);
          y1 = y;

          // Update x1 for the next point
          x1 += stepSize;
        }
    }
    return result;
  }

  @override
  List<double> implicitLinearMultistepMethod() {
    // Implicit method implementation - to be added
    throw UnimplementedError();
  }

  List<double> fourthOrderRungeKuttaMethod(
    Function func,
    double y0,
    double x0,
    double stepSize,
    int N,
  ) {
    // Initialize variables
    double y = y0;
    double x = x0;
    List<double> result = List.filled(N - 1, 0);

    // Perform RK method
    for (int i = 0; i < N - 1; i++) {
      final k1 = func(x, y);
      final k2 = func(x + stepSize * 0.5, y + k1 * stepSize * 0.5);
      final k3 = func(x + stepSize * 0.5, y + k2 * stepSize * 0.5);
      final k4 = func(x + stepSize, y + k3 * stepSize);

      final calculateNextValueOfY =
          y + (stepSize / 6) * (k1 + 2 * k2 + 2 * k3 + k4);

      result[i] = calculateNextValueOfY.approximate(6);

      y = calculateNextValueOfY;
      x += stepSize;
    }

    return result;
  }
}
