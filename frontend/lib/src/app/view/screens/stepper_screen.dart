import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';

import 'package:frontend/src/app/view/screens/step_number_screen.dart';
import 'package:frontend/src/app/view/screens/type_of_lmm_screen.dart';

import 'analysis_value_collector.dart';

// final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

class StepperScreen extends ConsumerStatefulWidget {
  const StepperScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StepperScreenState();
}

class _StepperScreenState extends ConsumerState<StepperScreen> {
  int currentStep = 0;
  int currentIndex = 0;

  final TextEditingController stepNumberController = TextEditingController();

  @override
  void dispose() {
    stepNumberController.dispose();
    super.dispose();
  }

  // List<Step> steps = [
  //   Step(
  //     title: const Text("Step 1: Step Number of Method"),
  //     content: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 8.0),
  //       child: StepNumberScreen(
  //         stepProvider: stepNumberStateProvider,
  //         controller: stepNumberController,
  //       ),
  //     ),
  //   ),
  //   const Step(
  //     title: Text("Step 2: Analysis of Method Parameters"),
  //     content: AnalysisValueCollectorScreen(),
  //   ),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Form(
              child: Stepper(
                steps: [
                  Step(
                    title: const Text("Step 1: Step Number of Method"),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: StepNumberScreen(
                        stepProvider: stepNumberStateProvider,
                        controller: stepNumberController,
                      ),
                    ),
                  ),
                  const Step(
                    title: Text("Step 2: Analysis of Method Parameters"),
                    content: AnalysisValueCollectorScreen(),
                  ),
                ],
                currentStep: currentStep,
                onStepTapped: (step) {
                  setState(() {
                    currentStep = step;
                  });
                },
                connectorColor: WidgetStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColor,
                ),
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        if (currentStep != 2 - 1)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                currentStep += 1;
                              });
                            },
                            child: const Text("Next"),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Expanded(child: FactScreen())
        ],
      ),
    );
  }
}

class FactScreen extends StatelessWidget {
  const FactScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Guide to Using the Analysis Value Collector Form",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Welcome to the Analysis Value Collector screen! This form is a crucial step in the process of solving a linear multistep method. Below are the steps to effectively fill in the form:",
          ),
          SizedBox(height: 12),
          Text(
            "1. Understanding the Form Layout:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "- The form is divided into two sections, each represented by a Greek letter: α (Alpha) and β (Beta).",
          ),
          Text(
            "- Each section consists of several fields, labeled as α-0, α-1, ..., α-n (similarly for β), where n represents the number of steps in your linear multistep method.",
          ),
          SizedBox(height: 12),
          Text(
            "2. Inputting Data:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Alpha (α) Section:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "  - Input the values of α coefficients corresponding to each step of your linear multistep method.",
          ),
          Text(
            "  - Each field accepts numerical values. Ensure to input the correct α coefficients in the respective fields.",
          ),
          Text(
            "Beta (β) Section:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "  - Input the values of β coefficients corresponding to each step of your linear multistep method.",
          ),
          Text(
            "  - Similar to the Alpha section, ensure to input the correct β coefficients in the respective fields.",
          ),
          SizedBox(height: 12),
          Text(
            "3. Validation:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "- As you input the α and β coefficients, the form will validate each field in real-time.",
          ),
          Text(
            "- Any errors or invalid inputs will be highlighted, ensuring the accuracy of the data entered.",
          ),
          SizedBox(height: 12),
          Text(
            "4. Submission:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "- Once you've accurately filled in all the required fields with the α and β coefficients:",
          ),
          Text(
            "  - Tap on the \"Submit\" button located at the bottom of the form.",
          ),
          Text(
            "  - The form will validate the data again to ensure completeness and accuracy.",
          ),
          Text(
            "  - Upon successful validation, the α and β coefficients will be submitted for further analysis.",
          ),
          SizedBox(height: 12),
          Text(
            "5. Additional Notes:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "- Double-check your inputs to ensure the correctness of the α and β coefficients before submission.",
          ),
          Text(
            "- The collected data will be utilized to compute and analyze the linear multistep method, aiding in your mathematical computations.",
          ),
        ],
      ),
    );
  }
}
