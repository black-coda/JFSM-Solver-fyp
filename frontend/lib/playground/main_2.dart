import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Function Parser')),
        body: const FunctionInputWidget(),
      ),
    );
  }
}

class FunctionInputWidget extends StatefulWidget {
  const FunctionInputWidget({super.key});

  @override
  _FunctionInputWidgetState createState() => _FunctionInputWidgetState();
}

class _FunctionInputWidgetState extends State<FunctionInputWidget> {
  TextEditingController functionController = TextEditingController();
  String result = "";

  double Function(double, double)? parsedFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: functionController,
            decoration:
                const InputDecoration(labelText: 'Enter function f(x, y)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              try {
                String inputFunction = functionController.text;
                parsedFunction = parseFunction(inputFunction);
                final answer = parsedFunction!(0, (math.pi / 6));
                log(answer.toString());
                setState(() {
                  result = "Function parsed successfully.";
                });
              } catch (e) {
                setState(() {
                  result = "Error parsing function: $e";
                });
              }
            },
            child: const Text('Parse Function'),
          ),
          const SizedBox(height: 16),
          Text(result),
        ],
      ),
    );
  }

  double Function(double, double)? parseFunction(String input) {
    // Parse the input function
    Parser p = Parser();
    Expression exp = p.parse(input);
    log(exp.toString());

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
}
