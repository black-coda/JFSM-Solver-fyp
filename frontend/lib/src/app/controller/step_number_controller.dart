import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/module/method_implementation.dart';

class LinearMMethodNotifier extends StateNotifier<int> {
  LinearMMethodNotifier() : super(1);
}

final stepNumberStateProvider = StateProvider<int>((ref) {
  int k = 0;
  return k;
});
