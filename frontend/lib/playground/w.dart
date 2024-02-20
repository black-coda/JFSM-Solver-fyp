import 'dart:math';

extension Factorial on int {
  double factorial() {
    double result = 1;
    for (int i = 2; i <= this; i++) {
      result *= i;
    }
    return result;
  }
}

double calculateT(int i, List<double> a, List<double> b) {
  // Ensure a and b have the same length and enough elements
  if (a.length != b.length || a.length < i + 1) {
    throw ArgumentError(
        "Lists a and b must have the same length and at least ${i + 1} elements");
  }

  final p = i + 1; // Power for term1 and factorials
  final q = p - 1; // Power for term2 and factorial

  return (pow(i, p) * a[i] / (p).factorial()) -
      (pow(i, q) * b[i] / (q).factorial());
}

void main() {
  final List<double> a = [-1, 8 / 19, 0, -8 / 19, 1];
  final List<double> b = [6 / 19, 24 / 19, 0, 24 / 19, 6 / 19];
  final List<double> c = [-5, 4, 1, 2, 4, 0];

  for (var i = 0; i <= 4; i++) {
    final t = calculateT(i, a, b);
    print(t);
  }
}

// Function to calculate sum, if needed
double calculateSum(List<double> values) {
  return values.reduce((value, element) => value + element);
}
