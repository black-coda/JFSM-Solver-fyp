import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';
import 'package:math_keyboard/math_keyboard.dart';

class SolverView extends ConsumerStatefulWidget {
  const SolverView({Key? key}) : super(key: key);

  @override
  ConsumerState<SolverView> createState() => _SolverViewState();
}

class _SolverViewState extends ConsumerState<SolverView> {
  late TextEditingController funcController;
  late TextEditingController y0Controller;
  late TextEditingController x0Controller;
  late TextEditingController stepSizeController;
  late TextEditingController NController;

  @override
  void initState() {
    super.initState();
    funcController = TextEditingController();
    y0Controller = TextEditingController();
    x0Controller = TextEditingController();
    stepSizeController = TextEditingController();
    NController = TextEditingController();
  }

  @override
  void dispose() {
    funcController.dispose();
    y0Controller.dispose();
    x0Controller.dispose();
    stepSizeController.dispose();
    NController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solver View'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MathField(
                keyboardType: MathKeyboardType
                    .expression, // Specify the keyboard type (expression or number only).
                variables: const [
                  'x',
                  'y',
                ], // Specify the variables the user can use (only in expression mode).
                decoration: const InputDecoration(
                  labelText: "Enter f(x)",
                  border: OutlineInputBorder(),
                ), // Decorate the input field using the familiar InputDecoration.
                onChanged:
                    (String value) {}, // Respond to changes in the input field.
                onSubmitted: (String
                    value) {}, // Respond to the user submitting their input.
                autofocus:
                    true, // Enable or disable autofocus of the input field.
              ),
              const SizedBox(height: 16),
              _buildTextField("Function", funcController),
              const SizedBox(height: 16),
              _buildTextField("Initial Value of y (y0)", y0Controller),
              const SizedBox(height: 16),
              _buildTextField("Initial Value of x (x0)", x0Controller),
              const SizedBox(height: 16),
              _buildTextField("Step Size", stepSizeController),
              const SizedBox(height: 16),
              _buildTextField("Number of Steps (N)", NController),
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _onSubmit() {
    final func = funcController.text;
    final y0 = double.tryParse(y0Controller.text) ?? 0.0;
    final x0 = double.tryParse(x0Controller.text) ?? 0.0;
    final stepSize = double.tryParse(stepSizeController.text) ?? 0.0;
    final N = int.tryParse(NController.text) ?? 0;

    func.log();

    // Now you have all the collected values, you can proceed with the desired action
  }
}
