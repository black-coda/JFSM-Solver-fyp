import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ODE Solver'),
        ),
        body: const FunctionInput(),
      ),
    );
  }
}

class FunctionInput extends StatefulWidget {
  const FunctionInput({super.key});

  @override
  _FunctionInputState createState() => _FunctionInputState();
}

class _FunctionInputState extends State<FunctionInput> {
  final TextEditingController _controller = TextEditingController();
  late Expression _expression;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter function (e.g., x*sin(x))',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a function';
                }
                try {
                  _expression = Expression.parse(value);
                } catch (e) {
                  return 'Invalid function';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                func(double x, double y) =>
                    evaluateExpression(_expression, x, y);
                print('Function evaluated at (2, 3): ${func(2, 3)}');
                // Now you can use `func` as needed in your ODE solver
              }
            },
            child: const Text('Evaluate Function'),
          ),
        ],
      ),
    );
  }

  double evaluateExpression(Expression expression, double x, double y) {
    const evaluator = ExpressionEvaluator();
    final variables = {'x': x, 'y': y};
    return evaluator.eval(expression, variables) as double;
  }
}
