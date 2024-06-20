import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:math_keyboard/math_keyboard.dart';

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
  MathFieldEditingController functionController = MathFieldEditingController();
  String result = "";

  double Function(double, double)? parsedFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          MathField(
            controller: functionController,
            decoration:
                const InputDecoration(labelText: 'Enter function f(x, y)'),
            variables: const ['x', 'y'],
            autofocus: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              try {
                String inputFunction = functionController.currentEditingValue();
                log(inputFunction.runtimeType.toString());
                final mathExpression = TeXParser(inputFunction).parse();
                log(mathExpression.toString());
                parsedFunction = parseFunction(mathExpression);

                final answer = parsedFunction!(5, 6);
                log(answer.toString(), name: 'answer');

                setState(() {
                  result = "Function parsed successfully.";
                });
              } catch (e) {
                setState(() {
                  result = "Error parsing function: $e";
                });
                log(e.toString());
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
}
