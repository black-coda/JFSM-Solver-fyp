import 'dart:math';

extension ApproximateToPrecision on double {
  double approximate(int precision) {
    double mod = pow(10.0, precision).toDouble();
    return (this * mod).round() / mod;
  }
}
