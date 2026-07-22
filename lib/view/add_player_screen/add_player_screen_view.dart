import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/add_player_screen/add_player_screen_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_assets.dart';
import '../../utils/imagePickFunction.dart';
import '../../utils/imageSourceSheet.dart';
import '../../utils/string.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../utils/validation.dart';
import '../../widget/commontext.dart';
import '../../widget/customDropDown.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/multipleSeletionDropDown.dart';

class AddPlayerScreenPage extends StatefulWidget {
  const AddPlayerScreenPage({super.key});

  @override
  State<AddPlayerScreenPage> createState() => _AddPlayerScreenPageState();
}

class _AddPlayerScreenPageState extends State<AddPlayerScreenPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey profileImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddPlayerScreenLogic>(
        builder: (controller) {
      return SafeArea(
        child: Scaffold(
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
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),
                    CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading:controller.mode == "edit"
                      ?"Edit Player"
                      :"Add Player".tr,
                      fontSize: Utils.responsiveFontSize(context, 20.sp),
                      fontWeight: FontWeight.w500,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                    SizedBox(
                      height: 2.h,
                    ),

                    //Upload photo
                    Container(
                      key: profileImageKey,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 5.h,
                              backgroundColor: Colors.transparent,
                              child: CircleAvatar(
                                radius: 4.9.h,
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                controller.profileImageFile != null
                                    ? FileImage(controller.profileImageFile!)
                                    : (controller.profileImageUrl != null ? NetworkImage(controller.profileImageUrl!): null),
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
                                    controller.profileImageFile = file;
                                    controller.profileImageUrl = null;
                                    controller.update();
                                  }
                                },
                                onGallerySelected: () async {
                                  final file = await pickImageCommon(
                                    'gallery',
                                  );
                                  if (file != null) {
                                    controller.profileImageFile = file;
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
                    SizedBox(height: 2.h),

                    CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: "DISCLAIMER : Please upload a professional front-face portrait showing your shoulders.".tr,
                      fontSize: Utils.responsiveFontSize(context, 15.sp),
                      fontWeight: FontWeight.w500,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // if (controller.firstNameController.text.trim().isNotEmpty &&
                        //     controller.lastNameController.text.trim().isNotEmpty &&
                        //     controller.emailController.text.trim().isNotEmpty &&
                        //     controller.dobController.text.trim().isNotEmpty &&
                        //     controller.selectedPlayerCategory != null &&
                        //     controller.countyNameController.text.trim().isNotEmpty &&
                        //     controller.selectedNationalityOption != null &&
                        //     controller.countryCodeController.text.trim().isNotEmpty &&
                        //     controller.selectedPosition != null &&
                        //     controller.selectedSecondaryPositions.isNotEmpty &&
                        //     controller.selectedTechnicalAttributes.isNotEmpty &&
                        //     controller.selectedPlayingStyle.isNotEmpty &&
                        //     controller.heightController.text.trim().isNotEmpty &&
                        //     controller.weightController.text.trim().isNotEmpty &&
                        //     controller.selectedPreferredFoot != null &&
                        //     controller.selectedExperienceLevel != null &&
                        //     controller.selectedConsistency != null &&
                        //     controller.currentClubController.text.trim().isNotEmpty &&
                        //     controller.squadNumController.text.trim().isNotEmpty &&
                        //     controller.competitionLevelENController.text.trim().isNotEmpty &&
                        //     controller.competitionLevelROController.text.trim().isNotEmpty &&
                        //     controller.startContractDateController.text.trim().isNotEmpty &&
                        //     controller.endContractDateController.text.trim().isNotEmpty &&
                        //     controller.selectedTransferStatus != null
                        //  )
                        if(controller.personalInfoCompleted.value)
                           Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 18,
                            ),
                          ),
                        CommonTextWidget(
                          textAlign: TextAlign.start,
                          heading: "Personal Information".tr,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
                          fontWeight: FontWeight.w600,
                          color: ThemeProvider.whiteColor,
                          fontFamily: "Montserrat",
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    //First Name
                    KeyedSubtree(
                      key: controller.firstNameKey,
                      child: CustomTextField(
                        controller: controller.firstNameController,
                        textInputStyle: TextStyle(
                          color: ThemeProvider.hintText,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
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
                    ),
                    SizedBox(height: 2.h),

                    //Last Name
                    KeyedSubtree(
                      key: controller.lastNameKey,
                      child: CustomTextField(
                        controller: controller.lastNameController,
                        textInputStyle: TextStyle(
                          color: ThemeProvider.hintText,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
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
                    ),
                    SizedBox(height: 2.h),

                    //Email
                    KeyedSubtree(
                      key: controller.emailKey,
                      child: CustomTextField(
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
                    ),
                    SizedBox(height: 2.h),

                    //Date of Birth
                    KeyedSubtree(
                      key: controller.dobKey,
                      child: CustomTextField(
                        showReadOnlyColor: false,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            AssetPath.calender,
                          ),
                        ),
                        readOnly: true,
                        controller: controller.dobController,
                        textInputStyle: TextStyle(
                          color: ThemeProvider.hintText,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
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
                          pickedDateOnly(context, controller.dobController, controller,type: 'past',);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),


                    Align(
                      // alignment: AlignmentGeometry.centerRight,
                      child: IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () {
                            controller.updateShowMoreFields();
                          },
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
                              heading: controller.showMoreFields.value
                                  ? "View Less Details"
                                  : (controller.mode == "edit"
                                  ? "Edit More Details"
                                  : "Add More Details".tr),
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              fontWeight: FontWeight.w500,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),


                    //OtherDetails
                    controller.showMoreFields.value == false
                    ?SizedBox.shrink()
                    :Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Select player category
                        CustomDropdownButton(
                          hintText: 'Player Category'.tr,
                          items: controller.playerCategoryMap.values.toList(), // localized UI values
                          selectedValue: controller.selectedPlayerCategory == null
                              ? null
                              : controller.playerCategoryMap[controller.selectedPlayerCategory],
                          onChanged: (value) {
                            final selectedKey = controller.playerCategoryMap.entries
                                .firstWhere((e) => e.value == value)
                                .key;

                            controller.updateSelectedPlayerCategory(selectedKey); // English saved
                          },
                          isExpanded: true,
                        ),
                        SizedBox(height: 2.h),

                        //County
                        CustomTextField(
                          showReadOnlyColor: false,
                          readOnly: true,
                          ontap: () {
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
                                                    .countyNameController
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
                          controller: controller.countyNameController,
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
                        SizedBox(height: 2.h),

                        //Nationality (EN)
                        CustomDropdownButton(
                          translateItems: false,
                          hintText: "Nationality (EN)".tr,
                          items: controller.nationalityOptions.map((p) => p.en).toList(),
                          selectedValue: controller.selectedNationalityOption?.en,
                          onChanged: (value) {
                            controller.updateSelectedNationalityByEn(value.toString());
                          },
                          isExpanded: true,
                        ),
                        SizedBox(height: 2.h),

                        //Nationality (RO)
                        CustomDropdownButton(
                          translateItems: false,
                          hintText: "Nationality (RO)",
                          items: controller.nationalityOptions.map((p) => p.ro).toList(),
                          selectedValue: controller.selectedNationalityOption?.ro,
                          onChanged: (value) {
                            controller.updateSelectedNationalityByRo(value.toString());
                          },
                          isExpanded: true,
                        ),
                        SizedBox(height: 2.h),

                        //Country Code Picker
                        CustomTextField(
                          showReadOnlyColor: false,
                          readOnly: true,
                          controller: controller.countryCodeController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Country Code".tr,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 25,
                          ),
                          ontap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false,
                              onSelect: (Country country) {
                                controller.countryCodeController.text = country.countryCode; // Save selected country
                                controller.update();
                              },
                            );
                          },
                        ),
                        SizedBox(height: 2.h),

                        //Position (EN)
                        CustomDropdownButton(
                          translateItems: false,
                          hintText: "Position (EN)".tr,
                          items: controller.positions.map((p) => p.en).toList(),
                          selectedValue: controller.selectedPosition?.en,
                          onChanged: (value) {
                            controller.updateSelectedPositionByEn(value.toString());
                          },
                          isExpanded: true,
                        ),
                        SizedBox(height: 2.h),

                        //Position (RO)
                        CustomDropdownButton(
                          translateItems: false,
                          hintText: "Position (RO)",
                          items: controller.positions.map((p) => p.ro).toList(),
                          selectedValue: controller.selectedPosition?.ro,
                          onChanged: (value) {
                            controller.updateSelectedPositionByRo(value.toString());
                          },
                          isExpanded: true,
                        ),
                        SizedBox(height: 2.h),

                        //Secondary Position
                        controller.selectedPosition == null
                            ?SizedBox.shrink()
                            :MultiSelectDropdown(
                          hintText: controller.selectedLanguage.value == "en"
                              ? 'Secondary Position (EN)'
                              : 'Poziție secundară (RO)',
                          items: controller.secondaryPositions
                              .map((p) => controller.selectedLanguage.value == "en" ? p.en : p.ro)
                              .toList(),
                          selectedValues: controller.selectedSecondaryPositions
                              .map((p) => controller.selectedLanguage.value == "en"  ? p.en : p.ro)
                              .toList(),
                          onChanged: (List<String> newSelectedValues) {
                            final bool isEnglish = controller.selectedLanguage.value == "en";
                            controller.updateSelectedSecondaryPositions(newSelectedValues,isEnglish); },
                        ),
                        controller.selectedPosition == null
                            ?SizedBox.shrink()
                            :SizedBox(height: 2.h),

                        //Technical Attributes
                        MultiSelectDropdown(
                          hintText: controller.selectedLanguage.value == "en"
                              ? 'Technical Attributes'
                              : 'Atribute tehnice',
                          items: controller.technicalAttributes
                              .map((p) => controller.selectedLanguage.value == "en" ? p.en : p.ro)
                              .toList(),
                          selectedValues: controller.selectedTechnicalAttributes
                              .map((p) => controller.selectedLanguage.value == "en"  ? p.en : p.ro)
                              .toList(),
                          onChanged: (List<String> newSelectedValues) {
                            final bool isEnglish = controller.selectedLanguage.value == "en";
                            controller.updateSelectedTechnicalAttributes(newSelectedValues,isEnglish); },
                        ),
                        SizedBox(height: 2.h),

                        //Playing Style
                        MultiSelectDropdown(
                          hintText: controller.selectedLanguage.value == "en"
                              ? 'Playing Style'
                              : 'Stil de joc',
                          items: controller.playingStyle
                              .map((p) => controller.selectedLanguage.value == "en" ? p.en : p.ro)
                              .toList(),
                          selectedValues: controller.selectedPlayingStyle
                              .map((p) => controller.selectedLanguage.value == "en"  ? p.en : p.ro)
                              .toList(),
                          onChanged: (List<String> newSelectedValues) {
                            final bool isEnglish = controller.selectedLanguage.value == "en";
                            controller.updateSelectedPlayingStyle(newSelectedValues,isEnglish); },
                        ),
                        SizedBox(height: 2.h),

                        //Height
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.heightController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Enter Height (cm)".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your height'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Weight
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.weightController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Enter Weight (Kg)".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your weight'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Preferred Foot
                        CustomDropdownButton(
                          hintText: 'Preferred Foot'.tr,
                          items: controller.preferredFootMap.values.toList(),
                          selectedValue: controller.selectedPreferredFoot == null
                              ? null
                              : controller.preferredFootMap[controller.selectedPreferredFoot],
                          onChanged: (value) {
                            // Find English key from selected localized value
                            final selectedKey = controller.preferredFootMap.entries
                                .firstWhere((e) => e.value == value)
                                .key;

                            controller.updateSelectedPreferredFoot(selectedKey);
                          },
                          isExpanded: true,
                        ),

                        SizedBox(
                          height: 2.h,
                        ),

                        //Experience level
                        CustomDropdownButton(
                          hintText: 'Experience Level'.tr,
                          items: controller.experienceLevelMap.values.toList(), // localized values
                          selectedValue: controller.selectedExperienceLevel == null
                              ? null
                              : controller.experienceLevelMap[controller.selectedExperienceLevel],
                          onChanged: (value) {
                            final selectedKey = controller.experienceLevelMap.entries
                                .firstWhere((e) => e.value == value)
                                .key;

                            controller.updateSelectedExperienceLevel(selectedKey); // English saved
                          },
                          isExpanded: true,
                        ),

                        SizedBox(height: 2.h),

                        //Consistency
                        CustomDropdownButton(
                          hintText: 'Consistency'.tr,
                          items: controller.consistencyMap.values.toList(), // localized UI values
                          selectedValue: controller.selectedConsistency == null
                              ? null
                              : controller.consistencyMap[controller.selectedConsistency],
                          onChanged: (value) {
                            final selectedKey = controller.consistencyMap.entries
                                .firstWhere((e) => e.value == value)
                                .key;

                            controller.updateSelectedConsistency(selectedKey); // English saved
                          },
                          isExpanded: true,
                        ),

                        SizedBox(height: 2.h),

                        //Current Club
                        CustomTextField(
                          controller: controller.currentClubController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Current Club".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your current club'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Squad Number
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.squadNumController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Squad Number".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your squad number'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Competition Level (EN)
                        CustomTextField(
                          controller: controller.competitionLevelENController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Competition Level (EN)".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your Competition Level (EN)'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Competition Level (RO)
                        CustomTextField(
                          controller: controller.competitionLevelROController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Competition Level (RO)".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your Competition Level (RO)'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Contract Start
                        CustomTextField(
                          showReadOnlyColor: false,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              AssetPath.calender,
                            ),
                          ),
                          readOnly: true,
                          controller: controller.startContractDateController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Contract Start".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your contract start date'.tr;
                          //   }
                          //   return null;
                          // },
                          ontap: () {
                            pickedDateOnly(context, controller.startContractDateController, controller,type: 'both',);
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),

                        //Contract End
                        CustomTextField(
                          showReadOnlyColor: false,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SvgPicture.asset(
                              AssetPath.calender,
                            ),
                          ),
                          readOnly: true,
                          controller: controller.endContractDateController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Contract End".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your contract end date'.tr;
                          //   }
                          //   return null;
                          // },
                          ontap: () async {

                            if (controller.startContractDateController.text.isEmpty) {
                              errorToast("Please select contract start date first".tr);
                              return;
                            }

                            await pickedDateOnly(
                              context,
                              controller.endContractDateController,
                              controller,
                              type: 'future',
                            );

                            final start = controller.startContractDateController.text.trim();
                            final end = controller.endContractDateController.text.trim();

                            // ❗ If same date selected
                            if (start == end && start.isNotEmpty) {
                              controller.endContractDateController.clear();
                              errorToast("Contract start and end date cannot be the same".tr);
                            }
                          },

                        ),
                        SizedBox(
                          height: 2.h,
                        ),


                        //Transfer Status
                        CustomDropdownButton(
                          hintText: 'Transfer Status'.tr,
                          items: controller.transferStatusMap.values.toList(), // UI text
                          selectedValue: controller.selectedTransferStatus == null
                              ? null
                              : controller.transferStatusMap[controller.selectedTransferStatus],
                          onChanged: (value) {
                            final selectedKey = controller.transferStatusMap.entries
                                .firstWhere((e) => e.value == value)
                                .key;

                            controller.updateSelectedTransferStatus(selectedKey);
                          },
                          isExpanded: true,
                        ),

                        SizedBox(
                          height: 2.h,
                        ),


                        ///Add multiple career
                    Obx(() => KeyedSubtree(
                    key: controller.careerKey,
                    child: Column(
                      children: controller.fields.asMap().entries.map((entry) {
                        final index = entry.key;
                        final field = entry.value;

                         // ✅ Check if all career fields are filled
                          final isCompleted = [
                            field.careerSeasonController.text,
                            field.careerClubController.text,
                            field.careerMatchesController.text,
                            field.careerGoalsController.text,
                            field.careerMinutesController.text,
                            field.careerAssistsController.text,
                          ].every((text) => text.isNotEmpty);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row with Check Icon
                            if(index == 0)...[
                              Row(
                                children: [

                                  // if (isCompleted)
                                  if(controller.careerCompleted.value)
                                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                                  const SizedBox(width: 8),

                                  Text(
                                    "Career".tr,
                                    style: TextStyle(
                                      color: ThemeProvider.whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                            ],


                            //career Season
                            CustomTextField(
                              controller: field.careerSeasonController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Season".tr,
                            ),
                            SizedBox(height: 2.h),

                            //career club
                            CustomTextField(
                              controller: field.careerClubController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Club".tr,
                            ),
                            SizedBox(height: 2.h),

                            //career matches
                            CustomTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              keyboardType: TextInputType.number,
                              controller: field.careerMatchesController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Matches".tr,
                            ),
                            SizedBox(height: 2.h),

                            //career goals
                            CustomTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              keyboardType: TextInputType.number,
                              controller: field.careerGoalsController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Goals".tr,
                            ),
                            SizedBox(height: 2.h),

                            //Career minutes
                            CustomTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              keyboardType: TextInputType.number,
                              controller: field.careerMinutesController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Minutes".tr,
                            ),
                            SizedBox(height: 2.h),

                            //career assists
                            CustomTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              keyboardType: TextInputType.number,
                              controller: field.careerAssistsController,
                              textInputStyle: TextStyle(
                                color: ThemeProvider.hintText,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontFamily: 'Montserrat',
                              ),
                              hintText: "Assists".tr,
                            ),
                            SizedBox(height: 2.h),

                            // Remove Career Button
                            Button(
                              color: ThemeProvider.redColor,
                              onPressed: () {
                                controller.removeCareerFieldSet(index);
                              },
                              title: "Remove Career".tr,
                            ),
                            SizedBox(height: 2.h),
                          ],
                        );
                      }).toList(),
                    ),
                  )),
                        // ...controller.fields.asMap().entries.map((entry) {
                        //   final index = entry.key;
                        //   final field = entry.value;
                        //
                        //   // ✅ Check if all career fields are filled
                        //   final isCompleted = [
                        //     field.careerSeasonController.text,
                        //     field.careerClubController.text,
                        //     field.careerMatchesController.text,
                        //     field.careerGoalsController.text,
                        //     field.careerMinutesController.text,
                        //     field.careerAssistsController.text,
                        //   ].every((text) => text.isNotEmpty);
                        //
                        //   return KeyedSubtree(
                        //     key: controller.careerKey,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         // Header Row with Check Icon
                        //         Row(
                        //           children: [
                        //
                        //             if (isCompleted)
                        //               Icon(Icons.check_circle, color: Colors.green, size: 20),
                        //             const SizedBox(width: 8),
                        //
                        //             Text(
                        //               "Career",
                        //               style: TextStyle(
                        //                 color: ThemeProvider.whiteColor,
                        //                 fontWeight: FontWeight.w600,
                        //                 fontSize: Utils.responsiveFontSize(context, 16.sp),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 2.h),
                        //
                        //         //career Season
                        //         CustomTextField(
                        //           controller: field.careerSeasonController,
                        //           textInputStyle: TextStyle(
                        //             color: ThemeProvider.hintText,
                        //             fontSize: Utils.responsiveFontSize(context, 16.sp),
                        //             fontFamily: 'Montserrat',
                        //           ),
                        //           hintText: "Season".tr,
                        //         ),
                        //         SizedBox(height: 2.h),
                        //
                        //         //career club
                        //         CustomTextField(
                        //           controller: field.careerClubController,
                        //           textInputStyle: TextStyle(
                        //             color: ThemeProvider.hintText,
                        //             fontSize: Utils.responsiveFontSize(context, 16.sp),
                        //             fontFamily: 'Montserrat',
                        //           ),
                        //           hintText: "Club".tr,
                        //         ),
                        //         SizedBox(height: 2.h),
                        //
                        //         //career matches
                        //         CustomTextField(
                        //           inputFormatters: [
                        //             FilteringTextInputFormatter.digitsOnly,
                        //             FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        //           ],
                        //           keyboardType: TextInputType.number,
                        //           controller: field.careerMatchesController,
                        //           textInputStyle: TextStyle(
                        //             color: ThemeProvider.hintText,
                        //             fontSize: Utils.responsiveFontSize(context, 16.sp),
                        //             fontFamily: 'Montserrat',
                        //           ),
                        //           hintText: "Matches".tr,
                        //         ),
                        //         SizedBox(height: 2.h),
                        //
                        //         //career goals
                        //         CustomTextField(
                        //           inputFormatters: [
                        //             FilteringTextInputFormatter.digitsOnly,
                        //             FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        //           ],
                        //           keyboardType: TextInputType.number,
                        //           controller: field.careerGoalsController,
                        //           textInputStyle: TextStyle(
                        //             color: ThemeProvider.hintText,
                        //             fontSize: Utils.responsiveFontSize(context, 16.sp),
                        //             fontFamily: 'Montserrat',
                        //           ),
                        //           hintText: "Goals".tr,
                        //         ),
                        //         SizedBox(height: 2.h),
                        //
                        //         //Career minutes
                        //         CustomTextField(
                        //           inputFormatters: [
                        //             FilteringTextInputFormatter.digitsOnly,
                        //             FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        //           ],
                        //           keyboardType: TextInputType.number,
                        //           controller: field.careerMinutesController,
                        //           textInputStyle: TextStyle(
                        //             color: ThemeProvider.hintText,
                        //             fontSize: Utils.responsiveFontSize(context, 16.sp),
                        //             fontFamily: 'Montserrat',
                        //           ),
                        //           hintText: "Minutes".tr,
                        //         ),
                        //         SizedBox(height: 2.h),
                        //
                        //         //career assists
                        //         CustomTextField(
                        //           inputFormatters: [
                        //             FilteringTextInputFormatter.digitsOnly,
                        //             FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        //           ],
                        //           keyboardType: TextInputType.number,
                        //           controller: field.careerAssistsController,
                        //           textInputStyle: TextStyle(
                        //             color: ThemeProvider.hintText,
                        //             fontSize: Utils.responsiveFontSize(context, 16.sp),
                        //             fontFamily: 'Montserrat',
                        //           ),
                        //           hintText: "Assists".tr,
                        //         ),
                        //         SizedBox(height: 2.h),
                        //
                        //         // Remove Career Button
                        //         Button(
                        //           color: ThemeProvider.redColor,
                        //           onPressed: () {
                        //             controller.removeCareerFieldSet(index);
                        //           },
                        //           title: "Remove Career".tr,
                        //         ),
                        //         SizedBox(height: 2.h),
                        //       ],
                        //     ),
                        //   );
                        // }),


                        Button(
                            color: ThemeProvider.greenColor,
                            onPressed: () {
                              controller.addNewCareerFieldSet();
                            }, title: "Add Career".tr),
                        SizedBox(
                          height: 2.h,
                        ),

                        ///Stats
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // if ([
                            //   controller.matchPlayedController.text,
                            //   controller.goalsController.text,
                            //   controller.assistsController.text,
                            //   controller.minutesController.text,
                            // ].every(
                            //       (v) =>
                            //   v.trim().isNotEmpty &&
                            //       v.trim() != '0' &&
                            //       v.trim().toLowerCase() != 'null',
                            // ))
                            if(controller.statsCompleted.value)
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(Icons.check_circle, color: Colors.green, size: 18),
                              ),
                            CommonTextWidget(
                              textAlign: TextAlign.start,
                              heading: "Stats".tr,
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),

                        //Matches Played
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.matchPlayedController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Matches Played".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your matches played'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Goals
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.goalsController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Goals".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your goals'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Assists
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.assistsController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Assists".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your assists'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Minutes
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.minutesController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Minutes".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your minutes'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        ///National Team
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // if (controller.callUpsController.text.trim().isNotEmpty &&
                            //     controller.callUpsController.text.trim().toLowerCase() !=
                            //         'null' &&
                            //     controller.callUpsController.text.trim() != '0' &&
                            //     controller.capsController.text.trim().isNotEmpty &&
                            //     controller.capsController.text.trim().toLowerCase() != 'null' &&
                            //     controller.capsController.text.trim() != '0')
                            if(controller.nationalTeamCompleted.value)
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Icon(Icons.check_circle, color: Colors.green, size: 18),
                              ),

                            CommonTextWidget(
                              textAlign: TextAlign.start,
                              heading: "National Team".tr,
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),


                        //Call Ups
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.callUpsController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Call Ups".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your call ups'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Caps
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.capsController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Caps".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your caps'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        ///Performance Percentages
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // if ([
                            //   controller.passCompletionController.text,
                            //   controller.duelsWonController.text,
                            //   controller.passAccuracyController.text,
                            //   controller.shotsOnTargetController.text,
                            //   controller.dribblesCompletedController.text,
                            // ].every(
                            //       (v) => v.trim().isNotEmpty && v.trim().toLowerCase() != 'null',
                            // ))
                            if(controller.performanceCompleted.value)
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(Icons.check_circle, color: Colors.green, size: 18),
                              ),
                            CommonTextWidget(
                              textAlign: TextAlign.start,
                              heading: "Performance Percentages".tr,
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),

                        //Pass Completion
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.passCompletionController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText:  "${'Pass Completion'.tr} %",
                          validator: percentageValidator,
                        ),
                        SizedBox(height: 2.h),

                        //Duels Won
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.duelsWonController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText:  "${'Duels Won'.tr} %",
                          validator: percentageValidator,
                        ),
                        SizedBox(height: 2.h),

                        //Pass Accuracy
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.passAccuracyController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText:  "${'Pass Accuracy'.tr} %",
                          validator: percentageValidator,
                        ),
                        SizedBox(height: 2.h),

                        //Shots On Target
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.shotsOnTargetController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText:  "${"Shots On Target".tr} %",
                          validator: percentageValidator,
                        ),
                        SizedBox(height: 2.h),

                        //Dribbles Completed
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.dribblesCompletedController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText:  "${"Dribbles Completed".tr} %",
                          validator: percentageValidator,
                        ),
                        SizedBox(height: 2.h),

                        ///Youtube Links
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() {
                              final hasValidLink = controller.youtubeControllers.any((c) {
                                final text = c.text.trim();
                                return text.isNotEmpty && text.toLowerCase() != 'null';
                              });

                              return controller.youtubeCompleted.value == true
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 18,
                                ),
                              )
                                  : const SizedBox();
                            }),

                            CommonTextWidget(
                              textAlign: TextAlign.start,
                              heading: "Youtube Links".tr,
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        // Show field when added
                        // Obx(() => controller.showYoutubeField.value
                        //     ? Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     CustomTextField(
                        //       controller: controller.youtubeLinkController,
                        //       textInputStyle: TextStyle(
                        //         color: ThemeProvider.hintText,
                        //         fontSize: Utils.responsiveFontSize(context, 16.sp),
                        //         fontFamily: 'Montserrat',
                        //       ),
                        //       hintText: "Enter Youtube Link".tr,
                        //     ),
                        //     SizedBox(height: 2.h),
                        //
                        //     Button(
                        //       color: ThemeProvider.redColor,
                        //       onPressed: () {
                        //         controller.removeYoutubeField();
                        //       },
                        //       title: "Remove".tr,
                        //     ),
                        //     SizedBox(height: 2.h),
                        //   ],
                        // )
                        //     : const SizedBox()),
                        Obx(() => KeyedSubtree(
                          key: controller.youtubeKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(controller.youtubeControllers.length, (index) {
                                return Column(
                                  children: [
                                    CustomTextField(
                                      controller: controller.youtubeControllers[index],
                                      hintText: "Enter Youtube Link".tr,
                                      textInputStyle: TextStyle(
                                        color: ThemeProvider.hintText,
                                        fontSize:
                                        Utils.responsiveFontSize(context, 16.sp),
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    SizedBox(height: 1.h),

                                    Button(
                                      color: ThemeProvider.redColor,
                                      title: "Remove".tr,
                                      onPressed: () {
                                        controller.removeYoutubeField(index);
                                      },
                                    ),
                                    SizedBox(height: 2.h),
                                  ],
                                );
                              }),

                              /// Add button (always visible)
                              Button(
                                color: ThemeProvider.greenColor,
                                title: "Add Youtube Link".tr,
                                onPressed: () {
                                  controller.addYoutubeField(context);
                                },
                              ),
                            ],
                          ),
                        )),

                        // Always visible Add button (color changes)
                        // Obx(() => Button(
                        //   color: controller.showYoutubeField.value
                        //       ? Colors.grey
                        //       : ThemeProvider.greenColor,
                        //   onPressed: () {
                        //     controller.addYoutubeField(context);
                        //   },
                        //   title: "Add Youtube Link".tr,
                        // )),
                        SizedBox(height: 2.h),

                        ///Documents
                        CommonTextWidget(
                          textAlign: TextAlign.start,
                          heading: "Documents".tr,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
                          fontWeight: FontWeight.w600,
                          color: ThemeProvider.whiteColor,
                          fontFamily: "Montserrat",
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        //CV Upload
                        Row(
                          children: [
                            if (controller.apCVFileName != null &&
                                controller.apCVFileName!.trim().isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(Icons.check_circle, color: Colors.green, size: 18),
                              ),
                            CommonTextWidget(
                              textAlign: TextAlign.start,
                              heading: "CV".tr,
                              fontSize: Utils.responsiveFontSize(context, 15.sp),
                              fontWeight: FontWeight.w500,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        browseFilesWidget(
                          context: context,
                          fileName: controller.selectedCVFileName,
                          onFileSelected: (file) {
                            controller.selectedCVPdf = file;
                          },
                          onFileNameSelected: (name) {
                            setState(() {
                              controller.selectedCVFileName = name;
                            });
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),

                        //Medical upload
                        Row(
                          children: [
                            if (controller.apiMedicalFileName != null &&
                                controller.apiMedicalFileName!.trim().isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(Icons.check_circle, color: Colors.green, size: 18),
                              ),
                            CommonTextWidget(
                              textAlign: TextAlign.start,
                              heading: "Medical".tr,
                              fontSize: Utils.responsiveFontSize(context, 15.sp),
                              fontWeight: FontWeight.w500,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        browseFilesWidget(
                          context: context,
                          fileName: controller.selectedMedicalFileName,
                          onFileSelected: (file) {
                            controller.selectedMedicalPdf = file;
                          },
                          onFileNameSelected: (name) {
                            setState(() {
                              controller.selectedMedicalFileName = name;
                            });
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),

                        //Privacy
/*                    CustomDropdownButton(
                      hintText: "Privacy",
                      items: controller.privacy,
                      selectedValue: controller.selectedPrivacy,
                      onChanged: (value) {
                        controller.updateSelectedPrivacy(value.toString());
                      },
                      isExpanded: true,
                      // validator:(value) {
                      //   if (controller.selectedPrivacy == null || controller.selectedPrivacy?.isEmpty ==true) {
                      //     return 'Select privacy';
                      //   }
                      //   return null;
                      // } ,
                    ),*/

                        CustomDropdownButton(
                          hintText: 'All'.tr,
                          items: controller.privacyMap.values.toList(), // localized UI values
                          selectedValue: controller.selectedPrivacy == null
                              ? null
                              : controller.privacyMap[controller.selectedPrivacy],
                          onChanged: (value) {
                            final selectedKey = controller.privacyMap.entries
                                .firstWhere((e) => e.value == value)
                                .key;

                            controller.updateSelectedPrivacy(selectedKey); // English saved
                          },
                          isExpanded: true,
                        ),

                        SizedBox(
                          height: 2.h,
                        ),


                        ///Achievements
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() {
                              // Helper function
                              bool isFilled(String? value) =>
                                  value != null &&
                                      value.trim().isNotEmpty &&
                                      value.trim() != '0' &&
                                      value.trim().toLowerCase() != 'null';

                              final isClubFilled = isFilled(controller.clubController.text);
                              final isSeasonFilled = isFilled(controller.seasonController.text);
                              final isMatchesFilled = isFilled(
                                controller.matchesController.text,
                              );

                              // At least ONE trophy must be filled
                              final hasAnyTrophy = controller.trophies.any((trophy) {
                                return isFilled(trophy.trophyNameController.text) ||
                                    isFilled(trophy.trophyYearController.text) ||
                                    trophy.trophyImage != null;
                              });

                              final allFilled =
                                  isClubFilled &&
                                      isSeasonFilled &&
                                      isMatchesFilled &&
                                      hasAnyTrophy;

                              return controller.achievementsCompleted.value
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 18,
                                ),
                              )
                                  : const SizedBox();
                            }),
                            CommonTextWidget(
                              textAlign: TextAlign.start,
                              heading: "Achievements".tr,
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        //Club
                        CustomTextField(
                          controller: controller.clubController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Club".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your Club'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Season
                        CustomTextField(
                          controller: controller.seasonController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Season".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your season'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        //Matches
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s'))
                          ],
                          keyboardType: TextInputType.number,
                          controller: controller.matchesController,
                          textInputStyle: TextStyle(
                            color: ThemeProvider.hintText,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontFamily: 'Montserrat',
                          ),
                          hintText: "Matches".tr,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter your matches'.tr;
                          //   }
                          //   return null;
                          // },
                        ),
                        SizedBox(height: 2.h),

                        ///Add trophy
                    Obx(() => KeyedSubtree(
                      key: controller.trophiesKey, // ✅ single usage
                      child: Column(
                        children: controller.trophies.asMap().entries.map((entry) {
                          final index = entry.key;
                          final field = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Trophy Name
                              CustomTextField(
                                controller: field.trophyNameController,
                                textInputStyle: TextStyle(
                                  color: ThemeProvider.hintText,
                                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                                  fontFamily: 'Montserrat',
                                ),
                                hintText: "Trophy Name".tr,
                              ),
                              SizedBox(height: 2.h),

                              //Trophy Name
                              CustomTextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter.deny(RegExp(r'\s'))
                                ],
                                keyboardType: TextInputType.number,
                                controller: field.trophyYearController,
                                textInputStyle: TextStyle(
                                  color: ThemeProvider.hintText,
                                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                                  fontFamily: 'Montserrat',
                                ),
                                hintText: "Trophy Year".tr,
                              ),
                              SizedBox(height: 2.h),
                              CommonTextWidget(
                                textAlign: TextAlign.start,
                                heading: "Trophy Icon".tr,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontWeight: FontWeight.w600,
                                color: ThemeProvider.whiteColor,
                                fontFamily: "Montserrat",
                              ),
                              SizedBox(height: 2.h),

                              InkWell(
                                onTap:(){
                                  showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        ImageSourceActionSheet(
                                          onCameraSelected: () async {
                                            final file = await pickImageCommon(
                                              'camera',
                                            );
                                            if (file != null) {
                                              field.trophyImage = file;
                                              field.trophyImageFileName = file.path.split('/').last;
                                              controller.update();
                                            }
                                          },
                                          onGallerySelected: () async {
                                            final file = await pickImageCommon(
                                              'gallery',
                                            );
                                            if (file != null) {
                                              field.trophyImage = file;
                                              field.trophyImageFileName = file.path.split('/').last;
                                              controller.update();
                                            }
                                          },
                                        ),
                                  );
                                },
                                child: Container(
                                  height: 20.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ThemeProvider.whiteColor,
                                    borderRadius: BorderRadius.circular(2.h),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          AssetPath.uploadIcon
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),

                                      IntrinsicWidth(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical:1.h,horizontal: 4.w),
                                          height: 4.5.h,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ThemeProvider.primary
                                              )
                                          ),
                                          child: Center(
                                            child: CommonTextWidget(
                                              maxLines: 1,
                                              textOverflow: TextOverflow.ellipsis,
                                              heading: field.trophyImageFileName ??"Browse files".tr,
                                              fontSize:Utils.responsiveFontSize(context, 16.sp),
                                              color: ThemeProvider.primary,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),

                              Button(
                                  color: ThemeProvider.redColor,
                                  onPressed: () {
                                    controller.removeTrophyField(index);
                                  }, title: "Remove".tr),
                              SizedBox(height: 2.h),
                            ],
                          );
                        }).toList(),
                      ),
                    )),
                       /* ...controller.trophies.asMap().entries.map((entry) {
                          final index = entry.key;
                          final field = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Trophy Name
                              CustomTextField(
                                controller: field.trophyNameController,
                                textInputStyle: TextStyle(
                                  color: ThemeProvider.hintText,
                                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                                  fontFamily: 'Montserrat',
                                ),
                                hintText: "Trophy Name".tr,
                              ),
                              SizedBox(height: 2.h),

                              //Trophy Name
                              CustomTextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter.deny(RegExp(r'\s'))
                                ],
                                keyboardType: TextInputType.number,
                                controller: field.trophyYearController,
                                textInputStyle: TextStyle(
                                  color: ThemeProvider.hintText,
                                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                                  fontFamily: 'Montserrat',
                                ),
                                hintText: "Trophy Year".tr,
                              ),
                              SizedBox(height: 2.h),
                              CommonTextWidget(
                                textAlign: TextAlign.start,
                                heading: "Trophy Icon".tr,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontWeight: FontWeight.w600,
                                color: ThemeProvider.whiteColor,
                                fontFamily: "Montserrat",
                              ),
                              SizedBox(height: 2.h),

                              InkWell(
                                onTap:(){
                                  showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        ImageSourceActionSheet(
                                          onCameraSelected: () async {
                                            final file = await pickImageCommon(
                                              'camera',
                                            );
                                            if (file != null) {
                                              field.trophyImage = file;
                                              field.trophyImageFileName = file.path.split('/').last;
                                              controller.update();
                                            }
                                          },
                                          onGallerySelected: () async {
                                            final file = await pickImageCommon(
                                              'gallery',
                                            );
                                            if (file != null) {
                                              field.trophyImage = file;
                                              field.trophyImageFileName = file.path.split('/').last;
                                              controller.update();
                                            }
                                          },
                                        ),
                                  );
                                },
                                child: Container(
                                  height: 20.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ThemeProvider.whiteColor,
                                    borderRadius: BorderRadius.circular(2.h),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          AssetPath.uploadIcon
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),

                                      IntrinsicWidth(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical:1.h,horizontal: 4.w),
                                          height: 4.5.h,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ThemeProvider.primary
                                              )
                                          ),
                                          child: Center(
                                            child: CommonTextWidget(
                                              maxLines: 1,
                                              textOverflow: TextOverflow.ellipsis,
                                              heading: field.trophyImageFileName ??"Browse files".tr,
                                              fontSize:Utils.responsiveFontSize(context, 16.sp),
                                              color: ThemeProvider.primary,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),

                              Button(
                                  color: ThemeProvider.redColor,
                                  onPressed: () {
                                    controller.removeTrophyField(index);
                                  }, title: "Remove".tr),
                              SizedBox(height: 2.h),
                            ],
                          );
                        }),*/
                        Button(
                            color: ThemeProvider.greenColor,
                            onPressed: () {
                              controller.addNewTrophyField();
                            }, title: "Add Trophy".tr),
                        SizedBox(height: 2.h),
                      ],
                    ),



                    ///Add Player
                    Button(
                        onPressed: () {
                          if (controller.profileImageFile == null &&
                              controller.profileImageUrl == null) {
                            controller.scrollToField(profileImageKey);
                            errorToast("Please upload a profile image");
                            return;
                          }

                          if (!controller.areAllCareerFieldsCompleted()) {
                            controller.scrollToField(controller.careerKey);
                            successToast("Please complete all career fields.");
                            return;
                          }

                          if (!controller.areAllYoutubeFieldsCompleted()) {
                            controller.scrollToField(controller.youtubeKey);
                            successToast("Please fill all existing YouTube links");
                            return;
                          }

                          if (!controller.areAllTrophyFieldsCompleted()) {
                            controller.scrollToField(controller.trophiesKey);
                            successToast("Please fill all existing trophy fields.");
                            return;
                          }

                          if(_formKey.currentState!.validate()){
                            if(controller.mode == "edit"){
                              controller.editPlayerApi(context);
                            }else{
                              controller.addPlayerApi(context);
                            }
                          }else {
                            // Find which field failed and scroll to it
                            if (controller.firstNameController.text.isEmpty) {
                              controller.scrollToField(controller.firstNameKey);
                            } else if (controller.lastNameController.text.isEmpty) {
                              controller.scrollToField(controller.lastNameKey);
                            } else if (!Validators.isEmailValid(controller.emailController.text)) {
                              controller.scrollToField(controller.emailKey);
                            } else if (controller.dobController.text.isEmpty) {
                              controller.scrollToField(controller.dobKey);
                            }
                          }


                          // showCommonDialog(
                          //   backgroundColor: ThemeProvider.whiteColor,
                          //   showCloseButton: true,
                          //   context: context,
                          //   title: "Successfully Updated !",
                          //   titleColor: ThemeProvider.blackColor,
                          //   messageColor: ThemeProvider.textColor,
                          //   message: "Your video has been uploaded and is now available in your library.",
                          //   svgAsset: AssetPath.successFilled,
                          // );
                        }, title:controller.mode == "edit"
                        ?"Update Player"
                        :"Add Player".tr,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }


  //pick date only
//pick date only
  pickedDateOnly(
      BuildContext context,
      TextEditingController textController,
      AddPlayerScreenLogic controller, {
        String type = 'past', // 'past', 'future', 'both'
      }) async {
    DateTime initialDate;

    // If already selected earlier, use that date as initial date
    if (textController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('MMMM dd, yyyy').parse(textController.text);
      } catch (_) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    DateTime firstDate;
    DateTime lastDate;

    // ✅ Date range logic
    switch (type) {
      case 'future':
        firstDate = DateTime.now();
        lastDate = DateTime.now().add(const Duration(days: 365 * 5));
        break;

      case 'both':
        firstDate = DateTime(DateTime.now().year - 100);
        lastDate = DateTime.now();
        break;

      default: // 'past'
        firstDate = DateTime(DateTime.now().year - 100);
        lastDate = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('MMMM dd, yyyy').format(pickedDate);
      textController.text = formattedDate;
      //controller.dobController = textController;

      // ✅ Age validation ONLY for DOB
      if (type == 'past' && textController == controller.dobController) {
        int age = calculateAge(pickedDate);
        if (age < 3) {
          errorToast("Player must be at least 3 years old.");
          textController.clear();
          return;
        }

        controller.playerAge = age;
        controller.playerIsMinor.value = age < 18;
        controller.update();

        debugPrint("Age: $age, Minor: ${controller.playerIsMinor.value}");
      }

      debugPrint("Selected date: $formattedDate");
    } else {
      debugPrint("Date selection canceled");
    }
  }


  Widget browseFilesWidget({
    required BuildContext context,
    required String? fileName,
    required Function(File) onFileSelected,
    required Function(String) onFileNameSelected,
  }) {
    return Container(
      height: 20.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeProvider.whiteColor,
        borderRadius: BorderRadius.circular(2.h),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SvgPicture.asset(
          AssetPath.uploadIcon
      ),
      SizedBox(
        height: 2.h,
      ),
      GestureDetector(
        onTap: () async {
          File? file = await pickPdfFile();

          if (file != null) {
            onFileSelected(file);
            onFileNameSelected(file.path.split('/').last);
          }
        },
        child: Container(
          width: Get.width / 2,
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          height: 4.5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ThemeProvider.primary),
          ),
          child: Center(
            child: CommonTextWidget(
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              heading: fileName ?? "Browse files".tr,
              fontSize: Utils.responsiveFontSize(context, 16.sp),
              color: ThemeProvider.primary,
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat",
            ),
          ),
        ),
      ),
      ]
      )
    );
  }

}
