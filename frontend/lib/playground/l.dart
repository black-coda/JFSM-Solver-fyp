import 'dart:math';

import 'package:frontend/playground/playdround.dart';
import 'package:frontend/src/utils/extension/factorial.dart';

// Define the coefficients alpha and beta as lists
List<double> alpha = [-1, 8 / 19, 0, -8 / 19, 1]; // Coefficients for the method
List<double> beta = [
  6 / 19,
  24 / 19,
  0,
  24 / 19,
  6 / 19
]; //  Example coefficients for beta_i

// double calculateCp(int p) {
//   double cp = 0;
//   for (int i = 0; i < 2; i++) {
//     double term = (pow(i, p) * alpha[i] / factorial(p)) -
//         (pow(i, p - 1) * beta[i] / factorial(p - 1));
//     cp += term;
//   }
//   return cp;
// }

// int factorial(int n) {
//   if (n <= 1) return 1;
//   return n * factorial(n - 1);
// }


// int factorialI(int n) {
//   int result = 1;
//   for (int i = 1; i <= n; i++) {
//     result *= i;
//   }
//   return result;
// }

int orderOfConvergenced(List<double> alpha, List<double> beta, int kSteps) {


  final c = List<double>.filled(kSteps + 1, 0); // Initialize c with zeros
  double sumOfC = 0; // Initialize sumOfC

  // Iterate over values of p from 2 to kSteps
  for (var p = 2; p <= kSteps; p++) {
    // Iterate over coefficients alpha and beta
    for (var i = 0; i < kSteps; i++) {
      // Compute the pth term and add it to c
      c[p] += (pow(i, p) * alpha[i] / p.factorial()) -
          (pow(i, p - 1) * beta[i] / (p - 1).factorial());
    }
    // Update sumOfC
    sumOfC += c[p];

    // Check if c[p] is non-zero
    if (c[p] != 0) {
      return p; // Return the order of convergence
    }
  }

  return 0; // No non-zero c[p] found within the range
}

void main() {
  List<double> alpha = [
    -1,
    8 / 19,
    0,
    -8 / 19,
    1
  ]; // Coefficients for the method
  List<double> beta = [6 / 19, 24 / 19, 0, 24 / 19, 6 / 19]; 
  // Start with p = 2 and continue until a non-zero value is obtained
   int order = orderOfConvergenced(alpha, beta, 4);
  print('The order of convergence is $order.');
}
