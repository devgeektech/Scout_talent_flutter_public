import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:scouttalent2/widget/common_back_button.dart';
import 'package:scouttalent2/widget/commontext.dart';
import 'package:scouttalent2/widget/editDetailsBottomSheet.dart';
import 'package:sizer/sizer.dart';
import '../../widget/customDropDown.dart';
import '../../widget/custom_text_field.dart';
import '../profile/profile_controller.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final controller = Get.find<ProfileController>();
  final FocusNode noteFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    //controller.getClubPlayersApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSavePlayerList(context, page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.bgColor,
      appBar: AppBar(
        leading: CommonBackButton(onTap: () => Get.back()),
        backgroundColor: ThemeProvider.bgColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Scrollable form area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------- PLAYER DROPDOWN --------
                      Obx(() {
                        final dropdownItems = controller.savedPlayerList;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget(
                              heading: "Notes".tr,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            SizedBox(height: 2.h),
                            CustomDropdownButton(
                              svgIconPath: AssetPath.search, // your SVG path
                              svgIconSize: 20,
                              hintText: "Search/Select Player".tr,
                              isExpanded: true,
                              items: dropdownItems
                                  .map((e) => e.displaySavedLabel)
                                  .toList(),
                              selectedValue: controller.selectedSavedPlayer.value?.displaySavedLabel,
                              onChanged: (val) {
                                if (val == null) return;
                                final selected = dropdownItems.firstWhere(
                                      (e) => (e.displaySavedLabel) == val,
                                );
                                controller.updateSelectedSavedPlayer(selected);
                              },
                            ),
                            if (controller.selectedPlayerError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  controller.selectedPlayerError.value,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12.sp),
                                ),
                              ),
                          ],
                        );
                      }),
                      SizedBox(height: 3.h),

                      // -------- NOTE FIELD --------
                      Obx(() {
                        final error = controller.noteError.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add Note".tr,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: ThemeProvider.whiteColor,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            CustomTextField(
                              focusNode: noteFocus,
                              controller: controller.noteController,
                              hintText: "Write your note here".tr,
                              maxLines: 4,
                              textInputAction: TextInputAction.newline,
                              onChanged: (_) {
                                if (controller.noteError.value.isNotEmpty) {
                                  controller.noteError.value = '';
                                }
                              },
                            ),
                            if (error.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12.sp),
                                ),
                              ),
                          ],
                        );
                      }),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),

              // -------- SUBMIT BUTTON --------
              Button(
                title: "Submit".tr,
                onPressed: () async {
                  // Force keyboard to hide
                  noteFocus.unfocus();
                  FocusScope.of(context).unfocus();
                  controller.selectedPlayerError.value = '';
                  controller.noteError.value = '';

                  if (controller.selectedSavedPlayer.value == null) {
                    controller.selectedPlayerError.value = "Please select a player".tr;
                    errorToast("Please select a player".tr);
                    return;
                  }

                  if (controller.noteController.text.trim().isEmpty) {
                    controller.noteError.value = "Please add a note".tr;
                    errorToast("Please add a note".tr);
                    return;
                  }

                  await controller.addPlayerNote(
                    context,
                    playerId: controller.selectedSavedPlayer.value!.playerInfo!.id!,
                    note: controller.noteController.text.trim(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
