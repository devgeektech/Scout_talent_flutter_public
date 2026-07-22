
import 'package:flutter/material.dart';

const typeTheme = Typography.whiteMountainView;

class ThemeProvider {
  static const appColor = Color(0xFFF3CB8E);
  static Color blackColor = const Color(0xFF000000);
  //static Color bgColor = const Color(0xFF121317);
  static Color bgColor = const Color(0xFF000000);
  static Color primary = const Color(0xFFF97316);
  static Color hintText = const Color(0xFF5A5A5A);
  static Color alertColor = const Color(0xFF242529);
  static Color navyBlue = const Color(0xFF0A012E);
  static Color textColor = const Color(0xFF949494);
  static Color closeIcon = const Color(0xFF828282);
  static Color filterIconColor = const Color(0xFF1FA0FE);
  static Color greenColor = const Color(0xFF00C951);
  static Color slightlyColor = const Color(0xFFDCFCE7);
  static Color darkGreenColor = const Color(0xFF166534);
  static Color blueColor = const Color(0xFF4E63EE);
  static Color redColor = const Color(0xFFFB2C36);
  static Color unselectedFilter = const Color(0xFF787878);
  static Color cardColor = const Color(0xfffafafa1a);
  static Color ratingTrack = const Color(0xFFFFF0E5);
  static Color yellowish = const Color(0xFFFFD03C);
  static Color whitish = const Color(0xFFD9D9D9);
  static Color gray = const Color(0xFF808080);
  static Color whiteChat = const Color(0xFFF2F7FB);


  static const secondaryAppColor = Color(0xFF0C25AE);
  static const whiteColor = Colors.white;
  static const titleStyle = TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.whiteColor);
}

TextTheme txtTheme = Typography.whiteMountainView.copyWith(
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  bodyMedium: typeTheme.bodyLarge?.copyWith(fontSize: 14),
  displayLarge: typeTheme.bodyLarge?.copyWith(fontSize: 32),
  displayMedium: typeTheme.bodyLarge?.copyWith(fontSize: 28),
  displaySmall: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  headlineMedium: typeTheme.bodyLarge?.copyWith(fontSize: 21),
  headlineSmall: typeTheme.bodyLarge?.copyWith(fontSize: 18),
  titleLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  titleMedium: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  titleSmall: typeTheme.bodyLarge?.copyWith(fontSize: 21),
);

ThemeData light = ThemeData(fontFamily: 'regular', primaryColor: ThemeProvider.appColor, secondaryHeaderColor: ThemeProvider.secondaryAppColor, disabledColor: const Color(0xFFBABFC4), brightness: Brightness.light, hintColor: const Color(0xFF9F9F9F), cardColor: ThemeProvider.appColor, textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.appColor)), textTheme: txtTheme, colorScheme: const ColorScheme.light(primary: ThemeProvider.appColor, secondary: ThemeProvider.secondaryAppColor).copyWith(surface: const Color(0xFFF3F3F3)).copyWith(error: const Color(0xFFE84D4F)));

ThemeData dark = ThemeData(fontFamily: 'regular', primaryColor: ThemeProvider.blackColor, secondaryHeaderColor: const Color(0xFF009f67), disabledColor: const Color(0xffa2a7ad), brightness: Brightness.dark, hintColor: const Color(0xFFbebebe), cardColor: Colors.black, textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.blackColor)), textTheme: txtTheme, colorScheme: const ColorScheme.dark(primary: Colors.black, secondary: Color(0xFFffbd5c)).copyWith(surface: const Color(0xFF343636)).copyWith(error: const Color(0xFFdd3135)));
