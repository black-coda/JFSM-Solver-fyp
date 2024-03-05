import 'package:equations/equations.dart';
import 'package:frontend/src/utils/extension/approximation.dart';

extension ValueGreaterThanOne on List<Complex> {
  bool hasValueGreaterThanOrEqualToOne() {
    return any(
      (solution) {
        print("from value grater: ${solution.abs()}");
        return solution.abs().approximate(6) > 1.0;
      },
    );
  }
}
