import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/is_imp_or_exp_controller.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/app/view/widgets/dynamic_input_widget.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';
import 'package:frontend/src/utils/validators/validators.dart';

class ImplicitOrExplicitScreen extends ConsumerStatefulWidget {
  const ImplicitOrExplicitScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImplicitOrExplicitScreenState();
}

class _ImplicitOrExplicitScreenState
    extends ConsumerState<ImplicitOrExplicitScreen> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isImplicitOrExplicit = ref.watch(isImplicitOrExplicitProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Implicit"),
          Switch(
            value: isImplicitOrExplicit,
            onChanged: (value) {
              ref.watch(isImplicitOrExplicitProvider.notifier).state = value;
            },
          ),
          Text("$isImplicitOrExplicit"),
        ],
      ),
    );
  }
}
