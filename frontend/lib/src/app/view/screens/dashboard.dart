import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/is_imp_or_exp_controller.dart';
import 'package:frontend/src/app/controller/key.dart';
import 'package:frontend/src/app/view/screens/solver/implicit_solver_view.dart';
import 'package:frontend/src/app/view/screens/stepper_screen.dart';
import 'package:frontend/src/app/view/screens/result_of_explicit_method_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'result_of_implcit_PE_method_test.dart';
import 'solver/explicit_and_implicit_linearization_solver_view.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ref.read(isAnalysisCollectorFormValidProvider.notifier).state = false;
  }

  final _page = <Widget>[
    const StepperScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isPEmethod = ref.watch(isImplicitPredictorCorrectorMethodProvider);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          const StepperScreen(),
          isPEmethod
              ? const ImplicitPEAnalysisResultScreen()
              : const ExplicitAnalysisResultScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.outlined(
              onPressed: () {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            Text(
              "Navigator".toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                ref.watch(isAnalysisCollectorFormValidProvider);
                bool isFormValid = ref
                    .watch(isAnalysisCollectorFormValidProvider.notifier)
                    .state;
                return isFormValid == false
                    ? IconButton.outlined(
                        onPressed: () {},
                        icon: Icon(
                          MdiIcons.circleOffOutline,
                          color: Colors.red,
                        ),
                      )
                    : IconButton.outlined(
                        onPressed: () {
                          if (_pageController.page == 2 - 1) {
                            final isPredictorCorrector = ref.watch(
                                isImplicitPredictorCorrectorMethodProvider);
                            isPredictorCorrector
                                ? Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PredictorCorrectorSolverView(),
                                    ),
                                  )
                                : Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ExplicitAndImplicitLinearizationSolverView(),
                                    ),
                                  );
                          }

                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).colorScheme.primary),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
