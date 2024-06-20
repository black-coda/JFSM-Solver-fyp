import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:math_keyboard/math_keyboard.dart';
// Assuming TeXParser is in tex_parser.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Function Parser')),
        body: const FunctionInputForm(),
      ),
    );
  }
}

class FunctionInputForm extends StatefulWidget {
  const FunctionInputForm({super.key});

  @override
  _FunctionInputFormState createState() => _FunctionInputFormState();
}

class _FunctionInputFormState extends State<FunctionInputForm> {
  final MathFieldEditingController functionController =
      MathFieldEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();
  String result = "";
  double Function(double, double)? parsedFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MathField(
            controller: functionController,
            decoration:
                const InputDecoration(labelText: 'Enter function f(x, y)'),
            variables: const ['x', 'y'],
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: xController,
            decoration: const InputDecoration(labelText: 'Enter value for x'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: yController,
            decoration: const InputDecoration(labelText: 'Enter value for y'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: parseFunction,
            child: const Text('Parse Function'),
          ),
          const SizedBox(height: 16),
          Text(result),
          if (parsedFunction != null)
            ElevatedButton(
              onPressed: evaluateFunction,
              child: const Text('Evaluate Function'),
            ),
        ],
      ),
    );
  }

  void parseFunction() {
    try {
      String texInput = functionController.currentEditingValue();
      if (texInput.isEmpty) {
        setState(() {
          result = "Function input is empty.";
        });
        return;
      }
      TeXParser parser = TeXParser(texInput);
      Expression parsedExpression = parser.parse();

      parsedFunction = (double x, double y) {
        ContextModel cm = ContextModel()
          ..bindVariable(Variable('x'), Number(x))
          ..bindVariable(Variable('y'), Number(y));
        return parsedExpression.evaluate(EvaluationType.REAL, cm);
      };

      setState(() {
        result = "Function parsed successfully.";
      });
    } catch (e) {
      setState(() {
        result = "Error parsing function: $e";
      });
    }
  }

  void evaluateFunction() {
    try {
      double x = double.parse(xController.text);
      double y = double.parse(yController.text);
      double evaluatedResult = parsedFunction!(x, y);
      setState(() {
        result = "f($x, $y) = $evaluatedResult";
      });
    } catch (e) {
      setState(() {
        result = "Error evaluating function: $e";
      });
    }
  }
}
