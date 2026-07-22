import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/view/profile/profile_controller.dart';
import 'package:sizer/sizer.dart';
import '../../backend/model/all_trials_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../utils/webViewOpen.dart';
import '../../widget/common_back_button.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/video_thumb.dart';
import '../trials/trials_logic.dart';

class CreateTrialScreen extends StatefulWidget {
  const CreateTrialScreen({super.key});

  @override
  State<CreateTrialScreen> createState() => _CreateTrialScreenState();
}

class _CreateTrialScreenState extends State<CreateTrialScreen> {
  final TrialsLogic logic = Get.find<TrialsLogic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final List<TextEditingController> drillControllers = List.generate(4, (index) => TextEditingController());

  AllTrialList? existingTrial;

  @override
  void initState() {
    super.initState();

    existingTrial = Get.arguments as AllTrialList?;

    if (existingTrial != null) {
      // ✅ Edit mode
      _prefillData(existingTrial!);

      // set existing video once
    } else {
      // ✅ Create mode
      logic.existingVideo.value = '';
      logic.videoPath.value = '';
      logic.startDate.value = null; // ✅ reset
      logic.endDate.value = null; // ✅ reset
      logic.profileImage.value = null;
      logic.existingAvatar.value = '';
      logic.selectedCategory.value = '';
    }
  }

