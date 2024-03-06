import 'package:frontend/src/module/linear_multistep_solver.dart';
import 'package:frontend/src/utils/extension/approximation.dart';

class SolverImplementation implements LinearMultistepSolver {
  @override
  List<double> explicitLinearMultistepMethod(
    int stepNumber,
    List<double> alpha,
    List<double> beta,
    double Function(double initialValueX, double initialValueY) func,
    double y0,
    double x0,
    double stepSize,
    int N,
  ) {
    List<double> result = List.filled(N, 0);
    switch (stepNumber) {
      case 1:
        for (int i = 0; i < N; i++) {
          double evaluateApproximateFunction = func(x0, y0);
          double y =
              stepSize * (beta.elementAt(0) * evaluateApproximateFunction) -
                  (alpha.elementAt(0) * y0);
          result[i] = y.approximate(6);
          x0 += stepSize;
          y0 = y;
        }

      default:
      // TODO: Implement the rest of the cases, Continue from here
        print("here😪😪");
        double evaluateApproximateFunction = func(x0, y0);
        List<double> yRKMethod =
            fourthOrderRungeKuttaMethod(func, y0, x0, stepSize, stepNumber);
        print("RK method: $yRKMethod");
        final double x1 = x0 + stepSize;
        final double fValuesOfRKResultF1 = func(x1, yRKMethod[0]);

        for (int i = 0; i < N; i++) {
          double y = stepSize *
                  ((beta.elementAt(0) * evaluateApproximateFunction) +
                      (beta.elementAt(1) * fValuesOfRKResultF1)) -
              ((alpha.elementAt(1) * yRKMethod.elementAt(0)) +
                  alpha.elementAt(0) * y0);

          result[i] = y.approximate(6);
          x0 += stepSize;
          y0 = y;
        }
    }
    return result;
  }

  @override
  List<double> implicitLinearMultistepMethod() {
    // TODO: implement implicitLinearMultistepMethod
    throw UnimplementedError();
  }

  List<double> fourthOrderRungeKuttaMethod(
    Function func,
    double y0,
    double x0,
    double stepSize,
    int N,
  ) {
    double y = y0;
    double x = x0;
    List<double> result =
        List.filled(N - 1, 0); // Preallocate list size for performance

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
