import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/profile/profile_controller.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:scouttalent2/widget/common_back_button.dart';
import 'package:scouttalent2/widget/custom_text_field.dart';
import 'package:sizer/sizer.dart';
import '../../utils/app_assets.dart';
import '../../utils/constants.dart';
import '../../utils/imagePickFunction.dart';
import '../../utils/imageSourceSheet.dart';
import '../../utils/string.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../utils/validation.dart';
import '../../widget/commontext.dart';
import '../../widget/customDropDown.dart';
import '../../widget/editDetailsBottomSheet.dart';
import '../../widget/multipleSeletionDropDown.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final controller = Get.find<ProfileController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadUserProfile(Get.context!);
    // if (controller.hasPrefilledCareerStats) {
    //   controller.addNewCareerFieldSet();
    // }

  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        builder: (logic) {
      return Scaffold(
        backgroundColor: ThemeProvider.bgColor,
        appBar: AppBar(
          leading: CommonBackButton(onTap: () => Get.back()),
          backgroundColor: ThemeProvider.bgColor,
          title: Text(
            "Profile".tr,
            style: TextStyle(
              color: ThemeProvider.whiteColor,
              fontFamily: 'Montserrat',
            ),
          ),
        ),

        /// ✅ Obx used ONLY where .obs is read
        body: Obx(() {
          if (controller.profile.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(child: _ProfileForm(controller: controller));
        }),
      );
    });
  }
}

class _ProfileForm extends StatefulWidget {
  final ProfileController controller;

