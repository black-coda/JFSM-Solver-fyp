// ignore_for_file: avoid_print

import 'dart:math';

import 'package:frontend/src/utils/extension/approximation.dart';
import 'package:frontend/src/utils/extension/factorial.dart';

bool checkConsistency(List<double> a, List<double> b) {
  double sumA = a.reduce((value, element) => value + element);
  double sumB = b.reduce((value, element) => value + element);
  return sumA == 0 && sumB == 0;
}

int checkOrder(List<double> a, int maxOrder) {
  for (int p = 0; p < maxOrder; p++) {
    double sum = a
        .asMap()
        .entries
        .map((e) => e.key * e.value)
        .reduce((value, element) => value + element);
    if (sum != 0) {
      return p;
    }
  }
  return maxOrder;
}

bool isConsistent(List<double> parameters, int kSteps) {
  double sumOfAlphaMultipliedByIndex = 0;

  if (parameters.length != 2 * kSteps + 2) {
    throw ArgumentError(
        'Expected ${2 * kSteps + 2} parameters, got ${parameters.length}');
  }
  final Iterable<double> alphas = parameters.take(kSteps + 1);
  print("Alphas: $alphas");
  final double c0 = alphas.reduce((value, element) => value + element);
  print("c0: $c0");
  final Iterable<double> beta = parameters.skip(kSteps + 1);
  print("Beta: $beta");
  final double sumOfBeta = beta.reduce((value, element) => value + element);

  for (var i = 0; i < alphas.length; i++) {
    sumOfAlphaMultipliedByIndex += i * alphas.elementAt(i);
  }

  print("sumOfAlphaMultipliedByIndex: $sumOfAlphaMultipliedByIndex");

  final c1 = sumOfAlphaMultipliedByIndex - sumOfBeta;
  print("c1: $c1");
  if (c0 == 0 && c1 == 0) {
    return true;
  }
  return false;
}

int orderOfLmm(List<double> alpha, List<double> beta, int kStep) {
  for (var i = 0; i < kStep; i++) {}
  return 0;
}

void main() {
  List<double> a = [-1, 8 / 19, 0, -(8 / 19), 1]; // Coefficients for the method
  List<double> b = [
    6 / 19,
    24 / 19,
    0,
    24 / 19,
    6 / 19
  ]; // Coefficients for the method
  // List<double> c = [-5, 4, 1, 2, 4, 0]; // Coefficients for the method
  // List<double> d = [...a, ...b]; // Concatenation of the two lists
  // List<double> a = [0, 0, 0, -1, 1];
  // List<double> b = [-9 / 24, 37 / 24, -59 / 24, 55 / 24, 0];
  final answwwer  = orderAndErrorConstantCalculator(a, b);
  print(answwwer);
}

(int, double) orderAndErrorConstantCalculator(List<double> a, List<double> b) {
  List<double> c0 = [];
  double r = 0;
  double errorConstant = 0;

  int cp = 2;
  while (true) {
    print("cp: $cp");
    for (var i = 0; i <= 4; i++) {
      final t = (pow(i, cp) * a[i] / cp.factorial()) -
          ((pow(i, cp - 1) * b[i]) / (cp - 1).factorial());
      print("i: $i");
      print("t: $t");
      r = r + t;
      print("r: $r");
      //  print(tList);
      if (i == 4) {
        print("this is precision: ${r.approximate(6)}");

        final approximatedR = r.approximate(6);
        c0.add(approximatedR);

        print("after adding $r, c0 is: $c0, at $i");
      }
    }

    print("c: ${c0}");
    if (c0.isNotEmpty) {
      errorConstant += c0.reduce((value, element) => value + element);
      print("total: $errorConstant");
      if (errorConstant == 0) {
        cp += 1;
        r = 0;
        print("r:$r");
        continue;
      }
      break;
    } else {
      break;
    }
  }

  return (c0.length + 1, errorConstant);
}
