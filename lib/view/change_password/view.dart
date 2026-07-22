import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/view/change_password/logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../utils/validation.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordLogic>(
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
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CommonTextWidget(
                        textAlign: TextAlign.start,
                        heading: "Change Password".tr,
                        fontSize: Utils.responsiveFontSize(context, 22.sp),
                        fontWeight: FontWeight.w500,
                        color: ThemeProvider.whiteColor,
                        fontFamily: "Montserrat",
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CommonTextWidget(
                        textAlign: TextAlign.center,
                        heading: "".tr,
                        fontSize: Utils.responsiveFontSize(context, 16.sp),
                        fontWeight: FontWeight.w500,
                        color: ThemeProvider.whiteColor,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),

                    // Password Field
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomTextField(
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
                        hintText: "Enter your current password".tr,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty ||
                        //       !Validators.isPasswordValid(value)) {
                        //     return 'Enter a valid password'.tr;
                        //   }
                        //   return null;
                        // },
                        validator: Validators.validatePassword,

                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),

                    //Email
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomTextField(
                        controller: controller.confirmPassController,
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
                        hintText: "Enter your new password".tr,
                        validator: (value) {
                          // Check standard password rules
                          final error = Validators.validatePassword(value);
                          if (error != null) return error;

                          // Check that new password != current password
                          if (value == controller.passwordController.text) {
                            return 'New password cannot be same as current password'.tr;
                          }

                          return null;
                        },
                        //validator: Validators.validatePassword,

                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Button(
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              controller.changePassword(context);

                            }


                          },
                          title: "Update Password"
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
