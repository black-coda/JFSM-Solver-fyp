// ignore_for_file: avoid_print

import 'dart:math';

import 'package:equations/equations.dart';
import 'package:frontend/src/utils/extension/approximation.dart';
import 'package:frontend/src/utils/extension/factorial.dart';
import 'package:frontend/src/utils/extension/unique_element_checker.dart';
import 'package:frontend/src/utils/extension/value_greater_than_or_equal_to_one.dart';

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

Complex a = const Complex(1, 2);
void main() {
  // f(x) = 3 - x
  // final eq = Quartic(
  //   a: Complex.fromReal(1),
  //   b: Complex.fromFraction(Fraction(3, 1), Fraction(1, 1),
  //   c: Complex.fromReal(0),
  //   d: (8/19),
  //   e: -1,
  // );

  final e = Quartic(
    a: const Complex.fromReal(1),
    b: Complex.fromRealFraction(Fraction(-1, 1)),
    c: const Complex.fromReal(0),
    d: const Complex.fromReal(0),
    e: const Complex.fromReal(0),
  );

  final eq = DurandKerner.realEquation(coefficients: [1, -1, 0, 0, 0]);
  print(eq);
  print(eq.runtimeType);
  // final t =
  print(eq.solutions().runtimeType);
  final solutions = eq.solutions();
  for (var element in solutions) {
    print(element.abs());
  }
  final solutionGreaterThanOne =
      solutions.where((element) => element.abs() > 1).toList();
  final solutionLesserThanOne =
      solutions.where((element) => element.abs() < 1).toList();
  // print(">1: ${solutionGreaterThanOne.length}");
  // print("<1: ${solutionLesserThanOne.length}");
  print(solutions.containsMoreThanOneOne());
  print(solutions.hasValueGreaterThanOrEqualToOne());
 
}
