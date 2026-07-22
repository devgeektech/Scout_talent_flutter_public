import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/view/reset_password/reset_password_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../utils/validation.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String email = Get.arguments["email"];
  @override
  void initState() {
    super.initState();
    final controller = Get.find<ResetPasswordLogic>();
    controller.emailController.text = email;   // ← SET EMAIL HERE
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordLogic>(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  CommonTextWidget(
                    textAlign: TextAlign.start,
                    heading: "Reset Password ?".tr,
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
                    heading: "No worries — we'll help you recover your access".tr,
                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                    fontWeight: FontWeight.w500,
                    color: ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
              
                  //Email
                  CustomTextField(
                    readOnly: true,
                    controller: controller.emailController,
                    textInputStyle: TextStyle(
                      color: ThemeProvider.hintText,
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontFamily: 'Montserrat',
                    ),
                    hintText: "Email".tr,
                    validator: (value) {
                      if (value == null || value.isEmpty ||
                          !Validators.isEmailValid(value)) {
                        return 'Enter a valid email'.tr;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
              
                  // Password Field
                  CustomTextField(
                    controller: controller.passwordController,
                    textInputStyle: TextStyle(
                      color: ThemeProvider.hintText,
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontFamily: 'Montserrat',
                    ),
                    suffixIcon: InkWell(
                      onTap: controller.togglePasswordVisibility,
                      child: Icon(
                        controller.isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: ThemeProvider.hintText,
                        size: 23,
                      ),
                    ),
                    obscureText: !controller.isPasswordVisible,
                    hintText: "New Password".tr,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty ||
                    //       !Validators.isPasswordValid(value)) {
                    //     return 'Enter a valid password'.tr;
                    //   }
                    //   return null;
                    // },
                    validator: Validators.validatePassword,
              
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
              
                  //Email
                  CustomTextField(
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    controller: controller.otpController,
                    textInputStyle: TextStyle(
                      color: ThemeProvider.hintText,
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontFamily: 'Montserrat',
                    ),
                    hintText: "OTP".tr,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.deny(RegExp(r'\s'))
                    ],
                    validator: (value) {
                      return null;
                    
                      // if (value == null || value.isEmpty ||
                      //     !Validators.isEmailValid(value)) {
                      //   return 'Enter the OTP'.tr;
                      // }
                      // return null;
                    },
                  ),
              
                  SizedBox(height: 1.h),
              
              
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Didn’t receive the OTP? '.tr,
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
              
                  SizedBox(height: 4.h),
                  Button(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          controller.resetPassword(context);
              
                        }
              
                        // showCommonDialog(
                        //   context: context,
                        //   title: "Updated Successfully",
                        //   message: "Your password has been changed successfully",
                        //   buttonText: "Back to login",
                        //   svgAsset: AssetPath.success,
                        //   onButtonTap: (){
                        //     Get.toNamed(AppRouter.login);
                        //   },
                        // );
                      },
                      title: "Next"
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
