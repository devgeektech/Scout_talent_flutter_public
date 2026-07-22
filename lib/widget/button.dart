import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool isLoading;
  final Color? color; // Optional color parameter
  final double? fontSize; // Optional font size parameter
  final bool filledColor;
  final double? height;
  final double? width;

  const Button({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.color, // Default is null, meaning it will use the default color
    this.fontSize, // Optional font size parameter
    this.filledColor = true,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adjust width based on screen size
      width: width??Get.width,
      height: height ?? (GetPlatform.isIOS ? 7.h : 6.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (filledColor)
          BoxShadow(
            color: Colors.white.withOpacity(0.25),
            offset: const Offset(0, 0),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: WidgetStateProperty.all(Colors.transparent),

          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: filledColor
                    ? Colors.transparent
                    : ThemeProvider.primary, // BORDER when not filled
                width: 1.5,
              ),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            filledColor
                ? (color ?? ThemeProvider.primary) // filled
                : Colors.transparent, // outlined
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        // Disable the button when loading
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          title.tr,
          style: TextStyle(
            fontSize: fontSize ?? Utils.responsiveFontSize(context, 16.sp),
            // Use the provided font size or default to 16.sp
            color: filledColor
                ? Colors.white
                : ThemeProvider.primary, // Text color for outlined
            fontWeight: FontWeight.w700,
            fontFamily: "Montserrat",
          ),
        ),
      ),
    );
  }
}

