import 'package:equations/equations.dart';

extension ValueGreaterThanOne on List<Complex> {
  bool hasValueGreaterThanOrEqualToOne() {
    return any((solution) {
      return solution.abs() > 1;
    });
  }
}

