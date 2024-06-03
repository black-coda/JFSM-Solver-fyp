import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ODE Solver'),
        ),
        body: FunctionInput(),
      ),
    );
  }
}

class FunctionInput extends StatefulWidget {
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
              decoration: InputDecoration(
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                func(double x, double y) =>
                    evaluateExpression(_expression, x, y);
                print('Function evaluated at (2, 3): ${func(2, 3)}');
                // Now you can use `func` as needed in your ODE solver
              }
            },
            child: Text('Evaluate Function'),
          ),
        ],
      ),
    );
  }

  double evaluateExpression(Expression expression, double x, double y) {
    final evaluator = const ExpressionEvaluator();
    final variables = {'x': x, 'y': y};
    return evaluator.eval(expression, variables) as double;
  }
}
