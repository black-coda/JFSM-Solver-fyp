import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/app/view/widgets/dynamic_input_widget.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';
import 'package:frontend/src/utils/validators/validators.dart';

class StepNumberScreen extends ConsumerStatefulWidget {
  StepNumberScreen({super.key, required this.stepProvider, required this.controller});

  final StateProvider<int> stepProvider;
 TextEditingController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StepNumberScreenState();
}

class _StepNumberScreenState extends ConsumerState<StepNumberScreen> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // widget.controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // widget.controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: NumericalInputField(
        textInputType: TextInputType.number,
        prefIcon: Icons.vpn_key_rounded,
        controller: widget.controller,
        textInputAction: TextInputAction.done,
        focusNode: _focusNode,
        labelText: const Text("K-step"),
        validator: Validator.stepNumberValidator,
        onChanged: (value) {
          if (value.isEmpty) {
            value = 0.toString();
          }

          ref.watch(widget.stepProvider.notifier).state = int.parse(value);

          ref.read(widget.stepProvider.notifier).state.log();
        },
      ),
    );
  }
}
