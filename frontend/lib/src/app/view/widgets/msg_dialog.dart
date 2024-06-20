import 'package:flutter/material.dart';

class MsgDialog {
  static Future<void> displayDialog({
    required BuildContext context,
    VoidCallback? onPressed,
    required String title,
    String? subtitle,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => const AlertDialog.adaptive(),
    );
  }
}
