import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LinearMultistepMethodScreen(),
    );
  }
}

class LinearMultistepMethodScreen extends StatefulWidget {
  const LinearMultistepMethodScreen({super.key});

  @override
  _LinearMultistepMethodScreenState createState() =>
      _LinearMultistepMethodScreenState();
}

class _LinearMultistepMethodScreenState
    extends State<LinearMultistepMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  // Define controllers for text fields
  final TextEditingController stepNumberController = TextEditingController();
  final TextEditingController y0Controller = TextEditingController();
  final TextEditingController x0Controller = TextEditingController();
  final TextEditingController stepSizeController = TextEditingController();
  final TextEditingController nController = TextEditingController();

  List<double> result = [];
  List<double> xValues = [];

  List<double> explicitLinearMultistepMethod({
    required int stepNumber,
    required List<double> alpha,
    required List<double> beta,
    required double Function(double initialValueX, double initialValueY) func,
    required double y0,
    required double x0,
    required double stepSize,
    required int N,
  }) {
    // Initialize the result list with size N and filled with 0s
    List<double> result = List.filled(N, 0, growable: true);

    switch (stepNumber) {
      case 1:
        // Single-step method
        for (int i = 0; i < N; i++) {
          // Calculate the approximate function value at the current point
          double evaluateApproximateFunction = func(x0, y0);
          // Calculate the next value of y
          double y =
              stepSize * (beta.elementAt(0) * evaluateApproximateFunction) -
                  (alpha.elementAt(0) * y0);
          // Store the calculated value in the result list
          result[i] = y;
          // Update x and y for the next iteration
          x0 += stepSize;
          y0 = y;
        }
        break;
      case 2:
        List<double> yRKMethod = fourthOrderRungeKuttaExplicitMethod(
            func, y0, x0, stepSize, stepNumber);
        result[0] =
            yRKMethod[0].approximate(6); // Store the first value from RK method
        double y1 =
            result[0]; // Initialize y1 with the first value from RK method
        double x1 = x0 + stepSize; // Initialize x1 for the next point
        // Iterate starting from the second point
        for (int i = 1; i < N; i++) {
          // Calculate the approximate function value at the current point
          double evaluateApproximateFunction = func(x0.approximate(2), y0);
          // Calculate function values at the next step
          double fValuesOfRKResultF1 =
              func(x1.approximate(2), y1.approximate(6));
          // Calculate the new y value using explicit linear multistep method
          double y = stepSize *
                  ((beta.elementAt(0) *
                          evaluateApproximateFunction.approximate(6)) +
                      (beta.elementAt(1) *
                          fValuesOfRKResultF1.approximate(6))) -
              ((alpha.elementAt(1) * y1) + alpha.elementAt(0) * y0);
          // Store the calculated value in the result list
          result[i] = y.approximate(6);
          // Update x0, y0, and y1 for the next iteration
          x0 = x1.approximate(2);
          y0 = y1.approximate(6);
          y1 = y;
          // Update x1 for the next point
          x1 += stepSize;
        }
        break;
      default:
        result[0] = y0;
        List<double> initialValuesFromRKMethod =
            fourthOrderRungeKuttaExplicitMethod(
                func, y0, x0, stepSize, stepNumber);
        List<double> approximatedYFromRK =
            initialValuesFromRKMethod.map((e) => e.approximate(6)).toList();
        result.replaceRange(1, stepNumber, approximatedYFromRK);
        List<double> y = result.sublist(0, stepNumber);
        List<double> x = implicitXValueGenerator(x0, stepSize, stepNumber)
            .map((e) => e.approximate(2))
            .toList();
        List<double> fValues = [];
        double betaF = 0;
        double alphaY = 0;
        for (var i = stepNumber; i < N; i++) {
          for (var j = 0; j < stepNumber; j++) {
            double xj = x[j];
            double yj = y[j];
            fValues.add(func(xj, yj));
          }
          fValues = fValues.map((e) => e.approximate(6)).toList();
          for (var k = 0; k < stepNumber; k++) {
            betaF += beta[k] * fValues[k];
          }
          for (var l = 0; l < stepNumber; l++) {
            alphaY += alpha[l] * y[l];
          }
          double nextValueOfY =
              (stepSize * betaF.approximate(6)) - alphaY.approximate(6);
          y.add(nextValueOfY.approximate(6));
          result[i] = nextValueOfY.approximate(6);
          for (var m = 0; m < x.length; m++) {
            x[m] += stepSize;
          }
          x = x.map((e) => e.approximate(1)).toList();
          y.removeAt(0);
          betaF = 0;
          alphaY = 0;
          fValues = [];
        }
    }
    return result;
  }

  List<double> fourthOrderRungeKuttaExplicitMethod(
    double Function(double initialValueX, double initialValueY) func,
    double y0,
    double x0,
    double stepSize,
    int stepNumber,
  ) {
    List<double> result = [];
    double y = y0;
    double x = x0;
    for (int i = 0; i < stepNumber; i++) {
      double k1 = stepSize * func(x, y);
      double k2 = stepSize * func(x + 0.5 * stepSize, y + 0.5 * k1);
      double k3 = stepSize * func(x + 0.5 * stepSize, y + 0.5 * k2);
      double k4 = stepSize * func(x + stepSize, y + k3);
      y = y + (1.0 / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4);
      result.add(y);
      x += stepSize;
    }
    return result;
  }

  List<double> implicitXValueGenerator(
      double x0, double stepSize, int stepNumber) {
    List<double> xValues = [];
    for (int i = 0; i < stepNumber; i++) {
      xValues.add(x0 + i * stepSize);
    }
    return xValues;
  }

  void calculate() {
    if (_formKey.currentState?.validate() ?? false) {
      int stepNumber = int.parse(stepNumberController.text);
      double y0 = double.parse(y0Controller.text);
      double x0 = double.parse(x0Controller.text);
      double stepSize = double.parse(stepSizeController.text);
      int n = int.parse(nController.text);

      List<double> alpha = [0,0,-1,1]; // Example coefficients
      List<double> beta = [5 / 12,
    -16 / 12,
    23 / 12,
    0,]; // Example coefficients

      result = explicitLinearMultistepMethod(
        stepNumber: stepNumber,
        alpha: alpha,
        beta: beta,
        func: (x, y) => 3*(math.pow(x, 2))*y, // Example function
        y0: y0,
        x0: x0,
        stepSize: stepSize,
        N: n,
      );

      xValues = implicitXValueGenerator(x0, stepSize, n+1);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Linear Multistep Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: stepNumberController,
                    decoration: const InputDecoration(labelText: 'Step Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter step number'
                        : null,
                  ),
                  TextFormField(
                    controller: y0Controller,
                    decoration:
                        const InputDecoration(labelText: 'Initial Value y0'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter initial value y0'
                        : null,
                  ),
                  TextFormField(
                    controller: x0Controller,
                    decoration:
                        const InputDecoration(labelText: 'Initial Value x0'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter initial value x0'
                        : null,
                  ),
                  TextFormField(
                    controller: stepSizeController,
                    decoration: const InputDecoration(labelText: 'Step Size'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter step size'
                        : null,
                  ),
                  TextFormField(
                    controller: nController,
                    decoration:
                        const InputDecoration(labelText: 'Number of Steps N'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter number of steps N'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: calculate,
                    child: const Text('Calculate'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Results'),
                        Expanded(
                          child: ListView.builder(
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    'x = ${xValues[index].toStringAsFixed(2)}, y = ${result[index].toStringAsFixed(6)}'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Graph'),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(
                                      result.length,
                                      (index) => FlSpot(
                                          xValues[index], result[index])),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on double {
  double approximate(int fractionDigits) =>
      double.parse(toStringAsFixed(fractionDigits));
}
