
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textInputStyle;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final bool showReadOnlyColor;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? ontap;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  // Add inputFormatters parameter
  final Color? borderColor;
  final TextInputAction? textInputAction;
  final int? maxLines; // ✅ optional max lines
  final int? maxLength; // ✅ optional max lines

  const CustomTextField({
    super.key,
    this.ontap,
    this.hintText,
    this.hintStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xFF697D95),
      fontFamily: 'regular',
    ),
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.readOnly = false,
    this.showReadOnlyColor = true,
    this.textInputStyle,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.borderColor,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction ?? TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: ThemeProvider.primary,
      onFieldSubmitted: onFieldSubmitted,
      textAlignVertical: TextAlignVertical.center,
      onTap: ontap,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      style: textInputStyle,
      inputFormatters: inputFormatters ?? [
        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
        DiacriticsRemoverFormatter(),
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: (readOnly && showReadOnlyColor)
            ? Colors.grey.shade400 // lighter background for disabled
            : ThemeProvider.whiteColor,        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 35,   // adjust value
          minHeight: 35,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey.withOpacity(0.4),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ThemeProvider.primary,
            width: 1.0,
          ),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.all(15.0),
        hintText: hintText?.tr,
        hintStyle: TextStyle(
        fontFamily: 'Montserrat',
        color: ThemeProvider.hintText,
        fontSize: Utils.responsiveFontSize(context, 16.sp),
          fontWeight: FontWeight.w500
      ),
        counterStyle: TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class DiacriticsRemoverFormatter extends TextInputFormatter {
  static const Map<String, String> _diacriticsMap = {
    // Romanian
    'ă': 'a', 'â': 'a', 'î': 'i', 'ș': 's', 'ş': 's', 'ț': 't', 'ţ': 't','Æ':'A','æ':'a',
    'Ă': 'A', 'Â': 'A', 'Î': 'I', 'Ș': 'S', 'Ş': 'S', 'Ț': 'T', 'Ţ': 'T',

    // a
    'á': 'a', 'à': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
    'Á': 'A', 'À': 'A', 'Ä': 'A', 'Ã': 'A', 'Å': 'A',

    // e
    'é': 'e', 'è': 'e', 'ë': 'e', 'ê': 'e',
    'É': 'E', 'È': 'E', 'Ë': 'E', 'Ê': 'E',

    // i
    'í': 'i', 'ì': 'i', 'ï': 'i',
    'Í': 'I', 'Ì': 'I', 'Ï': 'I',

    // o
    'ó': 'o', 'ò': 'o', 'ö': 'o', 'ô': 'o', 'õ': 'o',
    'Ó': 'O', 'Ò': 'O', 'Ö': 'O', 'Ô': 'O', 'Õ': 'O',

    // u
    'ú': 'u', 'ù': 'u', 'ü': 'u',
    'Ú': 'U', 'Ù': 'U', 'Ü': 'U',

    // others
    'ç': 'c', 'Ç': 'C',
    'ñ': 'n', 'Ñ': 'N',
  };
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final convertedText = newValue.text.split('').map((char) => _diacriticsMap[char] ?? char).join();
    return newValue.copyWith(text: convertedText,
      // selection: TextSelection.collapsed(offset: convertedText.length),
      selection: newValue.selection,
    );
  }
}



