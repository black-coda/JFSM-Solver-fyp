import 'dart:developer' as dev;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/method_implementation_controller.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/utils/extension/format_string_to_number.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:math_keyboard/math_keyboard.dart';

class PredictorCorrectorSolverView extends ConsumerStatefulWidget {
  const PredictorCorrectorSolverView({Key? key}) : super(key: key);

  @override
  ConsumerState<PredictorCorrectorSolverView> createState() =>
      _PredictorCorrectorSolverViewState();
}

class _PredictorCorrectorSolverViewState
    extends ConsumerState<PredictorCorrectorSolverView> {
  late TextEditingController y0Controller;
  late TextEditingController x0Controller;
  late TextEditingController stepSizeController;
  late TextEditingController nController;
  late MathFieldEditingController functionController;

  @override
  void initState() {
    super.initState();

    y0Controller = TextEditingController();
    x0Controller = TextEditingController();
    stepSizeController = TextEditingController();
    nController = TextEditingController();
    functionController = MathFieldEditingController();
  }

  @override
  void dispose() {
    y0Controller.dispose();
    x0Controller.dispose();
    stepSizeController.dispose();
    nController.dispose();
    functionController.dispose();
    super.dispose();
  }

  double Function(double, double)? parsedFunction;
  final formKey = GlobalKey<FormState>();
  List<double> result = [];
  List<double> xValues = [];

  @override
  Widget build(BuildContext context) {
    ref.watch(solverProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solver View'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        child: Row(
          children: [
            //! form view
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("Enter the appropriate values"),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
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
                            _buildTextField(
                                "Initial Value of y (y0)", y0Controller),
                            const SizedBox(height: 16),
                            _buildTextField(
                                "Initial Value of x (x0)", x0Controller),
                            const SizedBox(height: 16),
                            _buildTextField("Step Size", stepSizeController),
                            const SizedBox(height: 16),
                            _buildTextField("Number of Steps (N)", nController),
                            const SizedBox(height: 16),
                            const SizedBox(height: 16),
                            //! Submit button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: _onSubmit,
                                  child: const Text('Submit'),
                                ),

                                //! Reset button
                                ElevatedButton(
                                  onPressed: () async {
                                    xValues = [];
                                    result = [];
                                  },
                                  child: const Text("Reset"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            //* The result screen of the app
                            result.isNotEmpty
                                ? SizedBox(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: result.length,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          // Header Row
                                          return const ListTile(
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'x-values',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'y-values',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          // Data Rows
                                          return ListTile(
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    xValues[index - 1]
                                                        .toString(), // Adjust index for data rows
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    result[index - 1]
                                                        .toString(), // Adjust index for data rows
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('No data to display'),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //! Grapher View

            Expanded(
              flex: 3,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        //* The Graph
                        Text(
                          "Grapher View",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    maxContentWidth: 100,
                                    getTooltipColor: (touchedSpot) =>
                                        Colors.black,
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots
                                          .map((LineBarSpot touchedSpot) {
                                        final textStyle = TextStyle(
                                          color: touchedSpot
                                                  .bar.gradient?.colors[0] ??
                                              touchedSpot.bar.color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        );
                                        return LineTooltipItem(
                                          '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                                          textStyle,
                                        );
                                      }).toList();
                                    },
                                  ),
                                  handleBuiltInTouches: true,
                                  getTouchLineStart: (data, index) => 0,
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(
                                        result.length,
                                        (index) => FlSpot(
                                            xValues[index], result[index])),
                                    isCurved: true,
                                    barWidth: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    dotData: const FlDotData(show: true),
                                  ),
                                ],
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: const Color(0xff37434d)),
                                ),
                                titlesData: const FlTitlesData(
                                  show: true,
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  horizontalInterval: 1,
                                  verticalInterval: 1,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      strokeWidth: 1,
                                    );
                                  },
                                )),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
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

//! text field builder
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
    Variable x = Variable('x');
    Variable y = Variable('y');

    return (double xValue, double yValue) {
      ContextModel cm = ContextModel();
      cm.bindVariable(x, Number(xValue));
      cm.bindVariable(y, Number(yValue));

      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result;
    };
  }

  void _onSubmit() {
    if (formKey.currentState!.validate()) {
      try {
        String inputFunction = functionController.currentEditingValue();
        dev.log(inputFunction.runtimeType.toString());
        final mathExpression = TeXParser(inputFunction).parse();
        dev.log(mathExpression.toString());

        parsedFunction = parseFunction(mathExpression);

        final y0 = double.tryParse(y0Controller.text) ?? 0.0;
        final x0 = double.tryParse(x0Controller.text) ?? 0.0;
        final stepSize = double.tryParse(stepSizeController.text) ?? 0.0;
        final xN = int.tryParse(nController.text) ?? 0;

        //! step number
        final predictorStepNumber = ref.read(stepNumberStateProvider);
        final correctorStepNumber = ref.read(correctorStepNumberStateProvider);

        //! alpha and beta
        final alpha = ref.read(alphaProvider);
        final beta = ref.read(betaProvider);
        final correctorAlpha = ref.read(correctorAlphaProvider);
        final correctorBeta = ref.read(correctorBetaProvider);

        result = ref
            .watch(solverProvider)
            .implicitLinearMultistepMethodWithPredictorCorrectorMethod(
              predictorStepNumber: predictorStepNumber,
              correctorAlpha: correctorAlpha,
              correctorBeta: correctorBeta,
              predictorAlpha: alpha,
              predictorBeta: beta,
              func: parsedFunction!,
              y0: y0,
              x0: x0,
              stepSize: stepSize,
              xN: xN,
              correctorStepNumber: correctorStepNumber,
            );

        int N = ((xN - x0) / stepSize).ceil();

        xValues = ref
            .read(solverProvider)
            .implicitXValueGenerator(x0, stepSize, N - 1);

        // Validate xValues and result
        // if (xValues.any((x) => x.isNaN || x.isInfinite) ||
        //     result.any((y) => y.isNaN || y.isInfinite)) {
        //   throw UnsupportedError("Calculation resulted in NaN or Infinity");
        // }
        dev.log(xValues.toString());
        ref.invalidate(solverProvider);
      } catch (e) {
        dev.log(e.toString());
      }
    }
  }
}

class PEView extends ConsumerWidget {
  const PEView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PE View'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'PE View',
            ),
          ],
        ),
      ),
    );
  }
}
