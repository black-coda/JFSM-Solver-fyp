import 'dart:math';

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
  List<double> a = [0, 0, 0, -1, 1];
  List<double> b = [-9 / 24, 37 / 24, -59 / 24, 55 / 24, 0];

  List<double> c0 = [];
  double r = 0;
  double total = 0;

  int cp = 2;
  while (true) {
    print("cp: $cp");
    for (var i = 0; i <= 4; i++) {
      final t = (pow(i, cp) * a[i] / cp.factorials()) -
          ((pow(i, cp - 1) * b[i]) / (cp - 1).factorials());
      print("i: $i");
      print("t: $t");
      r += t;
      print("r: $r");

      if (i == 4) {
        final approximatedR = r.approximate(6);
        c0.add(approximatedR);
        print("after adding $r, c0 is: $c0, at $i");
      }
    }

    print("c: $c0");
    total = c0.reduce((value, element) => value + element);
    print("total: $total");

    if (total != 0) {
      break;
    }

    cp++;
    r = 0;
  }
}
