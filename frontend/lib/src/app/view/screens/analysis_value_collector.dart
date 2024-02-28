import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/key.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/app/view/screens/dashboard_screen.dart';
import 'package:frontend/src/utils/devtool/devtool.dart';
import 'package:frontend/src/utils/extension/format_string_to_number.dart';

class AnalysisValueCollectorScreen extends StatefulWidget {
  const AnalysisValueCollectorScreen({super.key});

  @override
  State<AnalysisValueCollectorScreen> createState() =>
      _AnalysisValueCollectorScreenState();
}

class _AnalysisValueCollectorScreenState
    extends State<AnalysisValueCollectorScreen> {
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
                    _formGrid(context, itemCount, "α", alphaController),
                    const SizedBox(height: 8),
                    _formGrid(context, itemCount, "β", betaController),
                    InkWell(
                      onTap: () {
                        debugPrint(
                            "is form valid -> ${formKey.currentState!.validate()}");
                        List<double> alphas = [];
                        List<double> betas = [];
                        if (formKey.currentState!.validate()) {
                          ref
                              .watch(
                                  isAnalysisCollectorFormValidProvider.notifier)
                              .state = true;
                          for (TextEditingController textEditingController
                              in alphaController) {
                            String text = textEditingController.text
                                .calculateFromString();
                            double? toDouble = double.tryParse(text);
                            if (toDouble != null) {
                              alphas.add(toDouble);
                            }
                          }

                          for (TextEditingController textEditingController
                              in betaController) {
                            String text = textEditingController.text
                                .calculateFromString();
                            double? toDouble = double.tryParse(text);
                            if (toDouble != null) {
                              betas.add(toDouble);
                            }
                          }
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

  SizedBox _formGrid(
      BuildContext context, int itemCount, String greekValue, List controller) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.25,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 24.0,
          childAspectRatio: 2.5,
        ),
        itemCount: itemCount + 1,
        itemBuilder: (BuildContext context, int index) {
          return TextFormField(
            validator: _formFieldValidator,
            controller: controller[index],
            decoration: InputDecoration(
              labelText: "$greekValue-$index",
              // border: const OutlineInputBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
              // ),
            ),
          );
        },
      ),
    );
  }

  String? _formFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    try {
      double.parse(value.calculateFromString());
    } catch (e) {
      return "Please enter a valid number";
    }
    return null;
  }
}
