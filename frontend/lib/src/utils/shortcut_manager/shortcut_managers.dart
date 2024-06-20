import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class PrintIntent extends Intent {
  const PrintIntent();
}

class PrintAction extends Action<PrintIntent> {
  @override
  void invoke(covariant PrintIntent intent) {
    log('PrintAction invoked');
    // TODO: Print action
    
  }
}



/// A ShortcutManager that logs all keys that it handles.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      log('Handled shortcut $event in $context');
    }
    return result;
  }
}

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    log('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);

    return null;
  }
}
