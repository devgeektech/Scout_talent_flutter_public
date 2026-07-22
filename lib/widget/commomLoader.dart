import 'package:flutter/material.dart';
import 'package:scouttalent2/utils/theme.dart';
// for appColor

class LoaderDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          color: ThemeProvider.primary,   // your app's primary color
          strokeWidth: 3,
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
