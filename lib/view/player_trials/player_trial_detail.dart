import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scouttalent2/view/trials/video_player_screen.dart';
import 'package:sizer/sizer.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/common_back_button.dart';
import '../../widget/commontext.dart';
import '../../widget/uploadTrialVideoSheet.dart';
import 'player_trials_logic.dart';
import '../../backend/helper/app_router.dart';
import '../../widget/video_thumb.dart';

class PlayerTrialDetailScreen extends StatelessWidget {
  PlayerTrialDetailScreen({super.key});
  final PlayerTrialsLogic logic = Get.find<PlayerTrialsLogic>();

  @override
  Widget build(BuildContext context) {
    final trialId = Get.arguments as String;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logic.trailDetail.value=null;
      logic.getTrialDetail(trialId);
      logic.selectedDrillVideos.clear();
    });

    return Scaffold(
      backgroundColor: ThemeProvider.bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            /// APP BAR
            SliverAppBar(
              backgroundColor: ThemeProvider.bgColor,
              pinned: true,
              leading: CommonBackButton(onTap: () => Get.back()),
            ),

            /// TRIAL INFO
            SliverToBoxAdapter(
              child: Obx(() {
                final detail = logic.trailDetail.value;
                if (detail == null) {
                  return  Center(child: CircularProgressIndicator(color: ThemeProvider.primary,));
                }

                return Column(
                  children: [
                    SizedBox(height: 2.h),
                    CommonTextWidget(
                      heading: detail.data?.name ?? "",
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                    SizedBox(height: 2.h),
                  ],
                );
              }),
            ),

            /// VIDEO CARD
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
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: SizedBox(
                            height: 40.h,
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                Get.to(()=>VideoPlayerScreen(videoUrl: "${Utils.trialVideo}${detail.data?.video ?? ""}"));
                                // Get.toNamed(
                                //   AppRouter.playVideosScreen,
                                //   arguments: "${Utils.trialVideo}${detail.data?.video ?? ""}",
                                // )
                              },
                              child: VideoThumb(
                                key: ValueKey(trialId),
                                videoUrl: Utils.trialVideo + (detail.data?.video ?? ""),
                                thumbnail: detail.data?.thumbnail ?? "",
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget(
                                heading: detail.data?.name ?? "",
                                fontSize: 16.sp,
                                color: Colors.black,
                              ),
                              SizedBox(height: 1.h),
                              Text(detail.data?.description ?? "", style: TextStyle(fontSize: 14.sp)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            /// ASSESSMENTS
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

                    Obx(() {
                      final detail = logic.trailDetail.value;
                      if (detail == null || detail.data == null) return const SizedBox();
                      final t = detail.data!;
                      final pv = t.playerTrialVideo;

                      final drills = [
                        {"desc": t.drillOne, "video": pv?.drillOneVideo},
                        {"desc": t.drillTwo, "video": pv?.drillTwoVideo},
                        {"desc": t.drillThree, "video": pv?.drillThreeVideo},
                        {"desc": t.drillFour, "video": pv?.drillFourVideo},
                      ].where((d) => (d["desc"])?.trim().isNotEmpty ?? false).toList();

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => Divider(color: Colors.grey.shade800, height: .5),
                        itemCount: drills.length,
                        itemBuilder: (_, index) {
                          final drill = drills[index];
                          final desc = drill["desc"] as String;
                          final video = drill["video"];
                          final hasVideo = video != null && video.trim().isNotEmpty;

                          return Container(
                            decoration: BoxDecoration(
                              color: hasVideo ? Colors.green.withOpacity(0.1) : ThemeProvider.bgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: hasVideo
                                  ? Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                                child: const Icon(Icons.check, color: Colors.white, size: 16),
                              )
                                  : null,
                              title: CommonTextWidget(heading: desc, fontSize: 20, color: Colors.white),
                              trailing: !hasVideo
                                  ? Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.all(4),
                                child: SvgPicture.asset(AssetPath.checkIcon),
                              )
                                  : null,
                              onTap: hasVideo
                                  ? null
                                  : () async {
                                await showModalBottomSheet<XFile?>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => UploadTrialVideoSheet(
                                    onSubmit: (file) async {
                                      if (file != null) {
                                        logic.selectedDrillVideos[index] = File(file.path);
                                        await logic.uploadSelectedDrill(trialId: t.id!, context: context);
                                        await logic.getTrialDetail(t.id!);
                                        Get.back();
                                      }
                                    },
                                    onClose: () => Navigator.pop(context),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
