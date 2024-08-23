import 'package:equations/equations.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/src/module/linear_multistep_analysis_method.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';
import 'package:frontend/src/utils/extension/approximation.dart';
import 'dart:math';
import 'package:frontend/src/utils/extension/factorial.dart';
import 'package:frontend/src/utils/extension/unique_element_checker.dart';
import 'package:frontend/src/utils/extension/value_greater_than_or_equal_to_one.dart';

/// A class implementing analysis methods for linear multistep numerical methods.
///
/// Linear multistep analysis methods evaluate the properties of numerical methods
/// for solving ordinary differential equations (ODEs). This class provides
/// functionality to check the consistency, stability, convergence, order of
/// convergence, and error constant of linear multistep methods.
class AnalysisImplementation implements LinearMultiStepAnalysisMethod {
  /// The number of steps in the linear multistep method.
  final int kSteps;

  /// Coefficients of the terms involving alpha values of a LMM.
  final List<double> alpha;

  /// Coefficients of the terms involving beta values of a LMM.
  final List<double> beta;

  /// Constructs a [AnalysisImplementation] instance with the given parameters
  /// representing the coefficients of a linear multistep method.
  ///  - [kSteps]: The number of steps in the linear multistep method.
  /// - [alpha]: Coefficients of the terms involving alpha values of a LMM.
  /// - [beta]: Coefficients of the terms involving beta values of a LMM.

  AnalysisImplementation({
    required this.kSteps,
    required this.alpha,
    required this.beta,
  });

  /// Constructs a [AnalysisImplementation] instance with initial state.
  AnalysisImplementation.initialState()
      : kSteps = 0,
        alpha = const [0, 0],
        beta = const [0, 0];

  @override
  bool isConsistent() {
    /// Checks whether the linear multistep method is consistent.
    ///
    /// Consistency refers to the property of a numerical method where the
    /// truncation error approaches zero as the step size tends to zero.
    ///
    /// Returns `true` if the method is consistent, otherwise `false`.
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
    debugPrint("c1: $c1, c0: $c0");
    return c0.approximate(6) == 0 && c1.approximate(6) == 0;
  }

  @override
  bool isConvergent() {
    /// Checks whether the linear multistep method is convergent.
    ///
    /// Convergence refers to the property of a numerical method where the
    /// numerical solution approaches the exact solution as the step size tends to zero.
    ///
    /// Returns `true` if the method is convergent, otherwise `false`.
    if (isZeroStable() && isConsistent()) {
      return true;
    }
    return false;
  }

  @override
  bool isZeroStable() {
    /// Checks whether the linear multistep method is zero-stable.
    ///
    /// Zero stability refers to the property of a numerical method where small
    /// errors in the initial conditions do not lead to significant amplification
    /// of errors in the computed solution.
    ///
    /// Returns `true` if the method is zero-stable, otherwise `false`.
    List<Complex> algebraicSolution = [];
    if (alpha.isNotEmpty) {
      Algebraic eq;

      final reversedAlpha = alpha.reversed.toList();

      switch (kSteps) {
        case 1:
          eq = Linear.realEquation(
            a: alpha.elementAt(1),
            b: alpha.elementAt(0),
          );
        case 2:
          eq = Quadratic.realEquation(
            a: alpha.elementAt(2),
            b: alpha.elementAt(1),
            c: alpha.elementAt(0),
          );
        case 3:
          eq = Cubic.realEquation(
            a: alpha.elementAt(3),
            b: alpha.elementAt(2),
            c: alpha.elementAt(1),
            d: alpha.elementAt(0),
          );

        // TODO: Implement the method for solving the quartic equation.
        // case 4:

        //   eq = Quartic.realEquation(
        //     a: alpha.elementAt(4),
        //     b: alpha.elementAt(3),
        //     c: alpha.elementAt(2),
        //     d: alpha.elementAt(1),
        //     e: alpha.elementAt(0),
        //   );
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
    /// Calculates the order of convergence and error constant of the method.
    ///
    /// The order of convergence represents the rate at which the numerical
    /// solution converges to the exact solution as the step size decreases. The
    /// error constant quantifies the magnitude of the error in the numerical
    /// solution.
    ///
    /// Returns a tuple containing the order of convergence and the error constant.
    /// 
    /// TODO: ask professor fatokun
    // if (!isConsistent()) {
    //   return (404, 0.0); // Consistency check failed
    // }

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
        print("Error Constant: $errorConstant");
        break;
      } else {
        break;
      }
    }

    return (c0.length, errorConstant);
  }
}
