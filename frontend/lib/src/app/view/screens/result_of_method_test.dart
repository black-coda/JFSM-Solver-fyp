import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/method_implementation_controller.dart';

class AnalysisResultScreen extends ConsumerWidget {
  const AnalysisResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methodProviderValues = ref.watch(analysisProvider);
    final isConsistent = methodProviderValues.isConsistent();
    final errorConstant = methodProviderValues.orderAndErrorConstant();
    final isZeroStable = methodProviderValues.isZeroStable();
    final isConvergent = methodProviderValues.isConvergent();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Method Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPropertyRow(
                context, 'Is consistent', isConsistent.toString()),
            _buildPropertyRow(context, 'Order', errorConstant.$1.toString()),
            _buildPropertyRow(
                context, 'Error Constant', errorConstant.$2.toString()),
            _buildPropertyRow(
                context, 'Is Zero Stable', isZeroStable.toString()),
            _buildPropertyRow(
                context, 'Is Convergent', isConvergent.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyRow(
      BuildContext context, String propertyName, String propertyValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            propertyName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            propertyValue.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
