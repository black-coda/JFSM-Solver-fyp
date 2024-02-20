// ignore_for_file: avoid_print

import 'dart:math';

import 'package:frontend/src/utils/extension/factorial.dart';

void main() {
   List<double> a = [0, 0, 0, -1, 1];
  List<double> b = [-9 / 24, 37 / 24, -59 / 24, 55 / 24, 0];
  List<double> c0 = [];
  double sumOfCValue = 0;
  double total = 0;
  int cp =2;


  while (cp<6) {
    print("cp: $cp");
    for (var i = 0; i < 4; i++) {
      final termA = (pow(i, cp) * a[i] / cp.factorial());
      final termB = ((pow(i, cp - 1) * b[i]) / (cp - 1).factorial());
      final cValue = termA - termB;

      sumOfCValue += cValue;

      if (i == 4) {
        c0.add(sumOfCValue);
      }
    }

    if (c0.isNotEmpty) {
      print(c0);
      total += c0.reduce((value, element) => value + element);
      print("total: $total");
      if (total == 0) {
        cp += 1;
        sumOfCValue = 0;
        print("r:$sumOfCValue");
        continue;
      }
      break;
    } else {
      break;
    }


  }


}