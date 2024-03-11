import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/view_models/linear_multistep_analysis_method_implementation.dart';

class LinearMMethodNotifier extends StateNotifier<int> {
  LinearMMethodNotifier() : super(1);
}

final stepNumberStateProvider = StateProvider<int>((ref) {
  int k = 0;
  return k;
});
