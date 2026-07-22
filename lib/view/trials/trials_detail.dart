import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/utils/utils.dart';
import 'package:scouttalent2/view/trials/video_player_screen.dart';
import 'package:scouttalent2/widget/editDetailsBottomSheet.dart';
import 'package:scouttalent2/widget/video_thumb.dart';
import 'package:sizer/sizer.dart';
import '../../utils/theme.dart';
import '../../utils/toast.dart';
import '../../widget/button.dart';
import '../../widget/common_back_button.dart';
import '../../widget/commontext.dart';
import '../../view/trials/trials_logic.dart';
import '../../widget/customDropDown.dart';
import '../../widget/uploadTrialVideoSheet.dart';

class TrialTalentScreen extends StatefulWidget {
  const TrialTalentScreen({super.key});

  @override
  State<TrialTalentScreen> createState() => _TrialTalentScreenState();
}

class _TrialTalentScreenState extends State<TrialTalentScreen> {
  final TrialsLogic logic = Get.find<TrialsLogic>();
  String? image;
  late final String trialId;
  late final bool isMyTrial;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;

    trialId = args?['id'] ?? '';
    final img = args?['image'] ?? '';
    isMyTrial = args?['isMyTrial'] ?? false;
    image = img;
    if (kDebugMode) {
      print("YOO trial id>>$trialId");
    }
    logic.selectedPlayerId.value = '';
    // Receive arguments from previous screen

    // Fetch trial detail from API
    // Use addPostFrameCallback to avoid calling setState / Navigator during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logic.getTrialDetail(trialId);
      logic.uploadedTrialDetailsModel.value = null;
      logic.getClubPlayersApi(context, limit: 50, currentPage: 1);
      logic.selectedDrillVideos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ---------- SliverAppBar ----------
            SliverAppBar(
              expandedHeight: 50,
              backgroundColor: ThemeProvider.bgColor,
              pinned: true,
              leading: CommonBackButton(onTap: () => Get.back()),
            ),

