import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/is_imp_or_exp_controller.dart';
import 'package:frontend/src/app/controller/method_implementation_controller.dart';
import 'package:frontend/src/utils/extension/format_string_to_number.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:math_keyboard/math_keyboard.dart';

class SolverView extends ConsumerStatefulWidget {
  const SolverView({Key? key}) : super(key: key);

  @override
  ConsumerState<SolverView> createState() => _SolverViewState();
}

class _SolverViewState extends ConsumerState<SolverView> {
  late TextEditingController y0Controller;
  late TextEditingController x0Controller;
  late TextEditingController stepSizeController;
  late TextEditingController stepNumberController;
  late TextEditingController nController;

  late MathFieldEditingController functionController;

  @override
  void initState() {
    super.initState();

    y0Controller = TextEditingController();
    x0Controller = TextEditingController();
    stepSizeController = TextEditingController();
    stepNumberController = TextEditingController();
    nController = TextEditingController();
    functionController = MathFieldEditingController();
  }

  @override
  void dispose() {
    y0Controller.dispose();
    x0Controller.dispose();
    stepSizeController.dispose();
    stepNumberController.dispose();

    functionController.dispose();
    super.dispose();
  }

  double Function(double, double)? parsedFunction;
  String result = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S o l v e r  V i e w'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                MathField(
                  controller: functionController,
                  decoration: const InputDecoration(
                    labelText: 'Enter function f(x, y)',
                    border: OutlineInputBorder(),
                  ),
                  variables: const ['x', 'y'],
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                _buildTextField("Initial Value of y (y0)", y0Controller),
                const SizedBox(height: 16),
                _buildTextField("Initial Value of x (x0)", x0Controller),
                const SizedBox(height: 16),
                _buildTextField("Step Size", stepSizeController),
                const SizedBox(height: 16),
                _buildTextField("Number of Steps (N)", stepNumberController),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //! form validators
  String? _formFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    try {
      double.parse(value.calculateFromString());
    } catch (e) {
      return "Please enter a valid number";
    }
    return null;
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: _formFieldValidator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  //! Parse function from mathField to expression
  double Function(double, double)? parseFunction(Expression exp) {
    // Create a parser
    // Parser p = Parser();

    // // Parse the input function
    // Expression exp = p.parse(input);

    // Define the variables x and y
    Variable x = Variable('x');
    Variable y = Variable('y');

    return (double xValue, double yValue) {
      // Bind the variables x and y to their values
      ContextModel cm = ContextModel();
      cm.bindVariable(x, Number(xValue));
      cm.bindVariable(y, Number(yValue));

      // Evaluate the expression
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result;
    };
  }

  void _onSubmit() {
    if (formKey.currentState!.validate()) {
      try {
        String inputFunction = functionController.currentEditingValue();
        log(inputFunction.runtimeType.toString());
        final mathExpression = TeXParser(inputFunction).parse();
        log(mathExpression.toString());

        //! the parsed function
        parsedFunction = parseFunction(mathExpression);

        final answer = parsedFunction!(5, 6);
        log(answer.toString(), name: 'answer');

        setState(() {
          result = "Function parsed successfully.";
        });

        //! main calculation
        final y0 = double.tryParse(y0Controller.text) ?? 0.0;
        final x0 = double.tryParse(x0Controller.text) ?? 0.0;
        final stepSize = double.tryParse(stepSizeController.text) ?? 0.0;
        final stepNumber = int.tryParse(stepNumberController.text) ?? 0;
        final n = int.tryParse(nController.text) ?? 0;

        final isPredictorCorrector = ref.read(isImplicitOrExplicitProvider);
        final alpha = ref.read(alphaProvider);
        final beta = ref.read(betaProvider);

        if (!isPredictorCorrector) {
          ref.read(solverProvider).explicitLinearMultistepMethod(
              stepNumber: stepNumber,
              alpha: alpha,
              beta: beta,
              func: parsedFunction!,
              y0: y0,
              x0: x0,
              stepSize: stepSize,
              N: n);
        } else {
          log("You haven't done this part");
        }
      } catch (e) {
        setState(() {
          result = "Error parsing function: $e";
        });
        log(e.toString());
      }
    }
  }
}
