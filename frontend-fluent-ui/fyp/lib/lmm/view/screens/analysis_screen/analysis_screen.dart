// ignore_for_file: unused_local_variable
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fyp/lmm/view/screens/analysis_screen/parameters_collector.dart';
import 'package:fyp/utils/constant/konstant.dart';
// ignore: unused_import
import 'package:fyp/utils/devtool.dart';
import 'package:go_router/go_router.dart';

import 'controller/navigation_pane_controller.dart';

class AnalysisModuleScreen extends ConsumerStatefulWidget {
  const AnalysisModuleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnalysisModuleScreenState();
}

class _AnalysisModuleScreenState extends ConsumerState<AnalysisModuleScreen> {
  @override
  Widget build(BuildContext context) {
    int selectedPane = ref.watch(selectedPaneProvider);

    List<NavigationPaneItem> item = List.generate(
      4,
      (index) => PaneItem(
        icon: const Icon(FluentIcons.add_friend),
        body: Center(
          child: Text(index.toString()),
        ),
      ),
    );

    List<NavigationPaneItem> items = [
      PaneItem(
        icon: const Icon(FluentIcons.calculator_delta),
        body: const ParameterCollectorScreen(),
        title: const Text("Parameter Collector"),
      ),
      PaneItem(
          icon: const Icon(FluentIcons.calculated_table),
          title: const Text("Analysis Result"),
          body: const Text2()),
      PaneItem(
        icon: const Icon(FluentIcons.analytics_logo),
        body: const TestTEr(),
      ),
    ];
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text(
          "Navigation",
          style: TextStyle(color: Colors.warningPrimaryColor),
        ),
      ),
      pane: NavigationPane(
        selected: selectedPane,
        items: items,
        onChanged: _onTap,
      ),
    );
  }

  void _onTap(int index) {
    ref.watch(selectedPaneProvider.notifier).setIndexPosition(index);

    switch (index) {
      case 0:
        context.goNamed(Konstant.parameterCollector);

      case 1:
        context.goNamed(Konstant.test2);

      case 2:
        context.goNamed(Konstant.test1);

      default:
    }
  }
}

class TestTEr extends StatelessWidget {
  const TestTEr({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("Mod 2"),
      ],
    );
  }
}
