// ignore_for_file: avoid_print

import 'package:frontend/src/module/linear_multistep_solver.dart';
import 'package:frontend/src/utils/extension/approximation.dart';

class Playground implements LinearMultistepSolver {
  // final Ref ref;

  // Playground({required this.ref});

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
        fourthOrderRungeKuttaMethod(func, y0, x0, stepSize, stepNumber, 1);

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
    List<double> x = generateXValues(x0, stepSize, stepNumber, implicit: 1)
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
  List<double> implicitLinearMultistepMethodWithRKMethod({
    required int stepNumber,
    required List<double> alpha,
    required List<double> beta,
    required double Function(double initialValueX, double initialValueY) func,
    required double y0,
    required double x0,
    required double stepSize,
    required int N,
  }) {
    List<double> result = List.filled(N, 0, growable: true);
    print("1 ==> $result");
    result[0] = y0;

    List<double> starterValuesFromRKMethod =
        fourthOrderRungeKuttaMethod(func, y0, x0, stepSize, N - 1);

    print("2 => $starterValuesFromRKMethod");

    List<double> approximatedYFromRK =
        starterValuesFromRKMethod.map((e) => e.approximate(6)).toList();

    // double futureY = approximatedYFromRK.last;

    // print("future Y: ")

    // approximatedYFromRK.removeLast();

    print("3 ==> $approximatedYFromRK");

    result.replaceRange(1, stepNumber, approximatedYFromRK);

    print("4 ==: $result");

    //* y value

    List<double> y = result.sublist(0, stepNumber + 1);

    print("5 ==: $y");

    //* x value
    List<double> x =
        generateXValues(x0, stepSize, stepNumber, decimalPlaces: 2);
    print("6 ==: $x");

    List<double> fValues = [];

    print("7 => $fValues");

    //* initial values of alpha and beta
    double betaF = 0;
    double alphaY = 0;

    ///* [Summation]

    for (var i = stepNumber; i <= N; i++) {
      /// * calculate the values of f0,f1 ... f(stepNumber), then add it to the [fValues]
      for (var j = 0; j <= stepNumber; j++) {
        double xj = x[j];
        double yj = y[j];

        fValues.add(func(xj, yj));
      }

      //* Approximate fValues to 6dp
      fValues = fValues.map((e) => e.approximate(6)).toList();

      print("8 => $fValues");

      //* calculate summation beta * fi
      for (var k = 0; k <= stepNumber; k++) {
        betaF += beta[k] * fValues[k];
      }

      print("beta F: ${betaF.approximate(6)}");

      //* calculate summation alpha*y
      for (var l = 0; l <= stepNumber - 1; l++) {
        alphaY += alpha[l] * y[l];
      }

      print("alpha y: ${alphaY.approximate(6)}");

      //? Calculate the new y => h[beta*f] - alpha*y
      double nextValueOfY =
          (stepSize * betaF.approximate(6)) - alphaY.approximate(6);

      print("9 🚀 => $nextValueOfY");

      print("⚡ $y");
      print("Step 🤦");
      //? add the next value of y calculated to the list of y
      y.add(nextValueOfY.approximate(6));

      print("10 ==> $y");
      y.removeAt(4);
      y.removeAt(0);
      print("11 ==> $y");

      print("$x");
      double yFromPredictor =
          fourthOrderRungeKuttaMethod(func, nextValueOfY, x[i], stepSize, 1)
              .first
              .approximate(6);
      y.add(yFromPredictor);

      print("🪲:::  $y");

      //? add the corrector value to the result list
      result[i] = nextValueOfY.approximate(6);

      print("12 ==> $result");

      //? updating values
      //* reset the values of betaF and alpha Y to 0
      betaF = 0;
      alphaY = 0;

      //* reset the fValues to an empty list
      fValues = [];

      //* update values of x
      for (var m = 0; m < x.length; m++) {
        x[m] += stepSize;
      }
      x = x.map((e) => e.approximate(2)).toList();
      print("🤡 $x");
    }

    return result;
  }

  List<double> generateXValues(double x0, double stepSize, int N,
      {int decimalPlaces = 1, int implicit = 0}) {
    String firstValueOfX = x0.toString();
    List<String> xValues = [];
    xValues.add(firstValueOfX);
    for (int n = 1; n <= N + 1; n++) {
      double x = x0 + n * stepSize;
      xValues.add(x.toStringAsFixed(decimalPlaces));
    }
    return xValues.map((e) => double.parse(e)).toList();
  }

  List<double> fourthOrderRungeKuttaMethod(
      Function func, double y0, double x0, double stepSize, int N,
      [int implicit = 0]) {
    // Initialize variables
    double y = y0;
    double x = x0;

    List<double> result = List.filled(N - implicit, 0);

    // Perform RK method
    for (int i = 0; i < N - implicit; i++) {
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
  
  @override
  List<double> implicitLinearMultistepMethodWithPredictorCorrectorMethod({required int stepNumber, required List<double> correctorAlpha, required List<double> correctorBeta, required List<double> predictorAlpha, required List<double> predictorBeta, required double Function(double initialValueX, double initialValueY) func, required double y0, required double x0, required double stepSize, required int N}) {
    // TODO: implement implicitLinearMultistepMethodWithPredictorCorrectorMethod
    throw UnimplementedError();
  }
}
