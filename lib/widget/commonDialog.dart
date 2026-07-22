import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';
import 'button.dart';
import 'commontext.dart';

Future<void> showCommonDialog({
  required BuildContext context,
  String? title,
  String? message,
  String? secondMessage,
  String? buttonText,
  VoidCallback? onButtonTap,
  String? secondButtonText,
  VoidCallback? onSecondButtonTap,
  String? svgAsset,
  bool showCloseButton = false,
  bool buttonFilled = true,
  bool secondButtonFilled = true,
  Color svgContainer = Colors.transparent,
  Color? backgroundColor,
  Color? titleColor,
  Color? messageColor,
  double circleSize = 80,
  Color? bgColor,
  Color? closeIconColor,


  /// NEW PARAM
  bool barrierDismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible, // 👈 ENABLE / DISABLE outside tap dismiss
    builder: (context) {
      return SafeArea(
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          backgroundColor: bgColor??ThemeProvider.alertColor,
          content: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  showCloseButton ? SizedBox.shrink() : SizedBox(height: 2.h),

                if (showCloseButton)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close, color: closeIconColor??ThemeProvider.whiteColor),
                    ),
                  ),

                if (svgAsset != null) ...[
                  circularSvg(
                    svgAsset: svgAsset,
                    size: circleSize,
                    color: svgContainer,
                  ),
                  SizedBox(height: 2.h),
                ],

                if (title != null) ...[
                  CommonTextWidget(
                    textAlign: TextAlign.center,
                    heading: title.tr,
                    fontSize: Utils.responsiveFontSize(context, 22.sp),
                    fontWeight: FontWeight.w600,
                    color: titleColor??ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                  ),
                  SizedBox(height: 2.h),
                ],

                if (message != null) ...[
                  CommonTextWidget(
                    textAlign: TextAlign.center,
                    heading: message.tr,
                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                    fontWeight: FontWeight.w400,
                    color: messageColor??ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                  ),
                  SizedBox(height: 2.h),
                ],

                if (secondMessage != null) ...[
                  CommonTextWidget(
                    textAlign: TextAlign.center,
                    heading: secondMessage.tr,
                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                    fontWeight: FontWeight.w500,
                    color: ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                  ),
                  SizedBox(height: 2.h),
                ],

                if (buttonText != null && secondButtonText == null) ...[
                  Button(
                    onPressed: onButtonTap ?? () => Navigator.pop(context),
                    title: buttonText.tr,
                  ),
                  SizedBox(height: 2.h),
                ],

                if (buttonText != null && secondButtonText != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          onPressed: onButtonTap ??
                                  () => Navigator.pop(context),
                          title: buttonText.tr,
                          filledColor: buttonFilled,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Button(
                          onPressed: onSecondButtonTap ??
                                  () => Navigator.pop(context),
                          title: secondButtonText.tr,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ],
            ),
          ),
        ),
      )
      );
    },
  );
}


Widget circularSvg({required String svgAsset, double? size, Color? color}) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color ?? Colors.transparent, // if null → transparent
    ),
    padding: const EdgeInsets.all(8),
    // optional spacing
    child: SvgPicture.asset(svgAsset, fit: BoxFit.contain),
  );





}