            // ---------- Trial Info ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Obx(() {
                  final detail = logic.trailDetail.value;
                  if (detail == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: Get.size.height * 0.10,
                          width: Get.size.height * 0.10,
                          // 👈 keep height & width same for circle
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                            image: (image?.isNotEmpty ?? false)
                                ? DecorationImage(
                                    image: NetworkImage(
                                      Utils.imageUrl + image!,
                                    ),
                                    fit: BoxFit.fill,
                                  )
                                : null,
                          ),
                          child: (image?.isEmpty ?? true)
                              ? const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 36,
                                    color: Colors.black54,
                                  ),
                                )
                              : null,
                        ),
                      ),

                      SizedBox(height: 2.h),
                      Align(
                        alignment: Alignment.center,

                        child: CommonTextWidget(
                          heading: " ${detail.data?.name}",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  );
                }),
              ),
            ),

            // ---------- Banner Image + Description ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Obx(() {
                  final detail = logic.trailDetail.value;
                  if (detail == null) return const SizedBox();

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ✅ LEFT ALIGN
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: 40.h,
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  VideoPlayerScreen(
                                    videoUrl:
                                        Utils.trialVideo +
                                        (detail.data?.video ?? ""),
                                  ),
                                );
                                // Get.toNamed(
                                //   AppRouter.playVideosScreen,
                                //   arguments: "${Utils.trialVideo}${detail.data?.video ?? ""}",
                                // );
                              },
                              child: VideoThumb(
                                showPlayButton: true,
                                key: ValueKey(trialId),
                                videoUrl:
                                    Utils.trialVideo +
                                    (detail.data?.video ?? ""),
                                thumbnail: detail.data?.thumbnail ?? "",
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // ✅ LEFT ALIGN
                            children: [
                              /// Title
                              CommonTextWidget(
                                heading: detail.data?.name ?? "",
                                fontSize: 16.sp,
                                color: Colors.black,
                              ),

                              SizedBox(height: 1.h),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Description (2–3 lines)
                                    Obx(
                                      () => AnimatedSize(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: Text(
                                          detail.data?.description ?? "",
                                          maxLines: logic.isExpanded.value
                                              ? null
                                              : 3,
                                          overflow: logic.isExpanded.value
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: ThemeProvider.blackColor,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 1.h),

                                    /// Read More / Read Less
                                Obx(() => Align(
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton(
                                    onPressed: logic.toggleReadMore,
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.orange,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1.4.h,
                                        horizontal: 6.w,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CommonTextWidget(
                                          heading: logic.isExpanded.value ? "Read Less" : "Read More",
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                        ),
                                        // SizedBox(width: 2.w),
                                        // Icon(
                                        //   logic.isExpanded.value
                                        //       ? Icons.keyboard_arrow_up
                                        //       : Icons.keyboard_arrow_down,
                                        //   color: Colors.white,
                                        //   size: 20,
                                        // ),
                                      ],
                                    ),
                                  ),
                                )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            // ---------- Assessments ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      heading: "Assessments - Complete all to enter trial",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    SizedBox(height: 2.h),
                    if (!isMyTrial)
                      Obx(() {
                        return CustomDropdownButton(
                          isExpanded: true,
                          hintText: "Select Player Name",
                          items: logic.playersList
                              .map((e) => e.displayLabel)
                              .toList(),
                          selectedValue:
                              logic.playersList.contains(
                                logic.selectedPlayer.value,
                              )
                              ? logic.selectedPlayer.value
                              : null,
                          onChanged: (val) {
                            if (val == null) return;

                            final selectedData = logic.playersList.firstWhere(
                              (e) => e.displayLabel == val,
                            );

                            logic.updateSelectedPlayer(selectedData);
                            logic.getUploadedTrialRes(
                              logic.trailDetail.value?.data?.id,
                              logic.selectedPlayerId.value,
                            );
                          },
                        );
                      }),

                    Obx(() {
                      final assessment = logic.trailDetail.value;
                      final uploaded = logic.uploadedTrialDetailsModel.value;

                      if (assessment == null || assessment.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Map drills from trailDetail: title and description
                      final drills = [
                        assessment.data!.drillOne,
                        assessment.data!.drillTwo,
                        assessment.data!.drillThree,
                        assessment.data!.drillFour,
                      ].where((d) => d != null && d.trim().isNotEmpty).toList();

                      // Clear previously selected local videos
                      logic.selectedDrillVideos.removeWhere(
                        (key, value) => key >= drills.length,
                      );

                      // Uploaded drills from second API
                      final uploadedDrills = uploaded?.data?.drills ?? [];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 2, top: 1.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeProvider.bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.h),

                              /// Drill List
                              drills.isEmpty
                                  ? Text(
                                      "No drills available",
                                      style: TextStyle(color: Colors.grey[500]),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: drills.length,
                                      separatorBuilder: (_, __) => Divider(
                                        color: Colors.grey.shade800,
                                        height: 0.5,
                                      ),
                                      itemBuilder: (context, index) {
                                        final drillDesc = drills[index];

                                        /// already uploaded from server
                                        final hasServerVideo = uploadedDrills
                                            .any(
                                              (u) =>
                                                  u.description == drillDesc &&
                                                  u.video != null &&
                                                  u.video!.trim().isNotEmpty,
                                            );

                                        /// selected locally
                                        final hasLocalVideo = logic
                                            .selectedDrillVideos
                                            .containsKey(index);

                                        final hasVideo =
                                            hasServerVideo || hasLocalVideo;

                                        debugPrint("Has video>>$hasVideo");

                                        return Container(
                                          decoration: BoxDecoration(
                                            color: hasVideo
                                                ? Colors.green.withValues(
                                                    alpha: 0.1,
                                                  )
                                                : ThemeProvider.bgColor,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: ListTile(
                                            /// ✅ GREEN CHECK ON LEFT
                                            leading: hasVideo
                                                ? Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  )
                                                : null,

                                            title: CommonTextWidget(
                                              heading: drillDesc ?? "",
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),

                                            /// upload icon only if not uploaded
                                            trailing: !hasVideo
                                                ? Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: SvgPicture.asset(
                                                      AssetPath.checkIcon,
                                                    ),
                                                  )
                                                : null,

                                            onTap: (isMyTrial || hasVideo)
                                                ? null
                                                : () async {
                                                    if (logic
                                                        .selectedPlayerId
                                                        .value
                                                        .isEmpty) {
                                                      errorToast(
                                                        "You need to Select a player before submitting a video.",
                                                      );
                                                      return;
                                                    }

                                                    await showModalBottomSheet<
                                                      XFile?
                                                    >(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (_) => UploadTrialVideoSheet(
                                                        onSubmit: (selectedVideo) async {
                                                          if (selectedVideo !=
                                                              null) {
                                                            logic.selectedDrillVideos[index] =
                                                                File(
                                                                  selectedVideo
                                                                      .path,
                                                                );

                                                            await logic.uploadSelectedDrill(
                                                              trialId: logic
                                                                  .trailDetail
                                                                  .value!
                                                                  .data!
                                                                  .id!,
                                                              playerId: logic
                                                                  .selectedPlayerId
                                                                  .value,
                                                              context: context,
                                                              drillIndex: index,
                                                            );
                                                            Get.back();
                                                          }
                                                        },
                                                        onClose: () =>
                                                            Navigator.pop(
                                                              context,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 3.h),
                    Button(
                      onPressed: () {
                        Get.toNamed(
                          AppRouter.uploadedTrials,
                          arguments: trialId,
                        )?.whenComplete(() {
                          logic.getUploadedTrialRes(
                            logic.trailDetail.value?.data?.id,
                            logic.selectedPlayerId.value,
                          );
                        });
                      },
                      title: "See Uploaded Trails",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }
}
