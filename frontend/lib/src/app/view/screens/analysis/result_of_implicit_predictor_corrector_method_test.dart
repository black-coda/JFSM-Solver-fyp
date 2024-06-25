import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/is_imp_or_exp_controller.dart';
import 'package:frontend/src/app/controller/method_implementation_controller.dart';

class ImplicitPEAnalysisResultScreen extends ConsumerWidget {
  const ImplicitPEAnalysisResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methodProviderValues = ref.watch(analysisProvider);
    final peMethodProviderValues = ref.watch(correctorAnalysisProvider);

    final isConsistent = methodProviderValues.isConsistent();
    final ispeConsistent = peMethodProviderValues.isConsistent();
    final errorConstant = methodProviderValues.orderAndErrorConstant();
    final peErrorConstant = peMethodProviderValues.orderAndErrorConstant();
    final isZeroStable = methodProviderValues.isZeroStable();
    final ispeZeroStable = peMethodProviderValues.isZeroStable();
    final isConvergent = methodProviderValues.isConvergent();
    final ispeConvergent = peMethodProviderValues.isConvergent();

    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Method Result',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ref.watch(isImplicitPredictorCorrectorMethodProvider))
                const SizedBox(height: 16),
              Text(
                "Analysis for Predictor Method",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              const Divider(),
              _buildPropertyRow(
                  context, 'Is consistent', isConsistent.toString()),
              _buildPropertyRow(context, 'Order', errorConstant.$1.toString()),
              _buildPropertyRow(
                  context, 'Error Constant', errorConstant.$2.toString()),
              _buildPropertyRow(
                  context, 'Is Zero Stable', isZeroStable.toString()),
              _buildPropertyRow(
                  context, 'Is Convergent', isConvergent.toString()),
              if (ref.watch(isImplicitPredictorCorrectorMethodProvider))
                const Divider(),
              const SizedBox(height: 16),
              Text(
                "Analysis for Corrector Method",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              const Divider(),
              _buildPropertyRow(context, 'Is corrector method consistent',
                  ispeConsistent.toString()),
              _buildPropertyRow(context, 'Order', errorConstant.$1.toString()),
              _buildPropertyRow(context, 'Corrector Error Constant',
                  peErrorConstant.$2.toString()),
              _buildPropertyRow(context, 'Is corrector method Zero Stable',
                  ispeZeroStable.toString()),
              _buildPropertyRow(context, 'Is corrector method Convergent',
                  ispeConvergent.toString()),
            ],
          ),
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
