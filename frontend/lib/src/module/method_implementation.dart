import 'package:equations/equations.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';
import 'package:frontend/src/module/linear_multistep_method.dart';
import 'package:frontend/src/utils/extension/approximation.dart';
import "dart:math";

import 'package:frontend/src/utils/extension/factorial.dart';
import 'package:frontend/src/utils/extension/unique_element_checker.dart';
import 'package:frontend/src/utils/extension/value_greater_than_or_equal_to_one.dart';

class MethodImplementation implements LinearMultiStepMethod {
  final int kSteps;
  final List<double> alpha;
  final List<double> beta;
  MethodImplementation(
      {required this.kSteps, required this.alpha, required this.beta});

  MethodImplementation.initialState()
      : kSteps = 0,
        alpha = const [0, 0],
        beta = const [0, 0];

  @override
  bool isConsistent() {
    final List<double> parameters = [...alpha, ...beta];
    double sumOfAlphaMultipliedByIndex = 0;

    if (parameters.length != 2 * kSteps + 2) {
      throw ArgumentError(
          'Expected ${2 * kSteps + 2} parameters, got ${parameters.length}');
    }

    final double c0 = alpha.reduce((value, element) => value + element);
    c0.log();
    final double sumOfBeta = beta.reduce((value, element) => value + element);

    for (var i = 0; i < alpha.length; i++) {
      sumOfAlphaMultipliedByIndex += i * alpha.elementAt(i);
    }
    final c1 = sumOfAlphaMultipliedByIndex - sumOfBeta;
    return c0 == 0 && c1 == 0;
  }

  @override
  bool isConvergent() {
    if (isZeroStable() && isConsistent()) {
      return true;
    }
    return false;
  }

  @override
  bool isZeroStable() {
    List<Complex> algebraicSolution = [];
    if (alpha.isNotEmpty) {
      Algebraic eq;
      final reversedAlpha = alpha.reversed.toList();
      final degree = reversedAlpha.length - 1;
      debugPrint("degree: $degree");
      switch (degree) {
      
        
        case 1:
          eq = Linear.realEquation(
            a: reversedAlpha.elementAt(1),
            b: reversedAlpha.elementAt(0),
          );
        case 2:
          eq = Quadratic.realEquation(
            a: reversedAlpha.elementAt(2),
            b: reversedAlpha.elementAt(1),
            c: reversedAlpha.elementAt(0),
          );
        case 3:
          eq = Cubic.realEquation(
            a: reversedAlpha.elementAt(3),
            b: reversedAlpha.elementAt(2),
            c: reversedAlpha.elementAt(1),
            d: reversedAlpha.elementAt(0),
          );
        case 4:
          eq = Quartic.realEquation(
            a: reversedAlpha.elementAt(4),
            b: reversedAlpha.elementAt(3),
            c: reversedAlpha.elementAt(2),
            d: reversedAlpha.elementAt(1),
            e: reversedAlpha.elementAt(0),
          );
        default:
          eq = DurandKerner.realEquation(
            coefficients: reversedAlpha,
          );
      }
      algebraicSolution = eq.solutions();
      if (algebraicSolution.hasValueGreaterThanOrEqualToOne() == false &&
          algebraicSolution.containsMoreThanOneOne() == false) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  @override
  (int, double) orderAndErrorConstant() {
    if (!isConsistent()) {
      return (404, 0.0); // Consistency check failed
    }

    List<double> c0 = [];
    double sumOfC0 = 0;
    double errorConstant = 0;

    int cp = 2;
    while (true) {
      for (var i = 0; i <= kSteps; i++) {
        final term = (pow(i, cp) * alpha[i] / cp.factorial()) -
            ((pow(i, cp - 1) * beta[i]) / (cp - 1).factorial());
        sumOfC0 = sumOfC0 + term;

        if (i == kSteps) {
          final approximatedR = sumOfC0.approximate(6);
          c0.add(approximatedR);
        }
      }

      if (c0.isNotEmpty) {
        errorConstant += c0.reduce((value, element) => value + element);
        if (errorConstant == 0) {
          cp += 1;
          sumOfC0 = 0;
          continue;
        }
        break;
      } else {
        break;
      }
    }

    return (c0.length, errorConstant);
  }
}
