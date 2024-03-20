import 'package:flutter_riverpod/flutter_riverpod.dart';


class LinearMMethodNotifier extends StateNotifier<int> {
  LinearMMethodNotifier() : super(1);
}

final stepNumberStateProvider = StateProvider<int>((ref) {
  int k = 0;
  return k;
});
