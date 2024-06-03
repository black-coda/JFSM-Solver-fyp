import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/lmm/presenter/controllers/step_number_controller.dart';
import 'package:fyp/lmm/view/screens/analysis_screen/analysis_screen.dart';
import 'package:fyp/utils/devtool.dart';
import 'package:go_router/go_router.dart';

class ParameterCollectorScreen extends ConsumerStatefulWidget {
  const ParameterCollectorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParameterCollectorScreenState();
}

class _ParameterCollectorScreenState
    extends ConsumerState<ParameterCollectorScreen> {
  late TextEditingController _stepController;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _stepController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.30,
              child: InfoLabel(
                label: "Enter the step number",
                labelStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                child: TextFormBox(
                  controller: _stepController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a value';
                    }
                    if (int.tryParse(value) == null) {
                      return "Step number must be an Integer";
                    } else if (int.parse(value) <= 0) {
                      return "Step number must be greater than zero";
                    }

                    return null;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(FluentIcons.test_step),
                  ),
                  placeholder:
                      'Enter the step number of the linear multistep method',
                  decoration: const BoxDecoration(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            //! Step number button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  child: const Text("Submit"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final locator = GoRouter.of(context);
                      ("valid").log();
                      int value = int.parse(_stepController.text);
                      // set step number value to provider
                      ref.watch(stepNumberStateProvider.notifier).state = value;

                      locator.pushNamed("coll");
                      // ref
                      //     .watch(selectedPaneProvider.notifier)
                      //     .update((state) => state + 1);
                    }
                  },
                ),
                const SizedBox(width: 20),
                Button(
                  child: const Text("Me"),
                  onPressed: () {
                    final locator = GoRouter.of(context);
                    locator.pushNamed("coll");
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextScreen extends ConsumerWidget {
  const TextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        Text(
          "data",
          style: TextStyle(color: Colors.white),
        ),
        Text("data"),
        Text("data"),
      ],
    );
  }
}

class Text2 extends ConsumerWidget {
  const Text2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ScaffoldPage(
      header: Text("Header"),
    );
  }
}
