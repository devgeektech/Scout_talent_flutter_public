import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../backend/helper/app_router.dart';
import '../../utils/app_assets.dart';
import '../../utils/utils.dart';
import '../../utils/validation.dart';
import '../../widget/button.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';
import 'login_controller.dart';
import 'package:sizer/sizer.dart';
import '../../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            // Prevent resizing when keyboard appears
            backgroundColor: ThemeProvider.bgColor,
            body: Padding(
              padding: EdgeInsets.only(top: 5.h, left: 4.w,right: 4.w),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Change language
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //App heading
                          Row(
                            children: [
                              Image(
                                image: AssetImage(AssetPath.logo),
                                height: 4.h,
                              ),
                              SizedBox(width: 2.w),
                              RichText(
                                text: TextSpan(
                                  text: 'Scout',
                                  style: TextStyle(
                                    color: ThemeProvider.primary,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Montserrat",
                                    fontSize: Utils.responsiveFontSize(
                                      context,
                                      20.sp,
                                    ),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Talent ',
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w800,
                                        color: ThemeProvider.primary,
                                        fontSize: Utils.responsiveFontSize(
                                          context,
                                          20.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                               // padding: EdgeInsets.symmetric(horizontal: 2.w),
                                borderRadius: BorderRadius.circular(10),
                                value: controller.selectedLanguage.isNotEmpty
                                    ? controller.selectedLanguage
                                    : 'en',
                                isDense: true,
                                isExpanded: false,
                                dropdownColor: ThemeProvider.bgColor,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: ThemeProvider.textColor,
                                ),
                                style: TextStyle(
                                  color: ThemeProvider.whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.updateLanguage(value);
                                  }
                                },
                  
                                selectedItemBuilder: (context) {
                                  return ['en', 'ro'].map((langCode) {
                                    return Row(
                                      children: [
                                        // SVG Icon
                                        SvgPicture.asset(
                                          controller.selectedLanguage == 'en'
                                              ? AssetPath.english
                                              : AssetPath.romanian,   // Romanian flag SVG
                                          width: 24,
                                          height: 24,
                                        ),
                                        SizedBox(width: 8), // spacing between icon and text
                                        // Language Name
                                        Text(
                                          _getLanguageName(langCode),
                                          style: TextStyle(
                                            fontFamily: 'regular',
                                            color: ThemeProvider.whiteColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList();
                                },
                  
                                items: ['en', 'ro'].map((langCode) {
                                  return DropdownMenuItem(
                                    value: langCode,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 2),
                  
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                /// -------- FLAG ICON --------
                                                SvgPicture.asset(
                                                  langCode == 'en'
                                                      ? AssetPath.english   // your english flag svg
                                                      : AssetPath.romanian, // your Romanian flag svg
                                                  width: 28,
                                                  height: 28,
                                                ),
                  
                                                const SizedBox(width: 10),
                  
                                                /// -------- LANGUAGE NAME --------
                                                CommonTextWidget(
                                                  heading: _getLanguageName(langCode),
                                                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                  fontWeight: FontWeight.w600,
                                                  color: ThemeProvider.whiteColor,
                                                  fontFamily: 'regular',
                                                ),
                                              ],
                                            ),
                  
                                            /// -------- RADIO CHECK --------
                                            Icon(
                                              controller.selectedLanguage == langCode
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_unchecked,
                                              color: controller.selectedLanguage == langCode
                                                  ? ThemeProvider.appColor
                                                  : Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                  
                                        Divider(
                                          color: ThemeProvider.textColor.withAlpha(20),
                                        ),
                  
                                        const SizedBox(height: 2),
                                      ],
                                    ),
                                  );
                                }).toList(),
                  
                                //Language
                              ),
                            ), // )
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      CommonTextWidget(
                        textAlign: TextAlign.center,
                        heading: "Welcome Back !".tr,
                        fontSize: Utils.responsiveFontSize(context, 22.sp),
                        fontWeight: FontWeight.w600,
                        color: ThemeProvider.whiteColor,
                        fontFamily: "Montserrat",
                      ),
                      SizedBox(height: 2                                  .h),
                  
                      CommonTextWidget(
                        lineHeight: 1.3,
                        textAlign: TextAlign.start,
                        heading: "Upload, review, and share your top plays with the world.",
                        fontSize: Utils.responsiveFontSize(context, 16.sp),
                        fontWeight: FontWeight.w500,
                        color: ThemeProvider.whiteColor,
                        fontFamily: "Montserrat",
                      ),
                      SizedBox(height: 4.h),
                  
                      //Email
                      CustomTextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: controller.emailController,
                        textInputStyle: TextStyle(
                          color: ThemeProvider.hintText,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
                          fontFamily: 'Montserrat',
                        ),
                        hintText: "Email".tr,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !Validators.isEmailValid(value)) {
                            return 'Enter a valid email'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                  
                      // Password Field
                      CustomTextField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
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
                        hintText: "Password".tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 1.h),
                  
                      //Remember Me
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CheckboxTheme(
                                data: CheckboxThemeData(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      4,
                                    ), // ← round inner square
                                  ),
                                ),
                                child: Checkbox(
                                  value: controller.isRememberMeChecked,
                                  activeColor: ThemeProvider.primary,
                                  checkColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  onChanged: (value) {
                                    controller.rememberMeChecked(value!);
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                  
                              CommonTextWidget(
                                textAlign: TextAlign.center,
                                heading: "Remember Me".tr,
                                fontSize: Utils.responsiveFontSize(
                                  context,
                                  16.sp,
                                ),
                                fontWeight: FontWeight.w500,
                                color: ThemeProvider.whiteColor,
                                fontFamily: 'Montserrat',
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRouter.forgot);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  // adjust spacing
                                  child: CommonTextWidget(
                                    textAlign: TextAlign.center,
                                    heading: "Forgot Password?".tr,
                                    fontSize: Utils.responsiveFontSize(
                                      context,
                                      16.sp,
                                    ),
                                    fontWeight: FontWeight.w400,
                                    color: ThemeProvider.primary,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                  
                              // Custom underline (avoids descenders)
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: controller.getUnderlineWidth(
                                    "Forgot Password?",
                                  ),
                                  height: 0.5, // line thickness
                                  color: ThemeProvider.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                  
                      //login button
                      Button(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.login(context);
                          }
                        },
                        title: "Log In",
                      ),
                      SizedBox(height: 2.h),
                  
                      //Sign Up
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account yet?".tr,
                            style: TextStyle(
                              color: ThemeProvider.whiteColor,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                            ),
                            children: [
                              TextSpan(
                                text: "Sign Up! ".tr,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: ThemeProvider.primary,
                                  fontSize: Utils.responsiveFontSize(
                                    context,
                                    16.sp,
                                  ),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.offAllNamed(AppRouter.chooseYourAccount);
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
            ),
          ),
        );
      },
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'EN';
      case 'ro':
        return 'RO';

      default:
        return code;
    }
  }



}
