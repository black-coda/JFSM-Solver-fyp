import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationPaneNotifier extends StateNotifier<int> {
  NavigationPaneNotifier() : super(0);

  void setIndexPosition(int position) {
    state = position;
  }
}


final selectedPaneProvider = StateNotifierProvider<NavigationPaneNotifier, int>((ref) {
  return NavigationPaneNotifier();
});

