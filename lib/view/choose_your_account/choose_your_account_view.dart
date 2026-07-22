import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/view/choose_your_account/choose_your_account_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:scouttalent2/widget/commontext.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/gestures.dart';

import '../../utils/utils.dart';

class ChooseYourAccountPage extends StatefulWidget {
  const ChooseYourAccountPage({super.key});

  @override
  State<ChooseYourAccountPage> createState() => _ChooseYourAccountPageState();
}

class _ChooseYourAccountPageState extends State<ChooseYourAccountPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChooseYourAccountLogic>(
        builder: (controller) {
      return Scaffold(
        backgroundColor: ThemeProvider.bgColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 4.w),
          child: Column(
            children: [
              //Change language
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  //App heading
                  Row(
                    children: [
                      Image(
                        image: AssetImage(
                        AssetPath.logo,
                      ),
                      height: 4.h,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Scout',
                          style: TextStyle(
                              color: ThemeProvider.primary,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                              fontSize: Utils.responsiveFontSize(context, 20.sp)
                          ),
                          children: [
                            TextSpan(
                              text: 'Talent '.tr,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w800,
                                  color: ThemeProvider.primary,
                                  fontSize: Utils.responsiveFontSize(context, 20.sp)
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),

                  //Language
                  // Row(
                  //   children: [
                  //
                  //     SvgPicture.asset(
                  //       AssetPath.english,
                  //       height: 2.5.h,
                  //     ),
                  //     SizedBox(
                  //       width: 2.w,
                  //     ),
                  //     CommonTextWidget(
                  //       textAlign: TextAlign.center,
                  //       heading: "EN",
                  //       fontSize: Utils.responsiveFontSize(context, 18.sp),
                  //       fontWeight: FontWeight.w400,
                  //       color: ThemeProvider.whiteColor,
                  //       fontFamily: 'Montserrat',
                  //     ),
                  //     SizedBox(
                  //       width: 1.w,
                  //     ),
                  //     Icon(
                  //       Icons.keyboard_arrow_down_outlined,
                  //       color: ThemeProvider.whiteColor,
                  //     )
                  //   ],
                  // )
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
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
              SizedBox(
                height: 5.h,
              ),

              //Choose account type
              Container(
                height: 60.h,
                padding: EdgeInsets.all(10),
                decoration:BoxDecoration(
                  color: ThemeProvider.bgColor,
                  border: Border.all(
                    color: ThemeProvider.whiteColor.withAlpha(40)
                  ),
                  borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white10,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1)

                      )
                    ]
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),


                    CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: "Choose Your Account Type",
                      fontSize: Utils.responsiveFontSize(context, 22.sp),
                      fontWeight: FontWeight.w400,
                      color: ThemeProvider.whiteColor,
                      fontFamily: 'Montserrat',
                    ),

                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: controller.roles.length,
                          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.w,
                            mainAxisSpacing: 2.h,
                            //childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) {
                          final user = controller.roles[index];
                          bool isSelected = controller.selectedRole.value == user.role;

                          return GestureDetector(
                              onTap: (){
                                controller.updateSelectedRole(user.role);

                              },
                              child: roleWidget(
                                  user.imagePath,
                                  user.role,
                                  user.roleDescription,
                                  isSelected
                              ),
                            );
                          },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),

              //Continue Button
              Button(
                onPressed: (){
                //Save selected role to local storage
                  if(controller.selectedRole.value ==""){
                    errorToast("Please select your role to continue");
                  }else{
                    Utils().saveUserType(controller.normalizeRole(controller.selectedRole.value));
                  Get.toNamed(AppRouter.register);
                  }
                  

              },
              title: "Continue".tr),
              SizedBox(
                height: 3.h,
              ),

              //Sign In
              RichText(
                text: TextSpan(
                  text: 'Already have an account?'.tr,
                  style: TextStyle(
                      color: ThemeProvider.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                      fontSize: Utils.responsiveFontSize(context, 16.sp)
                  ),
                  children: [
                    TextSpan(

                      text: 'Sign in!'.tr,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          color: ThemeProvider.primary,
                          fontSize: Utils.responsiveFontSize(context, 16.sp)
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(AppRouter.login); // <-- Navigate to Login
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      );
    });
  }

  roleWidget(
      String imagePath,
      String role,
      String roleDescription,
      bool isSelected,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: ThemeProvider.whiteColor.withAlpha(20),
        border: Border.all(
          color: isSelected
              ? ThemeProvider.primary
              : ThemeProvider.whiteColor.withAlpha(40),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(imagePath),

          SizedBox(height: 12), // symmetric spacing

          CommonTextWidget(
            textAlign: TextAlign.center,
            heading: role.tr,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w400,
            color: ThemeProvider.whiteColor,
            fontFamily: 'Montserrat',
          ),

          SizedBox(height: 8), // slightly smaller spacing below title

          CommonTextWidget(
            lineHeight: 1.5,
            textAlign: TextAlign.center,
            heading: roleDescription.tr,
            fontSize: Utils.responsiveFontSize(context, 14.sp),
            fontWeight: FontWeight.w400,
            color: ThemeProvider.whiteColor,
            fontFamily: 'Montserrat',
          ),
        ],
      ),
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
