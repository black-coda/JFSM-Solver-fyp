import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/app/view_models/linear_multistep_analysis_method_implementation.dart';
import 'package:frontend/src/app/view_models/linear_multistep_solver.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';

final analysisProvider = Provider<AnalysisImplementation>(
  (ref) {
    final kSteps = ref.watch(stepNumberStateProvider);
    kSteps.log();
    final alpha = ref.watch(alphaProvider);
    alpha.log();
    final beta = ref.watch(betaProvider);
    beta.log();
    return AnalysisImplementation(
      kSteps: kSteps,
      alpha: alpha,
      beta: beta,
    );
  },
);

final correctorAnalysisProvider = Provider<AnalysisImplementation>((ref) {
  final kSteps = ref.watch(correctorStepNumberStateProvider);
  kSteps.log();
  final alpha = ref.watch(correctorAlphaProvider);
  alpha.log();
  final beta = ref.watch(correctorBetaProvider);
  beta.log();
  return AnalysisImplementation(kSteps: kSteps, alpha: alpha, beta: beta);
});

final solverProvider = Provider<SolverImplementation>((ref) {
  return SolverImplementation();
});
