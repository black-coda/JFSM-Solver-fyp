import 'dart:math';

import 'package:frontend/src/utils/devtool/devtool.dart';
import 'package:frontend/src/utils/extension/factorial.dart';

extension ApproximateToPrecision on num {
  double approximate(int precision) {
    double mod = pow(10.0, precision).toDouble();
    return (this * mod).round() / mod;
  }

  double factorials() {
    if (this <= 1) return 1;
    return this * (this - 1).factorials();
  }
}

void main() {
  int kSteps = 0;
  // List<double> alpha = [0, 0, -1, 1];
  // List<double> beta = [0, -1 / 12, 8 / 12, 5 / 12];

  List<double> alpha = [0,0];
  List<double> beta = [0,0];

  //  List<double> alpha = [-1, 8 / 19, 0, -(8 / 19), 1]; // Coefficients for the method
  // List<double> beta = [6 / 19, 24 / 19, 0, 24 / 19, 6 / 19];

  List<double> c0 = [];
  double r = 0;
  double total = 0;

  // List<double> c0 = [];
  double sumOfC0 = 0;
  double errorConstant = 0;

  int cp = 2;
  while (true) {
    for (var i = 0; i <= kSteps; i++) {
      print("cp -> $cp");
      final term = (pow(i, cp) * alpha[i] / cp.factorial()) -
          ((pow(i, cp - 1) * beta[i]) / (cp - 1).factorial());
      print("$i -> $term");
      sumOfC0 = sumOfC0 + term;
      // c0.add(sumOfC0);
      print("sum of c0 => $sumOfC0");

      if (i == kSteps) {
        final approximatedR = sumOfC0.approximate(6);
        c0.add(approximatedR);
      }
    }

    if (c0.isNotEmpty) {
      errorConstant += c0.reduce((value, element) => value + element);
      print("error konstant -> $errorConstant");
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

  print("$errorConstant, ${c0.length.toString()}");
}
