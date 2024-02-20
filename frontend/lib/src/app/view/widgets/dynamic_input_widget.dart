import 'package:flutter/material.dart';

class NumericalInputField extends StatelessWidget {
  const NumericalInputField({
    super.key,
    required this.textInputType,
    required this.prefIcon,
    this.suffIcon,
    required this.controller,
    required this.textInputAction,
    required this.focusNode,
    required this.labelText,
    this.validator,
    this.hintText,
    this.onChanged,
  });

  final TextInputType textInputType;
  final IconData prefIcon;
  final IconData? suffIcon;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Text labelText;
  final String? Function(String?)? validator;
  final String? hintText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      focusNode: focusNode,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: const OutlineInputBorder(
          // Make border edge circular
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        border: const OutlineInputBorder(
          // Make border edge circular
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        prefixIcon: Icon(prefIcon),
        hintText: hintText,
        label: labelText,
        suffix: Icon(suffIcon),
      ),
    );
  }
}
