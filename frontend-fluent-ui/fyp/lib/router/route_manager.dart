import 'package:fluent_ui/fluent_ui.dart';
import 'package:fyp/lmm/view/screens/analysis_screen/analysis_screen.dart';
import 'package:fyp/lmm/view/screens/analysis_screen/parameters_collector.dart';
import 'package:fyp/lmm/view/screens/intro_screen/splash_screen.dart';
import 'package:fyp/main.dart';
import 'package:fyp/utils/constant/konstant.dart';
import 'package:go_router/go_router.dart';

class RouteManager {
  static final GlobalKey<NavigatorState> _rootNavigator =
      GlobalKey(debugLabel: "root");
  static final GlobalKey<NavigatorState> _shellNavigator =
      GlobalKey(debugLabel: "shell");

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigator,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: "splash",
        builder: (context, state) {
          return SplashScreen(
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: '/entry',
        name: "entry",
        builder: (context, state) {
          return EntryPoint(
            key: state.pageKey,
          );
        },
      ),
      // Shell route
      ShellRoute(
        navigatorKey: _shellNavigator,
        builder: (context, state, child) => AnalysisModuleScreen(
          key: state.pageKey,
        ),
        routes: [
          GoRoute(
            path: "/analysisParameter",
            name: Konstant.parameterCollector,
            builder: (context, state) => ParameterCollectorScreen(
              key: state.pageKey,
            ),
            routes: [
              GoRoute(
                path: "location",
                name: "coll",
                builder: (context, state) => TextScreen(
                  key: state.pageKey,
                ),
              )
            ],
          ),
          GoRoute(
            path: "/test2",
            name: Konstant.test2,
            builder: (context, state) => Text2(
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: "/test3",
            name: Konstant.test1,
            builder: (context, state) => TestTEr(
              key: state.pageKey,
            ),
          ),
        ],
      ),

      //Stateful nested navigation
    ],
  );
}