  const _ProfileForm({required this.controller});

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  @override
  Widget build(BuildContext context) {
    final isPlayerRole =
        widget.controller.parser.sharedPreferencesManager.getString(
          'selectedUserRole',
        ) ==
            Constants.userRolePlayer;

    final isBasicInfoComplete =
        widget.controller.firstNameController.text.trim().isNotEmpty &&
            widget.controller.lastNameController.text.trim().isNotEmpty &&
            widget.controller.emailController.text.trim().isNotEmpty &&
            widget.controller.phoneNumController.text.trim().isNotEmpty;

    final isPlayerProfileComplete =
        widget.controller.firstNameController.text.trim().isNotEmpty &&
            widget.controller.lastNameController.text.trim().isNotEmpty &&
            widget.controller.emailController.text.trim().isNotEmpty &&
            widget.controller.playerAgeController.text.trim().isNotEmpty &&
            widget.controller.phoneNumController.text.trim().isNotEmpty &&
            widget.controller.countyNameController.text.trim().isNotEmpty &&
            widget.controller.selectedNationalityOption != null &&
            widget.controller.countryCodeController.text.trim().isNotEmpty &&
            widget.controller.selectedPosition != null &&
            widget.controller.selectedSecondaryPositions.isNotEmpty &&
            widget.controller.selectedTechnicalAttributes.isNotEmpty &&
            widget.controller.selectedPlayingStyle.isNotEmpty &&
            widget.controller.playerHeightController.text.trim().isNotEmpty &&
            widget.controller.playerWeightController.text.trim().isNotEmpty &&
            widget.controller.selectedPreferredFoot.value != null &&
            widget.controller.selectedExperienceLevel.value != null &&
            widget.controller.selectedConsistency.value != null &&
            widget.controller.clubController.text.trim().isNotEmpty &&
            widget.controller.squadNumController.text.trim().isNotEmpty &&
            widget.controller.competitionLevelENController.text.trim().isNotEmpty &&
            widget.controller.competitionLevelROController.text.trim().isNotEmpty &&
            widget.controller.startContractDateController.text.trim().isNotEmpty &&
            widget.controller.endContractDateController.text.trim().isNotEmpty &&
            widget.controller.SelectedtransferStatus != null;

    final shouldShowCheckmark =
    isPlayerRole ? isPlayerProfileComplete : isBasicInfoComplete;
    return Form(
      key: widget.controller.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [

            /// Profile Image Picker (GetBuilder)
            GetBuilder<ProfileController>(
              builder: (c) => _profileImagePicker(context, c),
            ),

            SizedBox(height: 6.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isPlayerRole && widget.controller.personalInfoCompleted)
                  const Padding(
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

            /// First Name
            KeyedSubtree(
              key: widget.controller.firstNameKey,
              child: CustomTextField(
                controller: widget.controller.firstNameController,
                textInputStyle: _textStyle(context),
                hintText: "First Name".tr,
                validator: (v) =>
                v == null || v.isEmpty ? "Enter your first name".tr : null,
              ),
            ),
            SizedBox(height: 2.h),

            /// Last Name
            KeyedSubtree(
              key: widget.controller.lastNameKey,
              child: CustomTextField(
                controller: widget.controller.lastNameController,
                textInputStyle: _textStyle(context),
                hintText: "Last Name".tr,
                validator: (v) =>
                v == null || v.isEmpty ? "Enter your last name".tr : null,
              ),
            ),
            SizedBox(height: 2.h),

            /// Email
            KeyedSubtree(
              key: widget.controller.emailKey,
              child: CustomTextField(
                readOnly: true,

                controller: widget.controller.emailController,
                textInputStyle: _textStyle(context),
                hintText: "Email".tr,
              ),
            ),
            SizedBox(height: 2.h),

            /// Phone
            CustomTextField(
              controller: widget.controller.phoneNumController,
              keyboardType: TextInputType.phone,
              textInputStyle: _textStyle(context),
              hintText: "Contact Number".tr,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !Validators.isPhoneValid(value)) {
                  return 'Enter a valid contact number'.tr;
                }
                return null;
              },
              // inputFormatters: [
              //   FilteringTextInputFormatter.digitsOnly, // ✅ Only digits allowed
              // ],
            ),
            SizedBox(height: 2.h),

            (widget.controller.parser.sharedPreferencesManager.getString(
              'selectedUserRole',
            ) ==
                Constants.userRolePlayer)
                ? playerInfo(context, widget.controller)
                : CustomTextField(
              controller: widget.controller.clubController,
              keyboardType: TextInputType.text,
              textInputStyle: _textStyle(context),
              hintText: "Name of Club".tr,

              // inputFormatters: [
              //   FilteringTextInputFormatter.digitsOnly, // ✅ Only digits allowed
              // ],
            ),
            SizedBox(height: 2.h),

            /*(widget.controller.parser.sharedPreferencesManager.getString(
              'selectedUserRole',
            ) ==
                Constants.userRoleClubScout)
                ? CustomTextField(
              controller: widget.controller.teamController,
              keyboardType: TextInputType.text,
              textInputStyle: _textStyle(context),
              hintText: "Current Team".tr,

              // inputFormatters: [
              //   FilteringTextInputFormatter.digitsOnly, // ✅ Only digits allowed
              // ],
            )
                : SizedBox(),

            (widget.controller.parser.sharedPreferencesManager.getString(
              'selectedUserRole',
            ) ==
                Constants.userRoleClubScout)
                ?SizedBox(
              height: 2.h,
            )
            :SizedBox.shrink(),*/
            // Agency
            /* CustomTextField(
              controller: controller.agencyController,
              textInputStyle: _textStyle(context),
              hintText: "Name of agency".tr,
            ),*/
            //SizedBox(height: 6.h),

            // Update Button
            Button(
              title: "Update".tr,
              onPressed: () {
                print("widget.controller.selectedRelation--->${widget.controller.selectedRelation}");
                if (!widget.controller.areAllCareerFieldsCompleted()) {
                  print("❌ Stopped: Career fields incomplete");

                  widget.controller.scrollToField(widget.controller.careerKey);
                  successToast("Please complete all career fields.");
                  return;
                }

                if (!widget.controller.areAllYoutubeFieldsCompleted()) {
                  print("❌ Stopped: Career fields incomplete");

                  widget.controller.scrollToField(widget.controller.youtubeKey);
                  successToast("Please fill all existing YouTube links");
                  return;
                }

                if (!widget.controller.areAllTrophyFieldsCompleted()) {
                  print("❌ Stopped: Trophy fields incomplete");
                  widget.controller.scrollToField(widget.controller.trophiesKey);
                  successToast("Please fill all existing trophy fields.");
                  return;
                }
                if (isPlayerRole && widget.controller.isUnder18.value == true && (widget.controller.parentFirstName.text.isEmpty||
                    widget.controller.parentLastName.text.isEmpty||
                    widget.controller.parentEmail.text.isEmpty||
                    widget.controller.parentPhone.text.isEmpty||
                    widget.controller.selectedRelation == null)
                ) {
                  print("❌ Stopped: Parent details incomplete");
                  successToast("Please fill parent details.");
                  widget.controller.scrollToField(widget.controller.parentsKey);
                  return;
                }

                if (widget.controller.formKey.currentState!.validate()) {
                  print("✅ Passed: Form validation success");
                  widget.controller.updateProfile(context);
                  Get.back();
                }else {
                  // Find which field failed and scroll to it
                  if (widget.controller.firstNameController.text.isEmpty) {
                    widget.controller.scrollToField(widget.controller.firstNameKey);
                  } else if (widget.controller.lastNameController.text.isEmpty) {
                    widget.controller.scrollToField(widget.controller.lastNameKey);
                  } else if (!Validators.isEmailValid(widget.controller.emailController.text)) {
                    widget.controller.scrollToField(widget.controller.emailKey);
                  } else if (widget.controller.dobController.text.isEmpty) {
                    widget.controller.scrollToField(widget.controller.dobKey);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// PROFILE IMAGE PICKER
  /// -------------------------------------------------------------------------
  Widget _profileImagePicker(BuildContext context,
      ProfileController controller,) {
    final apiImage = controller.profile.value?.data?.avatar;

    ImageProvider? imageProvider;

    if (controller.pickedImage != null) {
      imageProvider = FileImage(controller.pickedImage!);
    } else if (apiImage != null && apiImage.isNotEmpty) {
      imageProvider = NetworkImage(Utils.imageUrl + apiImage);
    }

    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (_) =>
              ImageSourceActionSheet(
                onCameraSelected: () async {
                  final file = await pickImageCommon('camera');
                  if (file != null) controller.setProfileImage(file);
                },
                onGallerySelected: () async {
                  final file = await pickImageCommon('gallery');
                  if (file != null) controller.setProfileImage(file);
                },
              ),
        );
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Icon(Icons.person, size: 42, color: Colors.grey.shade400)
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ThemeProvider.whiteColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget playerInfo(BuildContext context, ProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.h,
      children: [
        CommonTextWidget(
          heading: 'We need a bit more information to continue..',
          color: ThemeProvider.whiteColor,
          fontSize: Utils.responsiveFontSize(context, 16.sp),
          fontWeight: FontWeight.w400,
          fontFamily: 'Montserrat',
          textAlign: TextAlign.start,
        ),

        KeyedSubtree(
          key: widget.controller.dobKey,
          child: CustomTextField(
            showReadOnlyColor: false,
            readOnly: true,
            ontap: () => controller.pickDob(context,controller.playerAgeController),
            controller: controller.playerAgeController,
            keyboardType: TextInputType.phone,
            textInputStyle: _textStyle(context),
            hintText: "Player Age".tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your date of birth'.tr;
              }
              return null;
            },
          ),
        ),

        CustomTextField(
          controller: controller.playerHeightController,
          keyboardType: TextInputType.phone,
          textInputStyle: _textStyle(context),
          hintText: "Player Height".tr,
          validator: (v) {
            return null;
          },
        ),

        CustomTextField(
          controller: controller.playerWeightController,
          keyboardType: TextInputType.phone,
          textInputStyle: _textStyle(context),
          hintText: "Player Weight".tr,
          validator: (v) {
            return null;
          },
        ),

        /// Parent details — ONLY if age < 18
        Obx(() {
          final isPlayer =
              controller.parser.sharedPreferencesManager.getString(
                'selectedUserRole',
              ) ==
                  Constants.userRolePlayer;

          if (!isPlayer || !controller.isUnder18.value) {
            return const SizedBox(); // hide if not player OR age >= 18
          }

          return KeyedSubtree(
            key: controller.parentsKey,
            child: Column(
              spacing: 2.h,
              children: [
                CustomTextField(
                  controller: controller.parentFirstName,
                  keyboardType: TextInputType.name,
                  textInputStyle: _textStyle(context),
                  hintText: "Parent First Name".tr,
                ),

                CustomTextField(
                  controller: controller.parentLastName,
                  keyboardType: TextInputType.name,
                  textInputStyle: _textStyle(context),
                  hintText: "Parent Last Name".tr,
                ),

                CustomTextField(
                  controller: controller.parentEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputStyle: _textStyle(context),
                  hintText: "Parent Email".tr,
                ),

                CustomTextField(
                  controller: controller.parentPhone,
                  keyboardType: TextInputType.phone,
                  textInputStyle: _textStyle(context),
                  hintText: "Parent Phone".tr,
                ),
              /*  CustomDropdownButton(
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
                ),*/

                CustomDropdownButton(
                  hintText: "Relation".tr,
                  items: ['Father'.tr,'Mother'.tr,'Brother'.tr],
                  selectedValue:
                  controller.selectedRelation == null
                      ? null
                      : controller.selectedRelation == 'Father'
                      ? 'Father'.tr
                      : controller.selectedRelation == 'Mother'
                      ? 'Mother'.tr
                      : controller.selectedRelation == 'Brother'
                      ? 'Brother'.tr
                      : null,
                  onChanged: (value) {
                    if (value == null) return;
                    // Reverse map translated label → English key
                    final keyMap = {
                      'Father'.tr: 'Father',
                      'Mother'.tr: 'Mother',
                      'Brother'.tr: 'Brother',
                    };
                    controller
                        .updateSelectedRelation(
                        keyMap[value] ?? value
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
              ],
            ),
          );
        }),

        // CustomTextField(
        //   readOnly: true,
        //   controller: controller.countryController,
        //   textInputStyle: TextStyle(
        //     color: ThemeProvider.hintText,
        //     fontSize: Utils.responsiveFontSize(context, 16.sp),
        //     fontFamily: 'Montserrat',
        //   ),
        //   hintText: "Select Country".tr,
        //   suffixIcon: Icon(Icons.keyboard_arrow_down_outlined, size: 25),
        //   // ontap: () {
        //   //   showCountryPicker(
        //   //     context: context,
        //   //     showPhoneCode: false,
        //   //     onSelect: (Country country) {
        //   //       controller.countryController.text = country.name;
        //   //       controller.update();
        //   //     },
        //   //   );
        //   // },
        // ),
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

        CustomDropdownButton(
          translateItems: true,
          hintText: "Nationality (RO)",
          items: controller.nationalityOptions.map((p) => p.ro).toList(),
          selectedValue: controller.selectedNationalityOption?.ro,
          onChanged: (value) {
            controller.updateSelectedNationalityByRo(value.toString());
          },
          isExpanded: true,
        ),

        CustomTextField(
          controller: controller.teamController,
          keyboardType: TextInputType.text,
          textInputStyle: _textStyle(context),
          hintText: "Current Team".tr,

          // inputFormatters: [
          //   FilteringTextInputFormatter.digitsOnly, // ✅ Only digits allowed
          // ],
        ),

        //Squad Number
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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
        // Contract Status
        Obx(() {
          final dropdownItems = controller.transferStatus;
          return CustomDropdownButton(
            svgIconSize: 20,
            hintText: "Contract Status".tr,
            isExpanded: true,
            items: dropdownItems,

            selectedValue: controller.SelectedtransferStatus.value.isEmpty
                ? null
                : controller.SelectedtransferStatus.value,

            onChanged: (val) {
              if (val == null) return;
              controller.SelectedtransferStatus.value = val;
            },
          );
        }),

        // Select Playing Style
        Obx(() {
          final bool isEnglish = controller.selectedLanguage.value == "en";

          return MultiSelectDropdown(
            hintText: isEnglish ? 'Playing Style' : 'Stil de joc',

            items: controller.playingStyle
                .map((p) => isEnglish ? p.en : p.ro)
                .toList(),

            selectedValues: controller.selectedPlayingStyle
                .map((p) => isEnglish ? p.en : p.ro)
                .toList(),

            onChanged: (List<String> newSelectedValues) {
              controller.updateSelectedPlayingStyle(
                newSelectedValues,
                isEnglish,
              );
            },
          );
        }),

        // Select Technical Attributes
        Obx(() {
          return MultiSelectDropdown(
            hintText: controller.selectedLanguage.value == "en"
                ? 'Technical Attributes'
                : 'Atribute tehnice',
            items: controller.technicalAttributes
                .map(
                  (p) =>
              controller.selectedLanguage.value == "en" ? p.en : p.ro,
            )
                .toList(),
            selectedValues: controller.selectedTechnicalAttributes
                .map(
                  (p) =>
              controller.selectedLanguage.value == "en" ? p.en : p.ro,
            )
                .toList(),
            onChanged: (List<String> newSelectedValues) {
              final bool isEnglish = controller.selectedLanguage.value == "en";
              controller.updateSelectedTechnicalAttributes(
                newSelectedValues,
                isEnglish,
              );
            },
          );
        }),

        // Select Experience Level
        Obx(() {
          final selectedKey = controller.selectedExperienceLevel.value;

          return CustomDropdownButton(
            hintText: 'Experience Level'.tr,
            items: controller.experienceLevelMap.values.toList(),

            // 👇 correct prefilled value
            selectedValue: selectedKey.isEmpty
                ? null
                : controller.experienceLevelMap[selectedKey],

            onChanged: (value) {
              final key = controller.experienceLevelMap.entries
                  .firstWhere((e) => e.value == value)
                  .key;

              controller.selectedExperienceLevel.value = key;
            },
            isExpanded: true,
          );
        }),
        //Contract Start
        CustomTextField(
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(AssetPath.calender),
          ),
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
            pickedDateOnly(
              context,
              controller.startContractDateController,
              controller,
              type: 'both',
            );
          },
        ),

        //Contract End
        CustomTextField(
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(AssetPath.calender),
          ),
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
        Obx(() {
          return CustomDropdownButton(
            hintText: 'Consistency'.tr,
            items: controller.consistencyMap.values.toList(),
            // localized UI values
            selectedValue: controller.selectedConsistency.value.isEmpty
                ? null
                : controller.consistencyMap[controller
                .selectedConsistency
                .value],
            onChanged: (value) {
              final selectedKey = controller.consistencyMap.entries
                  .firstWhere((e) => e.value == value)
                  .key;

              controller.updateSelectedConsistency(
                selectedKey,
              ); // save English key
            },
            isExpanded: true,
          );
        }),
        CustomTextField(
          controller: controller.countryCodeController,
          textInputStyle: TextStyle(
            color: ThemeProvider.hintText,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontFamily: 'Montserrat',
          ),
          hintText: "Country Code".tr,
          suffixIcon: Icon(Icons.keyboard_arrow_down_outlined, size: 25),
          ontap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: false,
              onSelect: (Country country) {
                controller.countryCodeController.text =
                    country.countryCode; // Save selected country
                controller.update();
              },
            );
          },
        ),

        // CustomTextField(
        //   controller: controller.careerMatchesController,
        //   textInputStyle: TextStyle(
        //     color: ThemeProvider.hintText,
        //     fontSize: Utils.responsiveFontSize(context, 16.sp),
        //     fontFamily: 'Montserrat',
        //   ),
        //   hintText: "Career Matches".tr,
        //   keyboardType: TextInputType.number,
        // ),
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

        //Secondary Position
        controller.selectedPosition == null
            ?SizedBox.shrink()
            :

        Obx(() {
          final isEnglish = controller.selectedLanguage.value == "en";

          return MultiSelectDropdown(
            hintText: isEnglish
                ? 'Secondary Position (EN)'
                : 'Poziție secundară (RO)',
            items: controller.secondaryPositions
                .map((p) => isEnglish ? p.en : p.ro)
                .toList(),
            selectedValues: controller.selectedSecondaryPositions
                .map((p) => isEnglish ? p.en : p.ro)
                .toList(),
            onChanged: (List<String> newSelectedValues) {
              controller.updateSelectedSecondaryPositions(
                newSelectedValues,
                isEnglish,
              );
            },
          );
        }),
        Obx(
              () =>
              CustomDropdownButton(
                hintText: 'Preferred Foot'.tr,
                items: controller.preferredFootMap.values.toList(),
                selectedValue: controller.selectedPreferredFoot.value.isEmpty
                    ? null
                    : controller.preferredFootMap[controller
                    .selectedPreferredFoot
                    .value],
                onChanged: (value) {
                  if (value == null) return;
                  final selectedKey = controller.preferredFootMap.entries
                      .firstWhere((e) => e.value == value)
                      .key;

                  controller.selectedPreferredFoot.value =
                      selectedKey; // ✅ must use .value
                },
                isExpanded: true,
              ),
        ),

        ///Add multiple career
        Obx(
              () =>
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // if (controller.fields.any(
                  //       (f) =>
                  //   f.careerSeasonController.text
                  //       .trim()
                  //       .isNotEmpty ||
                  //       f.careerClubController.text
                  //           .trim()
                  //           .isNotEmpty ||
                  //       f.careerMatchesController.text
                  //           .trim()
                  //           .isNotEmpty ||
                  //       f.careerGoalsController.text
                  //           .trim()
                  //           .isNotEmpty ||
                  //       f.careerMinutesController.text
                  //           .trim()
                  //           .isNotEmpty ||
                  //       f.careerAssistsController.text
                  //           .trim()
                  //           .isNotEmpty,
                  // ))
                  if (widget.controller.careerCompleted.value)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                          Icons.check_circle, color: Colors.green, size: 18),
                    ),
                  CommonTextWidget(
                    textAlign: TextAlign.start,
                    heading: "Career".tr,
                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                    fontWeight: FontWeight.w600,
                    color: ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                  ),
                ],
              ),
        ),

        Obx(
              () =>
              KeyedSubtree(
                key: controller.careerKey,
                child: Column(
                  children: controller.fields
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final field = entry.value;

                    return Column(
                      children: [
                        // Career Season
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

                        // Career Club
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

                        // Career Matches
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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

                        // Career Goals
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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

                        // Career Minutes
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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

                        // Career Assists
                        CustomTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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
              ),
        ),

        Button(
          color: ThemeProvider.greenColor,
          onPressed: () {
            controller.addNewCareerFieldSet();
          },
          title: "Add Career".tr,
        ),

        ///Stats
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
    /*            if ([
              controller.statsMatches.text,
              controller.goalsController.text,
              controller.assistsController.text,
              controller.minutesController.text,
            ].every(
                  (v) =>
              v
                  .trim()
                  .isNotEmpty &&
                  v.trim() != '0' &&
                  v.trim().toLowerCase() != 'null',
            ))*/
          if(widget.controller.statsCompleted.value)
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

        //Matches Played
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          keyboardType: TextInputType.number,
          controller: controller.statsMatches,
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

        //Goals
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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

        //Assists
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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

        //Minutes
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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

        ///National Team
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // if (controller.callUpsController.text
            //     .trim()
            //     .isNotEmpty &&
            //     controller.callUpsController.text.trim().toLowerCase() !=
            //         'null' &&
            //     controller.callUpsController.text.trim() != '0' &&
            //     controller.capsController.text
            //         .trim()
            //         .isNotEmpty &&
            //     controller.capsController.text.trim().toLowerCase() != 'null' &&
            //     controller.capsController.text.trim() != '0')
            if(widget.controller.nationalTeamCompleted.value)
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
        //Call Ups
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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
        //Caps
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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
            //       (v) =>
            //   v
            //       .trim()
            //       .isNotEmpty && v.trim().toLowerCase() != 'null',
            // ))
            if(widget.controller.performanceCompleted.value)
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

        //Pass Completion
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          keyboardType: TextInputType.number,
          controller: controller.passCompletionController,
          textInputStyle: TextStyle(
            color: ThemeProvider.hintText,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontFamily: 'Montserrat',
          ),
          hintText: "${'Pass Completion'.tr} %",
          validator: percentageValidator,
        ),

        //Duels Won
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          keyboardType: TextInputType.number,
          controller: controller.duelsWonController,
          textInputStyle: TextStyle(
            color: ThemeProvider.hintText,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontFamily: 'Montserrat',
          ),
          hintText: "${'Duels Won'.tr} %",
          validator:percentageValidator,
        ),

        //Pass Accuracy
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          keyboardType: TextInputType.number,
          controller: controller.passAccuracyController,
          textInputStyle: TextStyle(
            color: ThemeProvider.hintText,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontFamily: 'Montserrat',
          ),
          hintText: "${'Pass Accuracy'.tr} %",
          validator: percentageValidator,
        ),

        //Shots On Target
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          keyboardType: TextInputType.number,
          controller: controller.shotsOnTargetController,
          textInputStyle: TextStyle(
            color: ThemeProvider.hintText,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontFamily: 'Montserrat',
          ),
          hintText: "${"Shots On Target".tr} %",
          validator: percentageValidator,
        ),

