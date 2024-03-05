import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/method_implementation_controller.dart';


class AnalysisResultScreen extends ConsumerWidget {
  const AnalysisResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methodProviderValues = ref.watch(methodImplementationProvider);

    final isConsistent = methodProviderValues.isConsistent();
    debugPrint("yes -> $isConsistent");
    final errorConstant = methodProviderValues.orderAndErrorConstant();
    final isZeroStable = methodProviderValues.isZeroStable();
    debugPrint("errorConstant -> $errorConstant");

    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Analysis Method Result",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Table(
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(),
                      children: [
                        Text(
                          "Property",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          "Value",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          "Is consistent",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        Text(
                          isConsistent.toString(),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Order",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          errorConstant.$1.toString(),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Error Constant",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          errorConstant.$2.toString(),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Is Zero Stable",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          isZeroStable.toString(),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
