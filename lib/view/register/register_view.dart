import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/utils/string.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/utils/utils.dart';
import 'package:scouttalent2/view/register/register_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:scouttalent2/widget/commontext.dart';
import 'package:sizer/sizer.dart';
import '../../utils/imagePickFunction.dart';
import '../../utils/imageSourceSheet.dart';
import '../../utils/validation.dart';
import '../../utils/webViewOpen.dart';
import '../../widget/customDropDown.dart';
import '../../widget/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey profileImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterLogic>(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  textAlign: TextAlign.center,
                  heading: "Get Started".tr,
                  fontSize: Utils.responsiveFontSize(context, 22.sp),
                  fontWeight: FontWeight.w600,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(height: 2.h),

                CommonTextWidget(
                  textAlign: TextAlign.start,
                  heading: controller.getRoleText().tr,
                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(height: 2.h),

                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Upload photo
                          Container(
                            key:profileImageKey,
                            child: Center(
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 4.6.h,
                                    backgroundColor: Colors.transparent,
                                    child: CircleAvatar(
                                      radius: 4.5.h,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          controller.profileImage != null
                                          ? FileImage(controller.profileImage!)
                                          : null,
                                    ),
                                  ),
                                  SvgPicture.asset(AssetPath.editIcon),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) =>
                                    ImageSourceActionSheet(
                                      onCameraSelected: () async {
                                        final file = await pickImageCommon(
                                          'camera',
                                        );
                                        if (file != null) {
                                          controller.profileImage = file;
                                          controller.update();
                                        }
                                      },
                                      onGallerySelected: () async {
                                        final file = await pickImageCommon(
                                          'gallery',
                                        );
                                        if (file != null) {
                                          controller.profileImage = file;
                                          controller.update();
                                        }
                                      },
                                    ),
                              );
                            },
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.h),
                                  border: Border.all(
                                    color: ThemeProvider.primary,
                                  ),
                                ),
                                child: CommonTextWidget(
                                  textAlign: TextAlign.center,
                                  heading: "Upload Photo".tr,
                                  fontSize: Utils.responsiveFontSize(
                                    context,
                                    16.sp,
                                  ),
                                  fontWeight: FontWeight.w500,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),

                          Utils.userRole == "player"
                          ?CommonTextWidget(
                            textAlign: TextAlign.center,
                            heading: "DISCLAIMER : Please upload a professional front-face portrait showing your shoulders.".tr,
                            fontSize: Utils.responsiveFontSize(context, 15.sp),
                            fontWeight: FontWeight.w500,
                            color: ThemeProvider.whiteColor,
                            fontFamily: "Montserrat",
                          )
                          :SizedBox.shrink(),
                          Utils.userRole == "player"
                          ?SizedBox(height: 2.h)
                          :SizedBox.shrink(),


                          //First Name
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: controller.firstNameController,
                            textInputStyle: TextStyle(
                              color: ThemeProvider.hintText,
                              fontSize: Utils.responsiveFontSize(
                                context,
                                16.sp,
                              ),
                              fontFamily: 'Montserrat',
                            ),
                            hintText: "First Name".tr,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your first name'.tr;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.h),

                          //Last Name
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: controller.lastNameController,
                            textInputStyle: TextStyle(
                              color: ThemeProvider.hintText,
                              fontSize: Utils.responsiveFontSize(
                                context,
                                16.sp,
                              ),
                              fontFamily: 'Montserrat',
                            ),
                            hintText: "Last Name".tr,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your last name'.tr;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.h),

                          //Email
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: controller.emailController,
                            textInputStyle: TextStyle(
                              color: ThemeProvider.hintText,
                              fontSize: Utils.responsiveFontSize(
                                context,
                                16.sp,
                              ),
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
                            // validator: Validators.validateEmail,

                          ),
                          SizedBox(height: 2.h),

                          // Password Field
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            controller: controller.passwordController,
                            textInputStyle: TextStyle(
                              color: ThemeProvider.hintText,
                              fontSize: Utils.responsiveFontSize(
                                context,
                                16.sp,
                              ),
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
                            maxLines: 1,
                            obscureText: !controller.isPasswordVisible,
                            hintText: "Password".tr,
                            // validator: (value) {
                            //   if (value == null ||
                            //       value.isEmpty ||
                            //       !Validators.isPasswordValid(value)) {
                            //     return 'Enter a valid password'.tr;
                            //   }
                            //   return null;
                            // },

                            validator: Validators.validatePassword,

                          ),
                          SizedBox(height: 2.h),

                          //Contact
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            controller: controller.contactController,
                            textInputStyle: TextStyle(
                              color: ThemeProvider.hintText,
                              fontSize: Utils.responsiveFontSize(
                                context,
                                16.sp,
                              ),
                              fontFamily: 'Montserrat',
                            ),
                            hintText: "Contact Number".tr,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !Validators.isPhoneValid(value)) {
                                return 'Enter a valid contact number'.tr;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 2.h),

                          //Date of Birth
                          CustomTextField(
                            textInputAction: TextInputAction.next,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(AssetPath.calender),
                            ),
                            // readOnly: true,
                            controller: controller.dobController,
                            textInputStyle: TextStyle(
                              color: ThemeProvider.hintText,
                              fontSize: Utils.responsiveFontSize(
                                context,
                                16.sp,
                              ),
                              fontFamily: 'Montserrat',
                            ),
                            hintText: "Date of Birth".tr,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your date of birth'.tr;
                              }
                              return null;
                            },
                            ontap: () {
                              pickedDateOnly(
                                context,
                                controller.dobController,
                                controller,
                              );
                            },
                          ),
                          SizedBox(height: 2.h),
                          if (Utils.userRole == "club") ...[
                            CustomTextField(
                              textInputAction: TextInputAction.next,
                              controller: controller.clubNameController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(
                                  context,
                                  16.sp,
                                ),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Name of Club".tr,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name of Club'.tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                          ],

                          if (Utils.userRole == "player" ) ...[
                            //Discount
                            CustomTextField(
                              textInputAction: TextInputAction.next,
                              controller: controller.discountController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(
                                  context,
                                  16.sp,
                                ),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Discount Code".tr,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Enter valid contact'.tr;
                              //   }
                              //   return null;
                              // },
                            ),
                            SizedBox(height: 2.h),

                            //Current Team
                            CustomTextField(
                              textInputAction: TextInputAction.next,
                              controller: controller.currentTeamController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(
                                  context,
                                  16.sp,
                                ),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Current Team".tr,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Enter your current team'.tr;
                              //   }
                              //   return null;
                              // },
                            ),
                            SizedBox(height: 2.h),
                          ],

                          if (Utils.userRole == "scout") ...[
                            //Country
                            /*CustomTextField(
                              readOnly: true,
                              ontap: () {
                                // showCountryPicker(
                                //   context: context,
                                //   showPhoneCode: false,
                                //   onSelect: (Country country) {
                                //     controller.countryNameController.text = country.name; // Save selected country
                                //     controller.update();
                                //   },
                                // );
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return SafeArea(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            alignment: Alignment.centerLeft,
                                            child: CommonTextWidget(
                                              heading: 'Select County',
                                              fontSize: 16,
                                              color: ThemeProvider.textColor,
                                            ),
                                          ),
                                          Divider(height: 1),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  AppString.COUNTIES.length,
                                              itemBuilder: (_, index) {
                                                return ListTile(
                                                  title: Text(
                                                    AppString.COUNTIES[index],
                                                  ),
                                                  // use COUNTIES list
                                                  onTap: () {
                                                    controller
                                                        .countryNameController
                                                        .text = AppString
                                                        .COUNTIES[index]; // set selected value
                                                    controller
                                                        .update(); // update GetX state
                                                    Navigator.pop(
                                                      context,
                                                    ); // close the bottom sheet
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              controller: controller.countryNameController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(
                                  context,
                                  16.sp,
                                ),
                                fontFamily: 'Montserrat',
                              ),
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 30,
                              ),
                              hintText: "Select County".tr,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Select country'.tr;
                              //   }
                              //   return null;
                              // },
                            ),
                            SizedBox(height: 2.h),*/

                            // Name of club
                            CustomTextField(
                              controller: controller.clubNameController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(
                                  context,
                                  16.sp,
                                ),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Name of Club".tr,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Enter name of Club'.tr;
                              //   }
                              //   return null;
                              // },
                            ),
                            SizedBox(height: 2.h),
                          ],

                          Utils.userRole == "player"
                              ? Obx(() {
                                  return controller.playerIsMinor.value
                                      ? Column(
                                          children: [
                                            //Below 18 check here for player
                                            CommonTextWidget(
                                              textAlign: TextAlign.start,
                                              heading:
                                                  "Look like you’re under 18 — just need a few details from your parent."
                                                      .tr,
                                              fontSize:
                                                  Utils.responsiveFontSize(
                                                    context,
                                                    16.sp,
                                                  ),
                                              fontWeight: FontWeight.w500,
                                              color: ThemeProvider.whiteColor,
                                              fontFamily: "Montserrat",
                                            ),
                                            SizedBox(height: 2.h),

                                            //Parent First Name
                                            CustomTextField(
                                              textInputAction: TextInputAction.next,
                                              controller: controller
                                                  .parentFirstNameController,
                                              textInputStyle: TextStyle(
                                                color: ThemeProvider.hintText,
                                                fontSize:
                                                    Utils.responsiveFontSize(
                                                      context,
                                                      16.sp,
                                                    ),
                                                fontFamily: 'Montserrat',
                                              ),
                                              hintText: "Parent First Name".tr,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter parent first name'
                                                      .tr;
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 2.h),

                                            //Parent Last Name
                                            CustomTextField(
                                              textInputAction: TextInputAction.next,
                                              controller: controller
                                                  .parentLastNameController,
                                              textInputStyle: TextStyle(
                                                color: ThemeProvider.hintText,
                                                fontSize:
                                                    Utils.responsiveFontSize(
                                                      context,
                                                      16.sp,
                                                    ),
                                                fontFamily: 'Montserrat',
                                              ),
                                              hintText: "Parent Last Name".tr,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter parent last name'
                                                      .tr;
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 2.h),

                                            //Parent Email
                                            CustomTextField(
                                              textInputAction: TextInputAction.next,
                                              // controller: controller.passwordController,
                                              textInputStyle: TextStyle(
                                                color: ThemeProvider.hintText,
                                                fontSize:
                                                    Utils.responsiveFontSize(
                                                      context,
                                                      16.sp,
                                                    ),
                                                fontFamily: 'Montserrat',
                                              ),
                                              hintText: "Parent Email".tr,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    !Validators.isEmailValid(
                                                      value,
                                                    )) {
                                                  return 'Enter a valid email'
                                                      .tr;
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 2.h),

                                            //Parent Contact Number
                                            CustomTextField(
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.phone,
                                              controller: controller
                                                  .parentContactController,
                                              textInputStyle: TextStyle(
                                                color: ThemeProvider.hintText,
                                                fontSize:
                                                    Utils.responsiveFontSize(
                                                      context,
                                                      16.sp,
                                                    ),
                                                fontFamily: 'Montserrat',
                                              ),
                                              hintText:
                                                  "Parent Contact Number".tr,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    !Validators.isPhoneValid(
                                                      value,
                                                    )) {
                                                  return 'Enter a valid contact number'
                                                      .tr;
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 2.h),

                                            //Relation Dropdown
                                            CustomDropdownButton(
                                              hintText: "Relation".tr,
                                              items: ['Father'.tr,'Mother'.tr,'Brother'.tr],
                                              selectedValue:
                                                  controller.selectedRelation,
                                              onChanged: (value) {
                                                controller
                                                    .updateSelectedRelation(
                                                      value.toString(),
                                                    );
                                              },
                                              isExpanded: true,
                                              validator: (value) {
                                                if (controller
                                                            .selectedRelation ==
                                                        null ||
                                                    controller
                                                            .selectedRelation
                                                            ?.isEmpty ==
                                                        true) {
                                                  return 'Select relation'.tr;
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 2.h),
                                          ],
                                        )
                                      : SizedBox.shrink();
                                })
                              : SizedBox.shrink(),

                          //Terms and condition checkbox
                          Row(
                            children: [
                              CheckboxTheme(
                                data: CheckboxThemeData(
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      4,
                                    ), // ← round inner square
                                  ),
                                ),
                                child: Checkbox(
                                  activeColor: ThemeProvider.primary,
                                  // orange fill when checked
                                  checkColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    // border color when unchecked
                                    width: 2,
                                  ),
                                  value: controller.isTermConditionsChecked,
                                  onChanged: (value) {
                                    controller.termConditionsChecked(value!);
                                  },
                                ),
                              ),

                              RichText(
                                text: TextSpan(
                                  text: 'I agree to '.tr,
                                  style: TextStyle(
                                    color: ThemeProvider.whiteColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Montserrat",
                                    fontSize: Utils.responsiveFontSize(
                                      context,
                                      14.sp,
                                    ),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms & Conditions'.tr,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                        color: ThemeProvider.whiteColor,
                                        fontSize: Utils.responsiveFontSize(
                                          context,
                                          14.sp,
                                        ),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WebViewOpen(
                                                webViewUrl:
                                                "https://scouttalentworld.com/terms-and-conditions",
                                              ),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          //Subscribe to Newsletter
                          Row(
                            children: [
                              CheckboxTheme(
                                data: CheckboxThemeData(
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      4,
                                    ), // ← round inner square
                                  ),
                                ),
                                child: Checkbox(
                                  activeColor: ThemeProvider.primary,
                                  // orange fill when checked
                                  checkColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    // border color when unchecked
                                    width: 2,
                                  ),
                                  value: controller.isSubscribe,
                                  onChanged: (value) {
                                    controller.isSubscribeChecked(value!);
                                  },
                                ),
                              ),

                              RichText(
                                text: TextSpan(
                                  text: 'Subscribe to Newsletter '.tr,
                                  style: TextStyle(
                                    color: ThemeProvider.whiteColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Montserrat",
                                    fontSize: Utils.responsiveFontSize(
                                      context,
                                      14.sp,
                                    ),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'GDPR '.tr,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                        color: ThemeProvider.whiteColor,
                                        fontSize: Utils.responsiveFontSize(
                                          context,
                                          14.sp,
                                        ),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WebViewOpen(
                                                webViewUrl:
                                                "https://europa.eu/youreurope/business/dealing-with-customers/data-protection/data-protection-gdpr/index_en.htm",
                                                appendLang: false,
                                              ),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 1.h,
                          ),

                          //Create account button
                          Button(
                            onPressed: () async {
                              if (controller.profileImage == null) {
                                errorToast("Please upload a profile image");
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                // Call the RegisterLogic method to register the user with avatar
                                if (Utils.userRole == "club") {
                                  await controller.registerWithClubAcademy(
                                    context,
                                  );
                                } else if (Utils.userRole == "scout") {
                                  await controller.registerClubScout(context);
                                } else if (Utils.userRole == "player") {
                                  await controller
                                      .registerWithPlayer(context);
                                } else {
                                  await controller.registerAgent(context);
                                }

                                // showCommonDialog(
                                //   context: context,
                                //   title: "Thank you !",
                                //   message: "Your registration has been completed successfully.",
                                //   secondMessage: "A verification link has been emailed to you. Confirm your email to continue.",
                                //   buttonText: "Login",
                                //   svgAsset: AssetPath.success,
                                //   onButtonTap: (){
                                //     Get.toNamed(AppRouter.login);
                                //   },
                                // );
                              }
                            },
                            title: "Create Account",
                          ),
                          SizedBox(height: 2.h),

                          //Sign In
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account?'.tr,
                                style: TextStyle(
                                  color: ThemeProvider.whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat",
                                  fontSize: Utils.responsiveFontSize(
                                    context,
                                    16.sp,
                                  ),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign in!'.tr,
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
                                        Get.toNamed(AppRouter.login);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //pick date only
  pickedDateOnly(
    BuildContext context,
    TextEditingController textController,
    RegisterLogic controller,
  ) async {
    DateTime initialDate;

    // If already selected earlier, use that date as initial date
    if (textController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('MMM dd, yyyy').parse(textController.text);
      } catch (_) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('MMM dd, yyyy').format(pickedDate);
      textController.text = formattedDate;
      controller.dobController = textController;

      if (Utils.userRole == "player") {
        int age = controller.calculateAge(pickedDate);
        if (age < 3) {
          errorToast("Player must be at least 3 years old.");
          textController.clear();
          return;
        }


        controller.playerAge = age;
        controller.playerIsMinor.value = age < 18;
        controller.update();
        debugPrint("Age: $age, Minor: ${controller.playerIsMinor.value}");
      }else{
        int age = controller.calculateAge(pickedDate);

        if (age < 18) {
          // Show error alert
          String displayRole = Utils.userRole == "scout" ? "Club Scout" : Utils.userRole;

          errorToast("${"Age must be 18 or above for".tr} $displayRole.",);

          textController.clear();
          return;
        }
      }

      controller.update();
      debugPrint("Selected date: $formattedDate");
    } else {
      // Handle user canceling the date picker
      debugPrint("Date selection canceled");
    }
  }
}
