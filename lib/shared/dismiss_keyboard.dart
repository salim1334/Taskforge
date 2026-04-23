import 'package:flutter/material.dart';

/// Wrapper widget that dismisses keyboard when tapping outside of text fields
class DismissKeyboard extends StatelessWidget {
  final Widget child;
  final bool dismissOnTap;

  const DismissKeyboard({
    super.key,
    required this.child,
    this.dismissOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissOnTap ? () => _dismissKeyboard(context) : null,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }

  void _dismissKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

/// Extension method for easier usage
extension KeyboardDismissal on BuildContext {
  void dismissKeyboard() {
    final FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
