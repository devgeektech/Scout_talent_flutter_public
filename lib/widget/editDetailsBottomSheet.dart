import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../backend/model/edit_sheet_model.dart';
import '../backend/model/get_saved_list_model.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';
import '../view/uploaded_video/uploaded_video_logic.dart';
import 'button.dart';
import 'commontext.dart';
import 'customDropDown.dart';
import 'custom_text_field.dart';
import 'package:scouttalent2/backend/model/getClubPlayerList.dart' as player;

void openEditBottomSheet({
  required BuildContext context,
  required UploadedVideoLogic logic,
  required String sheetTitle,
  required String buttonText,
  List<player.ClubPlayers> dropdownItems = const [],
  List<String> privacyOptions = const [],
  bool showDescription = true,
  bool showDropdowns = true,
  String? videoPath,
  String? prefilledTitle, // <-- new
  String? prefilledDescription, // <-- new
  required Function(EditSheetResult) onSubmit,
}) {
  // Prefill controllers before opening sheet
  logic.titleController.text = prefilledTitle ?? '';
  logic.descriptionController.text = prefilledDescription ?? '';
  logic.selectedVisibility.value=null;
  logic.selectedPlayerId.value='';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1E1E1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    builder: (_) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,

        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Close
                Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, color: ThemeProvider.whiteColor),
                ),
              ),
              SizedBox(height: 1.h),

              /// Sheet Title
              Align(
                alignment: Alignment.center,
                child: CommonTextWidget(
                  heading: sheetTitle,
                  textAlign: TextAlign.center,
                  fontSize: Utils.responsiveFontSize(context, 22.sp),
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.whiteColor,
                ),
              ),

              SizedBox(height: 3.h),

              Align(
                alignment: Alignment.centerLeft,
                child: CommonTextWidget(
                  heading: 'Title',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 1.h),

              /// Title
              CustomTextField(
                controller: logic.titleController,
                hintText: "Enter title for video...",
              ),
              SizedBox(height: 2.h),

              /// Description
              if (showDescription)
                Align(
                  alignment: Alignment.centerLeft,
                  child: CommonTextWidget(
                    heading: 'Description',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              SizedBox(height: 1.h),

              CustomTextField(
                controller: logic.descriptionController,
                hintText: "Enter description",
                maxLines: 6,
              ),
              SizedBox(height: 2.h),

              /// Dropdowns
              if (showDropdowns && dropdownItems.isNotEmpty) ...[
                Obx(
                  () => CustomDropdownButton(
                    isExpanded: true,
                    hintText: "Select Player Name",
                    items: dropdownItems.map((e) => e.displayLabel).toList(),
                    selectedValue:
                        dropdownItems.contains(logic.selectedPlayer.value)
                        ? logic.selectedPlayer.value
                        : null,
                    onChanged: (val) {
                      if (val == null) return;

                      final selectedData = dropdownItems.firstWhere(
                        (e) => e.displayLabel == val, // OR e.fullName
                      );

                      logic.updateSelectedPlayer(selectedData);
                    },
                  ),
                ),
                SizedBox(height: 2.h),
/*                Obx(
                  () => CustomDropdownButton(
                    isExpanded: true,
                    hintText: "Select Visibility Status",
                    items: privacyOptions,
                    selectedValue:
                        privacyOptions.contains(logic.selectedVisibility.value)
                        ? logic.selectedVisibility.value
                        : null,
                    onChanged: (val) {
                      if (val != null) logic.updateSelectedVisibility(val);
                    },
                  ),
                ),
                SizedBox(height: 2.h),*/
              ],

              /// Submit Button
              Button(
                title: buttonText,
                onPressed: () {
                  FocusScope.of(context).unfocus(); // close keyboard

                  final isValid = logic.validateEditForm(
                    showDropdowns: dropdownItems.isEmpty?false:true,
                  );

                  if (!isValid) return;

                  logic.submit(onSubmit);
                  Get.back();
                },
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      )
      );
    },
  );
}


extension PlayerLabel on player.ClubPlayers {
  String get displayLabel {
    final name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    final id = sId ?? '';
    return '$name ';
  }
}
extension SavedPlayerLabel on SavedListBody {
  String get displaySavedLabel {
    final name = '${playerInfo?.firstName ?? ''} ${playerInfo?.lastName ?? ''}'.trim();

    if (name.isNotEmpty) {
      return name;
    }

    // fallback (optional)
    return playerInfo?.email ?? '';
  }
}
