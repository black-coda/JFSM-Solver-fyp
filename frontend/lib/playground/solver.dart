import 'dart:math' as math;

// import 'package:frontend/playground/tester.dart';
import 'package:frontend/playground/tester.dart';
import 'package:frontend/src/app/view_models/linear_multistep_solver.dart';
// import 'package:frontend/src/utils/extension/approximation.dart';

void main() {
  // Define the function to be used
  func(double x, double y) {
    // Example function: dy/dx = x^2 + y^2
    // return math.pow(x, 2) * (1 + y);
    return x + y;
    // return 3 * math.pow(x, 2) * y;
  }

  double y0 = 0;
  double x0 = 0;
  double stepSize = 0.2;
  int N = 10;
  int predictorStepNumber = 4;
  int correctorStepNumber = 3;

  // Define the alpha and beta values
  final List<double> predictorAlpha = [0, 0, 0, -1, 1];
  final List<double> predictorBeta = <double>[
    -9 / 24,
    37 / 24,
    -59 / 24,
    55 / 24,
    0,
  ];

  // Define the alpha and beta values
  // final List<double> alphaCorrector = [0, 0, 0, -1, 1];
  // final List<double> betaCorrector = <double>[
  //   -9 / 24,
  //   37 / 24,
  //   -59 / 24,
  //   55 / 24,
  //   0,
  // ];

  // final b = [1,2];
  // List anew = List.filled(5, 0, growable: true);

  final List<double> correctorAlpha = [
    0,
    0,
    -1,
    1,
  ];
  final List<double> correctorBeta = [
    1 / 24,
    -5 / 24,
    19 / 24,
    9 / 24,
  ];

  final solverTester = SolverImplementation();
  // final p = Playground();
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
  //   stepNumber: 4,
  //   alpha: alpha,
  //   beta: beta,
  //   func: func,
  //   y0: y0,
  //   x0: x0,
  //   stepSize: stepSize,
  //   N: 4,
  // );

  // print(ans);

  final answer =
      solverTester.implicitLinearMultistepMethodWithPredictorCorrectorMethod(
    predictorStepNumber: predictorStepNumber,
    correctorStepNumber: correctorStepNumber,
    correctorAlpha: correctorAlpha,
    correctorBeta: correctorBeta,
    predictorAlpha: predictorAlpha,
    predictorBeta: predictorBeta,
    func: func,
    y0: y0,
    x0: x0,
    stepSize: stepSize,
    N: N,
  );

  print(answer);

  // final alpha = <double>[
  //   0,
  //   0,
  //   -1,
  //   1,
  // ];
  // final beta = <double>[
  //   5 / 12,
  //   -16 / 12,
  //   23 / 12,
  //   0,   
  // ];

  // final ans = p.implicitLinearMultistepMethodWithRKMethod(
  //   stepNumber: 3,
  //   alpha: alpha,
  //   beta: correctorBeta,
  //   func: func,
  //   y0: 1,
  //   x0: 0,
  //   stepSize: 0.1,
  //   N: N,
  // );

  // print(ans);

  // final rk =
  // solverTester.fourthOrderRungeKuttaMethod(func, y0, x0, stepSize, N);

  // print(rk);

  // final th = solverTester.generateXValues(x0, stepSize, 4);
  // print(th);

  // print("implicit RK: $implicitRK");
}
