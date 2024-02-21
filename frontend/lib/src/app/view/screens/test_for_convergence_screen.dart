import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';

class TestForConvergence extends StatelessWidget {
  const TestForConvergence({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, child) {
              ref.watch(stepNumberStateProvider);
              int itemCount = ref.watch(stepNumberStateProvider.notifier).state;
              debugPrint("itemCount.log(): $itemCount");
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 24.0,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: itemCount + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: "α-$index",
                              border: const OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 24.0,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: itemCount + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: "β-$index",
                            border: const OutlineInputBorder(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
