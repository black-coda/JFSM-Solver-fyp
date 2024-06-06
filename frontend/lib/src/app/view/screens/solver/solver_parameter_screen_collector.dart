import 'dart:developer' as dev;
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/is_imp_or_exp_controller.dart';
import 'package:frontend/src/app/controller/method_implementation_controller.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/utils/extension/format_string_to_number.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SolverView extends ConsumerStatefulWidget {
  const SolverView({Key? key}) : super(key: key);

  @override
  ConsumerState<SolverView> createState() => _SolverViewState();
}

class _SolverViewState extends ConsumerState<SolverView> {
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

    Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
      if (value % 2 == 0) {
        return Container();
      }
      final style = TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: min(18, 18 * chartWidth / 300),
      );
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 1,
        child: Text(meta.formattedValue, style: style),
      );
    }

    Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
      if (value % 2 == 0) {
        return const SizedBox();
      }
      final style = TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: min(18, 18 * chartWidth / 300),
      );
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: Text(meta.formattedValue, style: style),
      );
    }

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
                            ElevatedButton(
                              onPressed: _onSubmit,
                              child: const Text('Submit'),
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
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
                                                            FontWeight.bold),
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
        final n = int.tryParse(nController.text) ?? 0;

        final isPredictorCorrector = ref.read(isImplicitOrExplicitProvider);
        final alpha = ref.read(alphaProvider);
        final beta = ref.read(betaProvider);

        final stepNumber = ref.read(stepNumberStateProvider);

        if (!isPredictorCorrector) {
          result = ref.watch(solverProvider).explicitLinearMultistepMethod(
                stepNumber: stepNumber,
                alpha: alpha,
                beta: beta,
                func: parsedFunction!,
                y0: y0,
                x0: x0,
                stepSize: stepSize,
                N: n,
              );

          xValues = ref
              .read(solverProvider)
              .implicitXValueGenerator(x0, stepSize, n - 1);

          // Validate xValues and result
          // if (xValues.any((x) => x.isNaN || x.isInfinite) ||
          //     result.any((y) => y.isNaN || y.isInfinite)) {
          //   throw UnsupportedError("Calculation resulted in NaN or Infinity");
          // }
          dev.log(xValues.toString());
          ref.refresh(solverProvider);
          // setState(() {});
        } else {
          dev.log("You haven't done this part");
        }
      } catch (e) {
        dev.log(e.toString());
      }
    }
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.result,
    required this.xValues,
  });

  final List<double> result;
  final List<double> xValues;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Graph'),
        Expanded(
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(result.length,
                      (index) => FlSpot(xValues[index], result[index])),
                  isCurved: true,
                  barWidth: 2,
                  color: Colors.blue,
                  dotData: const FlDotData(show: false),
                ),
              ],
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



// class EshaWork extends ConsumerWidget {

//   const EshaWork({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return  Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
//             child: Row(
//               children: [
//                 Expanded(
//                   // flex: 1,
//                   child: Form(
//                     key: formKey,
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 16),
//                           MathField(
//                             controller: functionController,
//                             decoration: const InputDecoration(
//                               labelText: 'Enter function f(x, y)',
//                               border: OutlineInputBorder(),
//                             ),
//                             variables: const ['x', 'y'],
//                             autofocus: true,
//                           ),
//                           const SizedBox(height: 16),
//                           _buildTextField(
//                               "Initial Value of y (y0)", y0Controller),
//                           const SizedBox(height: 16),
//                           _buildTextField(
//                               "Initial Value of x (x0)", x0Controller),
//                           const SizedBox(height: 16),
//                           _buildTextField("Step Size", stepSizeController),
//                           const SizedBox(height: 16),
//                           _buildTextField("Number of Steps (N)", nController),
//                           const SizedBox(height: 16),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: _onSubmit,
//                             child: const Text('Submit'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // graphing view
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: result.isNotEmpty
//                 ? Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 24.0),
//                       child: Row(
//                         children: [
//                           // Expanded(
//                           //   child: Column(
//                           //     children: [
//                           //       const Text('Results'),
//                           //       Expanded(
//                           //         child: ListView.builder(
//                           //           itemCount: result.length,
//                           //           itemBuilder: (context, index) {
//                           //             return ListTile(
//                           //               title: Text(
//                           //                   'x = ${xValues[index].toStringAsFixed(2)}, y = ${result[index].toStringAsFixed(6)}'),
//                           //             );
//                           //           },
//                           //         ),
//                           //       ),
//                           //     ],
//                           //   ),
//                           // ),
//                           // const VerticalDivider(),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 const Text('Graph'),
//                                 Expanded(
//                                   child: LineChart(
//                                     LineChartData(
//                                       borderData: FlBorderData(show: false),
//                                       lineBarsData: [
//                                         LineChartBarData(
//                                           spots: List.generate(
//                                               result.length,
//                                               (index) => FlSpot(xValues[index],
//                                                   result[index])),
//                                           isCurved: true,
//                                           barWidth: 2,
//                                           color: Colors.blue,
//                                           dotData: const FlDotData(show: false),
//                                         ),
//                                       ],
//                                       titlesData: const FlTitlesData(
//                                         leftTitles: AxisTitles(
//                                           sideTitles:
//                                               SideTitles(showTitles: true),
//                                         ),
//                                         bottomTitles: AxisTitles(
//                                           sideTitles:
//                                               SideTitles(showTitles: true),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : const Center(
//                     child: Text('No data to display'),
//                   ),
//           )
//         ],
//       );
   
//   }
// }



