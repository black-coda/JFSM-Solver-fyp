import 'dart:developer' as dev;
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/method_implementation_controller.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/utils/constant/constant.dart';
import 'package:frontend/src/utils/extension/approximation.dart';
import 'package:frontend/src/utils/extension/format_string_to_number.dart';
import 'package:frontend/src/utils/shortcut_manager/shortcut_managers.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExplicitAndImplicitLinearizationSolverScreen
    extends ConsumerStatefulWidget {
  const ExplicitAndImplicitLinearizationSolverScreen({Key? key})
      : super(key: key);

  @override
  ConsumerState<ExplicitAndImplicitLinearizationSolverScreen> createState() =>
      _SolverViewState();
}

class _SolverViewState
    extends ConsumerState<ExplicitAndImplicitLinearizationSolverScreen> {
  late TextEditingController y0Controller;
  late TextEditingController x0Controller;
  late TextEditingController stepSizeController;
  late TextEditingController nController;
  late MathFieldEditingController functionController;
  late MathFieldEditingController exactFunctionController;

  final GlobalKey _graphKey = GlobalKey();
  final GlobalKey _tableKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    y0Controller = TextEditingController();
    x0Controller = TextEditingController();
    stepSizeController = TextEditingController();
    nController = TextEditingController();
    functionController = MathFieldEditingController();
    exactFunctionController = MathFieldEditingController();
  }

  @override
  void dispose() {
    y0Controller.dispose();
    x0Controller.dispose();
    stepSizeController.dispose();
    nController.dispose();
    functionController.dispose();
    exactFunctionController.dispose();
    super.dispose();
  }

  double Function(double, double)? parsedFunction;
  double Function(double)? parsedExactFunction;
  final formKey = GlobalKey<FormState>();
  List<double> result = [];
  List<double> xValues = [];
  List<double> yExactValues = [];

  @override
  Widget build(BuildContext context) {
    ref.watch(solverProvider);

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP):
            const PrintIntent(),
      },
      child: Actions(
        dispatcher: LoggingActionDispatcher(),
        actions: <Type, Action<Intent>>{
          PrintIntent: PrintAction(onPrint: _printDocument),
        },
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Solver View'),
              actions: [
                Actions(
                  actions: <Type, Action<Intent>>{
                    PrintIntent: PrintAction(onPrint: _printDocument),
                  },
                  child: Builder(builder: (context) {
                    return IconButton(
                      onPressed: Actions.handler<PrintIntent>(
                          context, const PrintIntent()),
                      icon: const Icon(Icons.print),
                    );
                  }),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _saveAsPdf,
                  icon: const Icon(Icons.save_alt),
                ),
                const SizedBox(width: 40),
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
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
                                  _buildTextField(
                                      "Step Size", stepSizeController),
                                  const SizedBox(height: 16),
                                  _buildTextField("xn", nController),
                                  const SizedBox(height: 16),
                                  MathField(
                                    controller: exactFunctionController,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Enter the exact function f(x)',
                                      border: OutlineInputBorder(),
                                    ),
                                    variables: const ['x'],
                                    autofocus: true,
                                  ),
                                  const SizedBox(height: 16),
                                  //! Submit button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          yExactValues = [];
                                        },
                                        child: const Text("Reset"),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  const Divider(),
                                  result.isNotEmpty
                                      ? RepaintBoundary(
                                          key: _tableKey,
                                          child: SizedBox(
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
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            'y-approximate',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            'y-exact',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                        Expanded(
                                                          child: Text(
                                                            yExactValues[
                                                                    index - 1]
                                                                .toString(), // Adjust index for data rows
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        )
                                      : const Center(
                                          child: Text('No data to display')),
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
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return RepaintBoundary(
                          key: _graphKey,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Graphing View",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 16),
                                buildLegend(),
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
                                                color: touchedSpot.bar.gradient
                                                        ?.colors[0] ??
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
                                                xValues[index], result[index]),
                                          ),
                                          isCurved: true,
                                          barWidth: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          dotData: const FlDotData(show: true),
                                        ),
                                        LineChartBarData(
                                          spots: List.generate(
                                            yExactValues.length,
                                            (index) => FlSpot(xValues[index],
                                                yExactValues[index]),
                                          ),
                                          isCurved: true,
                                          barWidth: 2,
                                          color: Colors
                                              .red, // Color for exact solution
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
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
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
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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

  double Function(double)? parseExactFunction(Expression exp) {
    Variable x = Variable('x');

    return (double xValue) {
      ContextModel cm = ContextModel();
      cm.bindVariable(x, Number(xValue));

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

        String exactFunction = exactFunctionController.currentEditingValue();
        final exactExpression = TeXParser(exactFunction).parse();
        parsedExactFunction = parseExactFunction(exactExpression);

        final y0 = double.tryParse(y0Controller.text) ?? 0.0;
        final x0 = double.tryParse(x0Controller.text) ?? 0.0;
        final stepSize = double.tryParse(stepSizeController.text) ?? 0.0;
        final xN = int.tryParse(nController.text) ?? 0;

        final alpha = ref.read(alphaProvider);
        final beta = ref.read(betaProvider);

        final stepNumber = ref.read(stepNumberStateProvider);

        result = ref.watch(solverProvider).explicitLinearMultistepMethod(
              stepNumber: stepNumber,
              alpha: alpha,
              beta: beta,
              func: parsedFunction!,
              y0: y0,
              x0: x0,
              stepSize: stepSize,
              xN: xN,
            );

        int N = ((xN - x0) / stepSize).ceil();

        xValues = ref
            .read(solverProvider)
            .implicitXValueGenerator(x0, stepSize, N - 1);

        yExactValues = xValues
            .map((x) =>
                parsedExactFunction!(x).approximate(Constant.approximatedValue))
            .toList();

        dev.log(xValues.toString());
        dev.log(yExactValues.toString());
        ref.invalidate(solverProvider);
      } catch (e) {
        dev.log(e.toString());
      }
    }
  }

  Widget buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 5),
            const Text('Numerical Solution'),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: Colors.red,
            ),
            const SizedBox(width: 5),
            const Text('Exact Solution'),
          ],
        ),
      ],
    );
  }

  Future<Uint8List?> _capturePng(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<pw.Document> _createPdf(
      Uint8List graphImage, Uint8List tableImage) async {
    final pdf = pw.Document();
    final graph = pw.MemoryImage(graphImage);
    final table = pw.MemoryImage(tableImage);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(graph),
              pw.SizedBox(height: 20),
              pw.Image(table),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  void _printDocument() async {
    final graphImage = await _capturePng(_graphKey);
    final tableImage = await _capturePng(_tableKey);

    if (graphImage != null && tableImage != null) {
      final pdfDocument = await _createPdf(graphImage, tableImage);

      await Printing.layoutPdf(onLayout: (format) async => pdfDocument.save());
    }
  }

  //! Save as PDF
  Future<void> _saveAsPdf() async {
    final graphImage = await _capturePng(_graphKey);
    final tableImage = await _capturePng(_tableKey);

    if (graphImage != null && tableImage != null) {
      final pdfDocument = await _createPdf(graphImage, tableImage);

      final output = await getTemporaryDirectory();
      log(output.path);
      final file = File("${output.path}/output.pdf");
      await file.writeAsBytes(await pdfDocument.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved PDF to ${file.path}')),
      );
    }
  }


}

class PrintIntent extends Intent {
  const PrintIntent();
}

class PrintAction extends Action<PrintIntent> {
  final VoidCallback onPrint;

  PrintAction({required this.onPrint});

  @override
  void invoke(covariant PrintIntent intent) {
    onPrint();
  }
}
