import 'package:flutter_riverpod/flutter_riverpod.dart';

final alphaProvider = StateProvider<List<double>>((ref) {
  final List<double> a = [0];
  return a;
});

final betaProvider = StateProvider<List<double>>((ref) {
  final List<double> b = [0];
  return b;
});