  void _prefillData(AllTrialList trial) {
    nameController.text = trial.name ?? "";
    descController.text = trial.description ?? "";
    logic.trialName.value = trial.name ?? "";
    logic.description.value = trial.description ?? "";
    logic.startDate.value = trial.startDate;
    logic.endDate.value = trial.endDate;
    logic.videoPath.value = "";
    logic.existingVideo.value = trial.video?.toString() ?? '';
    logic.existingAvatar.value = trial.createdByUser?.avatar?.toString() ?? '';
    logic.drillSkills[0] = trial.drillOne ?? "";
    logic.drillSkills[1] = trial.drillTwo ?? "";
    logic.drillSkills[2] = trial.drillThree ?? "";
    logic.drillSkills[3] = trial.drillFour ?? "";
    logic.selectedCategory.value = trial.category ?? '';
    for (int i = 0; i < 4; i++) {
      drillControllers[i].text = logic.drillSkills[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ThemeProvider.bgColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CommonBackButton(onTap: () => Get.back()),
        ),
        backgroundColor: ThemeProvider.bgColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(5.w, 0.w, 5.w, MediaQuery.of(context).viewInsets.bottom + 5.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------- PROFILE IMAGE --------

                // Center(
                //   child: Container(
                //     height: Get.size.height * 0.15,
                //     width: 110,
                //     decoration: BoxDecoration(
                //       color: Colors.grey.shade200,
                //       borderRadius: BorderRadius.circular(12),
                //       image: (existingTrial?.createdByUser?.avatar?.isNotEmpty ?? false)
                //           ? DecorationImage(
                //         image: NetworkImage(
                //           Utils.imageUrl + (existingTrial!.createdByUser!.avatar ?? ""),
                //         ),
                //         fit: BoxFit.cover,
                //       )
                //           : null,
                //     ),
                //     child: (existingTrial?.createdByUser?.avatar?.isEmpty ?? true)
                //         ? const Center(
                //       child: Icon(
                //         Icons.person,
                //         size: 36,
                //         color: Colors.black54,
                //       ),
                //     )
                //         : null,
                //   ),
                // ),

                //
                SizedBox(height: 1.h),

                // -------- TRIAL NAME --------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(heading: existingTrial != null ? "Edit Trial".tr : "Create Trial".tr, fontSize: 20, color: Colors.white),

                    SizedBox(height: 2.h),

                    CustomTextField(
                      controller: nameController,
                      hintText: "Enter title of trial".tr,
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        color: ThemeProvider.hintText,
                        fontWeight: FontWeight.w400,
                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                      ),
                      onChanged: (v) => logic.trialName.value = v,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Trial name is required".tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // -------- VIDEO UPLOAD BOX --------
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      // Open dialog to pick/capture video
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CommonTextWidget(
                                textAlign: TextAlign.center,
                                heading: "DISCLAIMER".tr,
                                fontSize: Utils.responsiveFontSize(context, 15.sp),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: "Montserrat",
                              ),
                              const SizedBox(height: 4),
                              CommonTextWidget(
                                textAlign: TextAlign.center,
                                heading: "Please ensure the video is in landscape mode and does not exceed 10 minutes in length.".tr,
                                fontSize: Utils.responsiveFontSize(context, 15.sp),
                                fontWeight: FontWeight.w500,
                                color: ThemeProvider.blackColor,
                                fontFamily: "Montserrat",
                              ),

                              const SizedBox(height: 6),

                              // Gallery Option
                              InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => logic.pickVideo(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.video_library, color: Colors.orange),
                                      SizedBox(width: 12),
                                      CommonTextWidget(heading: "Gallery", fontSize: 14, color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Camera Option
                              InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => logic.captureVideo(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.videocam, color: Colors.orange),
                                      SizedBox(width: 12),
                                      CommonTextWidget(heading: "Upload New Video", fontSize: 14, color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: ThemeProvider.whiteColor,
                        // White background visible
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display text
                          CommonTextWidget(
                            color: ThemeProvider.textColor,
                            heading: logic.videoPath.isNotEmpty
                                ? "Video Selected:\n${p.basename(logic.videoPath.value)}"
                                : logic.existingVideo.isNotEmpty
                                ? "Existing Video Selected".tr
                                : "Add Explanation Video".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),

                          SizedBox(height: 2.h),
                          // Display thumbnail
                          Container(
                            height: Get.size.height * 0.2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white, // keep white background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: logic.videoPath.isNotEmpty
                                ? SizedBox() // New video
                                : logic.existingVideo.isNotEmpty
                                ? VideoThumb(videoUrl: Utils.trialVideo + logic.existingVideo.value, thumbnail: "") // Existing video
                                : Center(child: SvgPicture.asset(AssetPath.upload)), // No video
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // -------- DESCRIPTION --------
                CustomTextField(
                  maxLines: 5,
                  controller: descController,
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    color: ThemeProvider.hintText,
                    fontWeight: FontWeight.w400,
                    fontSize: Utils.responsiveFontSize(context, 14.sp),
                  ),
                  hintText: "Description".tr,
                  onChanged: (v) => logic.description.value = v,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description is required".tr;
                    }
                    if (value.trim().length < 10) {
                      return "Description must be at least 10 characters".tr;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 2.h),

                // -------- START & END DATES --------
                Column(
                  children: [
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeProvider.whiteColor,
                            foregroundColor: ThemeProvider.blackColor,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => logic.pickStartDate(context),
                          child: Text(
                            logic.startDate.value != null ? formatDateUI(logic.startDate.value!) : "Select Start Date".tr,

                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              color: ThemeProvider.hintText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeProvider.whiteColor,
                            foregroundColor: ThemeProvider.blackColor,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => logic.pickEndDate(context),
                          child: Text(
                            logic.endDate.value != null ? formatDateUI(logic.endDate.value!) : "Select End Date".tr,

                            style: TextStyle(
                              fontFamily: 'regular',
                              fontWeight: FontWeight.w400,
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              color: ThemeProvider.hintText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                CommonTextWidget(heading: "Category".tr, color: Colors.white, fontSize: 14.sp),

                SizedBox(height: 2.h),

                Obx(
                  () => Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: ThemeProvider.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: logic.selectedCategory.value.isEmpty ? null : logic.selectedCategory.value,
                        hint: Text("Select Position".tr),
                        isExpanded: true,
                        items: logic.trialCategories.map((cat) {
                          return DropdownMenuItem(
                            value: cat, // <-- English key stays here
                            child: Text(cat.tr), // <-- translated text for display
                          );
                        }).toList(),
                        onChanged: (value) {
                          logic.selectedCategory.value = value?.trim() ?? '';
                          logic.selectedCategoryRo.value =
                              logic.getRoTranslation(value!).toLowerFirst();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: Text("${index + 1}", style: TextStyle(color: ThemeProvider.hintText, fontSize: 18)),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CustomTextField(
                              controller: drillControllers[index],
                              hintText: "e.g Agility Drill".tr,
                              onChanged: (v) => logic.drillSkills[index] = v,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "skill_required".trParams({"index": "${index + 1}"});
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // -------- TERMS & CONDITIONS --------
                existingTrial == null ? termsAndConditionsCheckbox() : SizedBox(),

                SizedBox(height: 2.h),

                // -------- SAVE BUTTON --------
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (logic.selectedCategory.value.trim().isEmpty) {
                          errorToast("Please select Trial Category");
                          return;
                        }

                        if (existingTrial == null && !logic.isTermsAccepted.value) {
                          errorToast("Please accept Terms & Conditions");
                          return;
                        }
                        if (logic.startDate.value == null || logic.endDate.value == null) {
                          Get.snackbar("Error", "Please select start and end dates", backgroundColor: Colors.red, colorText: Colors.white);
                          return;
                        }

                        if (logic.startDate.value!.isAfter(logic.endDate.value!)) {
                          errorToast("Start date cannot be after End date",);
                          return;
                        }
                        final List<String> drillSkills = drillControllers.map((controller) => controller.text.trim()).toList();
                        // Upload or Edit
                        if (existingTrial != null) {
                          await logic.editTrial(
                            category: logic.selectedCategory.value.toLowerCase(),
                            roCategory: logic.selectedCategoryRo.value,
                            trialId: existingTrial!.id!,
                            videoFilePath: logic.videoPath.value.isEmpty ? null : logic.videoPath.value,
                            name: nameController.text.trim(),
                            description: descController.text.trim(),
                            startDate:
                                "${logic.startDate.value!.year.toString().padLeft(4, '0')}-"
                                "${logic.startDate.value!.month.toString().padLeft(2, '0')}-"
                                "${logic.startDate.value!.day.toString().padLeft(2, '0')}",
                            endDate:
                                "${logic.endDate.value!.year.toString().padLeft(4, '0')}-"
                                "${logic.endDate.value!.month.toString().padLeft(2, '0')}-"
                                "${logic.endDate.value!.day.toString().padLeft(2, '0')}",
                            drillOne: drillSkills[0],
                            drillTwo: drillSkills[1],
                            drillThree: drillSkills[2],
                            drillFour: drillSkills[3],
                          );
                        } else {
                          if (logic.videoPath.value.isEmpty) {
                            errorToast("Please Select Video to Proceed");
                            return;
                          }
                          await logic.uploadTrial(
                            videoFilePath: logic.videoPath.value,
                            name: nameController.text.trim(),
                            description: descController.text.trim(),
                            category: logic.selectedCategory.value.toLowerCase(),
                            roCategory: logic.selectedCategoryRo.value,
                            startDate:
                                "${logic.startDate.value!.year.toString().padLeft(4, '0')}-"
                                "${logic.startDate.value!.month.toString().padLeft(2, '0')}-"
                                "${logic.startDate.value!.day.toString().padLeft(2, '0')}",
                            endDate:
                                "${logic.endDate.value!.year.toString().padLeft(4, '0')}-"
                                "${logic.endDate.value!.month.toString().padLeft(2, '0')}-"
                                "${logic.endDate.value!.day.toString().padLeft(2, '0')}",
                            drillOne: drillSkills[0],
                            drillTwo: drillSkills[1],
                            drillThree: drillSkills[2],
                            drillFour: drillSkills[3],
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.primary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: CommonTextWidget(
                        color: ThemeProvider.whiteColor,
                        fontWeight: FontWeight.w500,
                        heading: existingTrial != null ? "Update Trial" : "Publish Trial",
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDateUI(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year.toString().substring(2)}";
  }

  Widget termsAndConditionsCheckbox() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            value: logic.isTermsAccepted.value,
            onChanged: (value) {
              logic.isTermsAccepted.value = value ?? false;
            },
            activeColor: ThemeProvider.primary,
            checkColor: Colors.white,
            side: const BorderSide(color: Colors.white, width: 2),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 13.sp, height: 1.2),
                children: [
                  TextSpan(text: "I agree to ".tr),
                  TextSpan(
                    text: "Terms & Conditions".tr,
                    style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
                    recognizer:  TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewOpen(webViewUrl: "https://scouttalentworld.com/terms-and-conditions")));
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
