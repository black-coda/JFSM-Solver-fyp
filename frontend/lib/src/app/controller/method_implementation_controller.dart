import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/module/method_implementation.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';

final methodImplementationProvider = Provider<MethodImplementation>(
  (ref) {
    final kSteps = ref.watch(stepNumberStateProvider);
    kSteps.log();
    final alpha = ref.watch(alphaProvider);
    alpha.log();
    final beta = ref.watch(betaProvider);
    beta.log();
    return MethodImplementation(
      kSteps: kSteps,
      alpha: alpha,
      beta: beta,
    );
  },
);