        //Dribbles Completed
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          keyboardType: TextInputType.number,
          controller: controller.dribblesCompletedController,
          textInputStyle: TextStyle(
            color: ThemeProvider.hintText,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontFamily: 'Montserrat',
          ),
          hintText: "${"Dribbles Completed".tr} %",
          validator: percentageValidator,
        ),

        ///Youtube Links
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              final hasValidLink = controller.youtubeControllers.any((c) {
                final text = c.text.trim();
                return text.isNotEmpty && text.toLowerCase() != 'null';
              });

              return widget.controller.youtubeCompleted.value == true
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

        ///Documents
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (controller.apiCVFileName != null &&
                controller.apiCVFileName!.trim().isNotEmpty)
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
        //Medical upload
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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

        ///Achievements
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              // Helper function
             /* bool isFilled(String? value) =>
                  value != null &&
                      value
                          .trim()
                          .isNotEmpty &&
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
                      hasAnyTrophy;*/

              return widget.controller.achievementsCompleted.value
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

        //Matches
        CustomTextField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
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

        ///Add trophy
        Obx(
              () =>
              Column(
                children: controller.trophies
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final field = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trophy Name
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

                      // Trophy Year
                      CustomTextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
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
                        onTap: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (context) =>
                                ImageSourceActionSheet(
                                  onCameraSelected: () async {
                                    final file = await pickImageCommon(
                                        'camera');
                                    if (file != null) {
                                      field.trophyImage = file;
                                      field.trophyImageFileName = file.path
                                          .split('/')
                                          .last;
                                      controller.trophies
                                          .refresh(); // 🔥 important
                                    }
                                  },
                                  onGallerySelected: () async {
                                    final file = await pickImageCommon(
                                        'gallery');
                                    if (file != null) {
                                      field.trophyImage = file;
                                      field.trophyImageFileName = file.path
                                          .split('/')
                                          .last;
                                      controller.trophies
                                          .refresh(); // 🔥 important
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
                              SvgPicture.asset(AssetPath.uploadIcon),
                              SizedBox(height: 2.h),

                              IntrinsicWidth(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.h,
                                    horizontal: 4.w,
                                  ),
                                  height: 4.5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: ThemeProvider.primary,
                                    ),
                                  ),
                                  child: Center(
                                    child: CommonTextWidget(
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                      heading:
                                      field.trophyImageFileName ??
                                          "Browse files".tr,
                                      fontSize: Utils.responsiveFontSize(
                                        context,
                                        16.sp,
                                      ),
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

                      SizedBox(height: 2.h),

                      Button(
                        color: ThemeProvider.redColor,
                        onPressed: () => controller.removeTrophyField(index),
                        title: "Remove".tr,
                      ),
                      SizedBox(height: 2.h),
                    ],
                  );
                }).toList(),
              ),
        ),
        Button(
          color: ThemeProvider.greenColor,
          onPressed: () {
            controller.addNewTrophyField();
          },
          title: "Add Trophy".tr,
        ),
        //SizedBox(height: 2.h),
      ],
    );
  }

  TextStyle _textStyle(BuildContext context) {
    return TextStyle(
      color: ThemeProvider.hintText,
      fontSize: Utils.responsiveFontSize(context, 16.sp),
      fontFamily: 'Montserrat',
    );
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
        SvgPicture.asset(AssetPath.uploadIcon),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () async {
            File? file = await pickPdfFile();

            if (file != null) {
              onFileSelected(file);
              onFileNameSelected(file.path
                  .split('/')
                  .last);
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
      ],
    ),
  );
}

pickedDateOnly(BuildContext context,
    TextEditingController textController,
    ProfileController controller, {
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
      firstDate = DateTime(DateTime
          .now()
          .year - 100);
      lastDate = DateTime.now();
      break;

    default: // 'past'
      firstDate = DateTime(DateTime
          .now()
          .year - 100);
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

      // controller.playerAge = age;
      controller.playerIsMinor.value = age < 18;
      controller.update();

      debugPrint("Age: $age, Minor: ${controller.playerIsMinor.value}");
    }

    debugPrint("Selected date: $formattedDate");
  } else {
    debugPrint("Date selection canceled");
  }
}
