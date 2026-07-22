import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/contact_us/contact_us_logic.dart';
import 'package:sizer/sizer.dart';

import '../../utils/utils.dart';
import '../../utils/validation.dart';
import '../../widget/button.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';

class ContactUsView extends StatelessWidget {
  ContactUsView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactUsLogic>(
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CommonTextWidget(
                        textAlign: TextAlign.start,
                        heading: "Contact Us".tr,
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
                    SizedBox(height: 3.h),
              
                    // Password Field
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomTextField(
                        validator: Validators.validateName,
                        controller: controller.nameController,
                        textInputStyle: TextStyle(
                          color: ThemeProvider.hintText,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
                          fontFamily: 'Montserrat',
                        ),
                        hintText: "Enter your name".tr,
              
                        // validator: (value) {
                        //   if (value == null || value.isEmpty ||
                        //       !Validators.isPasswordValid(value)) {
                        //     return 'Enter a valid password'.tr;
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    SizedBox(height: 2.h),
              
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomTextField(
                        validator: Validators.validateEmail,
                        hintText: 'Enter your email',
                        controller: controller.emailController,
                        textInputStyle: TextStyle(
                          color: ThemeProvider.hintText,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
              
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomTextField(
                        validator: Validators.validateMessage,
                        maxLines: 10,
                        controller: controller.messageController,
                        textInputStyle: TextStyle(
                          color: ThemeProvider.hintText,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
                          fontFamily: 'Montserrat',
                        ),
                        hintText: "Enter your message".tr,
              
                        // validator: (value) {
                        //   if (value == null || value.isEmpty ||
                        //       !Validators.isPasswordValid(value)) {
                        //     return 'Enter a valid password'.tr;
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Button(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.contactUsApi(context);
                          }
                        },
                        title: "Submit",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
