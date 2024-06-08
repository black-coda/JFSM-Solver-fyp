import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/app/controller/alpha_and_beta.controller.dart';
import 'package:frontend/src/app/controller/is_imp_or_exp_controller.dart';
import 'package:frontend/src/app/controller/key.dart';
import 'package:frontend/src/app/controller/method_implementation_controller.dart';
import 'package:frontend/src/app/controller/step_number_controller.dart';
import 'package:frontend/src/app/view/screens/step_number_screen.dart';
import 'package:frontend/src/app/view/screens/stepper_screen.dart';
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

  final List<TextEditingController> correctorAlphaController = [];
  final List<TextEditingController> correctorBetaController = [];

  late TextEditingController _correctorStepNumberController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _correctorStepNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _correctorStepNumberController.dispose();
    for (var controllers in alphaController) {
      controllers.dispose();
    }
    for (var controllers in betaController) {
      controllers.dispose();
    }

    for (var controllers in correctorAlphaController) {
      controllers.dispose();
    }
    for (var controllers in correctorBetaController) {
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
              ref.watch(correctorStepNumberStateProvider);

              int itemCount = ref.watch(stepNumberStateProvider.notifier).state;
              int correctorItemCount =
                  ref.watch(correctorStepNumberStateProvider.notifier).state;
              debugPrint("itemCount.log(): $itemCount");

              while (alphaController.length < itemCount + 1) {
                alphaController.add(TextEditingController());
              }
              while (betaController.length < itemCount + 1) {
                betaController.add(TextEditingController());
              }

              while (correctorAlphaController.length < correctorItemCount + 1) {
                correctorAlphaController.add(TextEditingController());
              }
              while (correctorBetaController.length < correctorItemCount + 1) {
                correctorBetaController.add(TextEditingController());
              }
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        "Enter your Alpha and Beta values, if you are using Predictor-Corrector Method, enter the predictor values"),
                    _formGrid(context, itemCount, "α", alphaController),
                    const SizedBox(height: 36),
                    _formGrid(context, itemCount, "β", betaController),
                    const SizedBox(height: 44),
                    ButtonBar(
                      children: [
                        const Text("Implicit Predictor Corrector Method: "),
                        //! implicit PE switch
                        Switch(
                          value: ref
                              .read(isImplicitPredictorCorrectorMethodProvider),
                          onChanged: (value) {
                            //! invalidate the prvious provider values
                            ref.invalidate(correctorAlphaProvider);
                            ref.read(alphaProvider.notifier).state = [0];
                            ref.read(betaProvider.notifier).state = [0];
                            ref.read(correctorAlphaProvider.notifier).state = [
                              0
                            ];
                            ref.read(correctorBetaProvider.notifier).state = [
                              0
                            ];

                            ref
                                .read(isImplicitPredictorCorrectorMethodProvider
                                    .notifier)
                                .state = value;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible:
                          ref.watch(isImplicitPredictorCorrectorMethodProvider),
                      child: Column(
                        children: [
                          const Text(
                            "Input corrector ɑβ values",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          StepNumberScreen(
                            stepProvider: correctorStepNumberStateProvider,
                            controller: _correctorStepNumberController,
                          ),
                          _formGrid(context, correctorItemCount, "α",
                              correctorAlphaController),
                          const SizedBox(height: 8),
                          _formGrid(context, correctorItemCount, "β",
                              correctorBetaController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    InkWell(
                      onTap: () {
                        debugPrint(
                            "is form valid -> ${_formKey.currentState!.validate()}");
                        List<double> alphas = [];
                        List<double> betas = [];

                        List<double> correctorAlpha = [];
                        List<double> correctorBeta = [];

                        if (_formKey.currentState!.validate()) {
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

                          // assign values of beta,alpha to respective provider
                          ref.read(alphaProvider.notifier).state = alphas;
                          ref.read(betaProvider.notifier).state = betas;

                          //! corrector validator

                          if (ref.watch(
                              isImplicitPredictorCorrectorMethodProvider)) {
                            //! add alpha corrector values to corrector-alpha list
                            for (TextEditingController textEditingController
                                in correctorAlphaController) {
                              String text = textEditingController.text
                                  .calculateFromString();
                              double? toDouble = double.tryParse(text);
                              if (toDouble != null) {
                                correctorAlpha.add(toDouble);
                              }
                            }

                            //! add beta corrector values to corrector-beta list
                            for (TextEditingController textEditingController
                                in correctorBetaController) {
                              String text = textEditingController.text
                                  .calculateFromString();
                              double? toDouble = double.tryParse(text);
                              if (toDouble != null) {
                                correctorBeta.add(toDouble);
                              }
                            }
                            ref.read(correctorAlphaProvider.notifier).state =
                                correctorAlpha;
                            ref.read(correctorBetaProvider.notifier).state =
                                correctorBeta;
                          }
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Explicit Predictor
      ],
    );
  }

  SizedBox _formGrid(
      BuildContext context, int itemCount, String greekValue, List controller) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.15,
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
