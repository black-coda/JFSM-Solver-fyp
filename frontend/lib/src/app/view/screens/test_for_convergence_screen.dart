import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/app/view/screens/dashboard_screen.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';
import 'package:frontend/src/utils/extension/format_string_to_number.dart';

class TestForConvergence extends StatefulWidget {
  const TestForConvergence({super.key});

  @override
  State<TestForConvergence> createState() => _TestForConvergenceState();
}

class _TestForConvergenceState extends State<TestForConvergence> {
  final List<TextEditingController> alphaController = [];
  final List<TextEditingController> betaController = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var controllers in alphaController) {
      controllers.dispose();
    }
    for (var controllers in betaController) {
      controllers.dispose();
    }
    super.dispose();
  }

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

              while (alphaController.length < itemCount + 1) {
                alphaController.add(TextEditingController());
              }
              while (betaController.length < itemCount + 1) {
                betaController.add(TextEditingController());
              }
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }

                                try {
                                  double.parse(value.calculateFromString());
                                } catch (e) {
                                  return "Please enter a valid number";
                                }
                                return null;
                              },
                              controller: alphaController[index],
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field cannot be empty';
                              }
                              debugPrint("value.log(): $value");
                              try {
                                double.parse(value.calculateFromString());
                              } catch (e) {
                                return "Please enter a valid number";
                              }
                              return null;
                            },
                            controller: betaController[index],
                            decoration: InputDecoration(
                              labelText: "β-$index",
                              border: const OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        formKey.currentState!.validate().log();
                        if (formKey.currentState!.validate()) {
                          final List<double> alphas = alphaController.map(
                            (controller) {
                              try {
                                double.parse(
                                  controller.text.calculateFromString(),
                                );
                              } catch (e) {
                                e.log();
                              }
                            },
                          ).toList() as List<double>;

                          final betas = betaController.map(
                            (controller) {
                              try {
                                double.parse(controller.text);
                              } catch (e) {
                                e.log();
                              }
                            },
                          ).toList() as List<double>;

                          alphas.log();
                          betas.log();

                          ref.read(alphaProvider.notifier).state = alphas;
                          ref.read(betaProvider.notifier).state = betas;
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
