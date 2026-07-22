import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/verification_screen/verification_screen_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';

class VerificationScreenPage extends StatefulWidget {
  const VerificationScreenPage({super.key});

  @override
  State<VerificationScreenPage> createState() => _VerificationScreenPageState();
}

class _VerificationScreenPageState extends State<VerificationScreenPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationScreenLogic>(
        builder: (controller) {
      return Scaffold(
        backgroundColor: ThemeProvider.bgColor,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: ThemeProvider.bgColor,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: ThemeProvider.whiteColor,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                CommonTextWidget(
                  textAlign: TextAlign.start,
                  heading: "OTP Verification".tr,
                  fontSize: Utils.responsiveFontSize(context, 22.sp),
                  fontWeight: FontWeight.w600,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(
                  height: 2.h,
                ),

                CommonTextWidget(
                  lineHeight: 1.3,
                  textAlign: TextAlign.start,
                  heading: "We’ve Sent an OTP to Your Email — Please Enter It Below.".tr,
                  fontSize: Utils.responsiveFontSize(context, 17.sp),
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(
                  height: 3.h,
                ),
                pinArea1(context,controller),
                SizedBox(height: 3.h),
                Button(
                    onPressed: () {


                      final pin = controller.pinController.text.trim();

                      if (pin.length == 6 && !pin.contains(' ') && RegExp(r'^\d{6}$').hasMatch(pin)) {
                        controller.otpVerification(context);
                      } else {
                        errorToast("Please enter a valid OTP.".tr);
                      }

                    },
                    title: "Verify".tr
                ),
                SizedBox(height: 2.h),


                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Didn’t receive the auth code? '.tr,
                      style: TextStyle(
                        color: ThemeProvider.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                        fontSize: Utils.responsiveFontSize(
                          context,
                          16.sp,
                        ),
                      ),
                      children: [
                        TextSpan(
                          text: 'Re-Send'.tr,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: ThemeProvider.primary,
                            fontSize: Utils.responsiveFontSize(
                              context,
                              16.sp,
                            ),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              controller.resendOtpForVerification(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget pinArea1(BuildContext context1, VerificationScreenLogic controller) {
    return PinCodeTextField(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.deny(RegExp(r'\s'))
      ],
      controller: controller.pinController,
      // Assign controller here
      cursorColor: ThemeProvider.textColor,
      length: 6,
      obscureText: false,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: ThemeProvider.blackColor,
      ),
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(3),
        fieldHeight: 6.h,
        fieldWidth: 13.w,
        selectedColor: ThemeProvider.primary,
        selectedFillColor: ThemeProvider.whiteColor,
        inactiveColor: ThemeProvider.whiteColor,
        activeColor: ThemeProvider.whiteColor,
        inactiveFillColor: ThemeProvider.whiteColor,
        activeFillColor: ThemeProvider.whiteColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      onCompleted: (v) {
        //_verificationBloc.add(OtpChanged(otp: v));
      },
      onChanged: (value1) {
        //_verificationBloc.add(OtpChanged(otp: value1));
      },
      beforeTextPaste: (text) => true,
      appContext: context1,
    );
  }

}
