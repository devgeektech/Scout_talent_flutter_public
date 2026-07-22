import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/view/forgot_password/forgot_password_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../utils/validation.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                heading: "Forgot Password ?".tr,
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
                controller: Get.find<ForgotPasswordLogic>().emailController,
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
              SizedBox(height: 4.h),

              Button(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  Get.find<ForgotPasswordLogic>().forgotPassword(context);
                }
              },
              title: "Next"
              )
            ],
          ),
        ),
      ),
    );
  }
}
