import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';
import '../../../backend/model/all_trials_model.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/theme.dart';
import '../../../utils/utils.dart';
import '../../../widget/commonDialog.dart';
import '../../../widget/commontext.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/trial_card.dart';
import '../trials_detail.dart';
import '../trials_logic.dart';

class MyTrialsPage extends StatefulWidget {
  const MyTrialsPage({super.key});

  @override
  State<MyTrialsPage> createState() => _MyTrialsPageState();
}

class _MyTrialsPageState extends State<MyTrialsPage> {
  final TrialsLogic logic = Get.find<TrialsLogic>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Call API ONLY first time
      if (logic.myList.isEmpty) {
        logic.myCurrentPage = 1;
        logic.hasMyMoreData = true;

        logic.getMyTrialsApi(
          context,
          currentPage: logic.myCurrentPage,
          limit: logic.limit,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 🔍 Search
            CustomTextField(
              onChanged: (value) {
                logic.onSearchMyTrialsChanged(value, context);
              },
              textInputStyle: TextStyle(
                color: ThemeProvider.hintText,
                fontSize: Utils.responsiveFontSize(context, 16.sp),
                fontFamily: 'Montserrat',
              ),
              prefixIcon: Icon(
                Icons.search_outlined,
                color: ThemeProvider.textColor,
                size: 23,
              ),
              hintText: "Search by trial name".tr,
            ),

            SizedBox(height: 3.w),

            // 📋 My Trials List
            Expanded(
              child: Obx(() {
                if (logic.isMyTrialsLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ThemeProvider.primary,
                    ),
                  );
                }

                if (logic.myList.isEmpty) {
                  return const Center(
                    child: CommonTextWidget(
                      heading: "No trials found",
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  );
                }

                return ListView.builder(
                  controller: logic.myScrollController,
                  itemCount: logic.myList.length + (logic.hasMyMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == logic.myList.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ThemeProvider.primary,
                          ),
                        ),
                      );
                    }

                    final trial = logic.myList[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: GestureDetector(
                        onTap: () {
                          final createdByUserid = trial.createdByUser?.id;
                          final userid = logic.state.getPlayerid();

                          Get.to(
                            () => TrialTalentScreen(),
                            arguments: {
                              'id': trial.id,
                              'image': trial.createdByUser?.avatar,
                              'isMyTrial': createdByUserid == userid
                                  ? true
                                  : false,
                            },
                          );
                        },
                        child: TrialCard(
                          category: logic.selectedLanguage.value == 'en'
                              ? (trial.category ?? '')
                              : (trial.roCategory ?? '')                                              ,
                          key: ValueKey(trial.id),
                          id: trial.id,
                          onEdit: () {
                            Get.toNamed(
                              AppRouter.createTrials,
                              arguments: trial,
                            );
                          },
                          onDelete: () {
                            showCommonDialog(
                              showCloseButton: true,
                              context: Get.context!,
                              title: "Are you Sure?",
                              message:
                                  "You’re about to delete this video. This action can’t be undone.",
                              svgAsset: AssetPath.deleteSuccess,
                              buttonText: "Cancel",
                              onButtonTap: () {
                                Get.back();
                              },
                              buttonFilled: false,
                              secondButtonText: "Delete",
                              onSecondButtonTap: () {
                                Get.back();
                                Get.find<TrialsLogic>().deleteTrial(trial.id!);
                                logic.getMyTrialsApi(
                                  context,
                                  currentPage: logic.myCurrentPage,
                                  limit: logic.limit,
                                );
                              },
                            );
                          },
                          videoThumbnail: trial.video,
                          thumbnail: trial.thumbnail,
                          logoUrl: trial.createdByUser?.avatar ?? "",
                          title: trial.name ?? "",
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            SizedBox(height: 2.h),

            Button(
              onPressed: () {
                Get.toNamed(AppRouter.createTrials);
              },
              title: "Create New Trial",
            ),
          ],
        ),
      ),
    );
  }

  void _openEditDeleteDialog(AllTrialList trial) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ThemeProvider.alertColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: ThemeProvider.primary),
              title: CommonTextWidget(
                heading: "Edit",
                fontSize: 16,
                color: Colors.white,
              ),
              onTap: () {
                Get.back(); // ✅ close dialog first
                Get.toNamed(AppRouter.createTrials, arguments: trial);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: CommonTextWidget(
                heading: "Delete",
                fontSize: 16,
                color: Colors.white,
              ),
              onTap: () {
                Get.back(); // close edit/delete dialog
                showCommonDialog(
                  showCloseButton: true,
                  context: Get.context!,
                  title: "Are you Sure?",
                  message:
                      "You’re about to delete this video. This action can’t be undone.",
                  svgAsset: AssetPath.deleteSuccess,
                  buttonText: "Cancel",
                  onButtonTap: () {
                    Get.back();
                  },
                  buttonFilled: false,
                  secondButtonText: "Delete",
                  onSecondButtonTap: () {
                    Get.back();
                    Get.find<TrialsLogic>().deleteTrial(trial.id!);
                  },
                );
              },
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }
}
