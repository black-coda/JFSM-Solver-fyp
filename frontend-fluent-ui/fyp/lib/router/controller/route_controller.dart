import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../route_manager.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return RouteManager.router;
});
