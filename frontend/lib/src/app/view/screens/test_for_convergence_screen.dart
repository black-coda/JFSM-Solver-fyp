import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestForConvergence extends ConsumerStatefulWidget {
  const TestForConvergence({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TestForConvergenceState();
}

class _TestForConvergenceState extends ConsumerState<TestForConvergence> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: [
              TextFormField(),
              TextFormField(),
              TextFormField(),
            ],
          ),
        ),
      ],
    );
  }
}
