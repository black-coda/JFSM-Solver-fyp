import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/src/app/view/screens/step_number_screen.dart';

import 'test_for_convergence_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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
            child: Material(
              child: Stepper(
                steps: steps,
                currentStep: currentStep,
                connectorColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColor,
                ),
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      if (currentStep != 0)
                         TextButton(
                          onPressed: (){
                         
                            
                            setState(() {
                              currentStep -= 1;
                            });
                          },
                          child: const Text("Back"),
                                               ),
                      if (currentStep != steps.length - 1)
                        CallbackShortcuts(
                          bindings: <ShortcutActivator, VoidCallback>{
                            SingleActivator(LogicalKeyboardKey.enter):() {
                              // TODO: Contiue from here
                            }
                          
                          },
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentStep = currentStep + 1;
                              });
                            },
                            child: const Text("Next"),
                          ),
                        ),
                    ],
                  );
                },
                onStepContinue: () {
                  if (currentStep == 0) {}
                },
              ),
            ),
          ),
          const Expanded(
            child: Placeholder(
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
