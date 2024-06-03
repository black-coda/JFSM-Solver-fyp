import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/key.dart';
import 'package:frontend/src/app/view/screens/stepper_screen.dart';
import 'package:frontend/src/app/view/screens/result_of_method_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'solver/solver_parameter_screen_collector.dart';

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

  final _page = const <Widget>[
    StepperScreen(),
    AnalysisResultScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _page,
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
                return (isFormValid == false)
                    ? IconButton.outlined(
                        onPressed: () {},
                        icon: Icon(
                          MdiIcons.circleOffOutline,
                          color: Colors.red,
                        ),
                      )
                    : IconButton.outlined(
                        onPressed: () {
                          if (_pageController.page == _page.length - 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SolverView(),
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
