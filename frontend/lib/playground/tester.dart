import 'package:frontend/src/module/linear_multistep_solver.dart';
import 'package:frontend/src/utils/extension/approximation.dart';

class Playground implements LinearMultistepSolver {
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
    //* Contains the final result of y calculated

    //* Initialize the result list with size N and filled with 0s
    List<double> result = List.filled(N, 0, growable: true);
    print("1=> $result");

    //* add the initial value y (y0) to the result list
    result[0] = y0;
    print("2 => $result");

    //* Compute initial values using the fourth-order Runge-Kutta method
    List<double> initialValuesFromRKMethod =
        fourthOrderRungeKuttaMethod(func, y0, x0, stepSize, stepNumber);

    print("3 => $initialValuesFromRKMethod");

    //* approximate the result from RK method to 6dp
    List<double> approximatedYFromRK =
        initialValuesFromRKMethod.map((e) => e.approximate(6)).toList();

    print("4 => $approximatedYFromRK");

    //* add approximated to 6dp values from r-k method to result list in a right order
    result.replaceRange(1, stepNumber - 1, approximatedYFromRK);

    print("5 => $result");

    //* get the non-zero value of Y from the result list
    List<double> y = result.sublist(0, stepNumber);

    print("6 => $y");

    //* generates values of x based on the step number and initial value x0
    List<double> x = generateXValues(x0, stepSize, stepNumber)
        .map((e) => e.approximate(2))
        .toList();

    print("7 => $x");

    //* f values from f1 => f(stepNumber - 1)
    List<double> fValues = [];

    print("8 => $fValues");

    //* initial values of alpha and beta
    double betaF = 0;
    double alphaY = 0;

    //* summation using the general lmm formulae
    for (var i = stepNumber; i <= N; i++) {
      /// * calculate the values of f0,f1 ... f(stepNumber -1), then add it to the [fValues]
      for (var j = 0; j < stepNumber; j++) {
        double xj = x[j];
        double yj = y[j];

        fValues.add(func(xj, yj));
      }

      //* Approximate fValues to 6dp
      fValues = fValues.map((e) => e.approximate(6)).toList();
      print("9 => $fValues");
      //! Using the formula

      //* calculate summation beta * fi
      for (var k = 0; k < stepNumber; k++) {
        betaF += beta[k] * fValues[k];
      }

      print("beta F: ${betaF.approximate(6)}");

      //* calculate summation alpha*y
      for (var l = 0; l < stepNumber; l++) {
        alphaY += alpha[l] * y[l];
      }

      print("alpha y: ${alphaY.approximate(6)}");

      //? Calculate the new y => h[beta*f] - alpha*y
      double nextValueOfY =
          (stepSize * betaF.approximate(6)) - alphaY.approximate(6);

      print("10 => ${nextValueOfY.approximate(6)}");

      //? add the next value of y calculated to the list of y
      y.add(nextValueOfY.approximate(6));

      print("11 ==> $y");

      //? add the next value of y calculated to the result list
      result[i] = nextValueOfY.approximate(6);

      print("12 ==> $result");

      //? updating values

      //* update values of x
      for (var m = 0; m < x.length; m++) {
        x[m] += stepSize;
      }

      //* approximate the values of x to 1dp
      x = x.map((e) => e.approximate(1)).toList();

      print("13 ==> $x");

      //* Update values of y by removing the first value in the list
      y.removeAt(0);

      print("14 ==> $y");

      //* reset the values of betaF and alpha Y to 0
      betaF = 0;
      alphaY = 0;

      //* reset the fValues to an empty list
      fValues = [];
    }

    return result;
  }

  @override
  List<double> implicitLinearMultistepMethod() {
    // Implicit method implementation - to be added
    throw UnimplementedError();
  }

  List<double> generateXValues(double x0, double stepSize, int stepNumber,
      {int decimalPlaces = 1}) {
    String firstValueOfX = x0.toString();
    List<String> xValues = [];
    xValues.add(firstValueOfX);
    for (int n = 1; n <= stepNumber - 1; n++) {
      double x = x0 + n * stepSize;
      xValues.add(x.toStringAsFixed(decimalPlaces));
    }
    return xValues.map((e) => double.parse(e)).toList();
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
