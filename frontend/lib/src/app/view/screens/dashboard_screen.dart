import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/app/view/screens/step_number_screen.dart';

import 'test_for_convergence_screen.dart';

// final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int currentStep = 0;

  List<Step> steps = [
    const Step(
      title: Text("Step 1: Step Number of Method"),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: StepNumberScreen(),
      ),
    ),
    const Step(
      title: Text("Test For Convergence of LMM"),
      content: TestForConvergence(),
    ),
    Step(
      title: const Text("Order and Error Constant of Method"),
      content: Container(
        color: Colors.red,
      ),
    ),
    Step(
      title: const Text("Zero Stability"),
      content: Container(
        color: Colors.green,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stepper(
              steps: steps,
              currentStep: currentStep,
              onStepTapped: (step) {
                setState(() {
                  currentStep = step;
                });
              },
              connectorColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).primaryColor,
              ),
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    if (currentStep != 0)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            currentStep -= 1;
                          });
                        },
                        child: const Text("Back"),
                      ),
                    if (currentStep != steps.length - 1)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            currentStep += 1;
                          });
                        },
                        child: const Text("Next"),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.blueGrey),
              child: const Column(
                children: [
                  Text(
                    "Grapher",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
