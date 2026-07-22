import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/validation.dart';
import 'package:scouttalent2/view/trial_player_detail/trial_player_detail_logic.dart';
import 'package:scouttalent2/view/trials/video_player_screen.dart';
import 'package:sizer/sizer.dart';

import '../../backend/helper/app_router.dart';
import '../../utils/utils.dart';
import '../../widget/commonDialog.dart';
import '../../widget/commontext.dart';
import '../../widget/video_thumb.dart';

class TrialPlayerDetailPage extends StatefulWidget {
  const TrialPlayerDetailPage({super.key});

  @override
  State<TrialPlayerDetailPage> createState() => _TrialPlayerDetailPageState();
}

class _TrialPlayerDetailPageState extends State<TrialPlayerDetailPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrialPlayerDetailLogic>(
      builder: (controller) {
        if (controller.isLoading) {
          return Scaffold(
            backgroundColor: ThemeProvider.bgColor,
            body: Center(
              child: CircularProgressIndicator(
                color: ThemeProvider.primary,
              ),
            ),
          );
        }


        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
                SizedBox(height: 1.h),
                CommonTextWidget(
                  textAlign: TextAlign.center,
                  heading: "Trails Details",
                  fontSize: Utils.responsiveFontSize(context, 18.sp),
                  fontWeight: FontWeight.w600,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(height: 2.h),

                //Image and Name
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ThemeProvider.whiteColor,
                      radius: 2.h,
                      backgroundImage: controller
                          .uploadedPlayerTrialDetail
                          .data
                          ?.player
                          ?.avatar
                          .profileImage,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: CommonTextWidget(
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                        heading:
                            "${controller.uploadedPlayerTrialDetail.data?.name}",
                        fontSize: Utils.responsiveFontSize(context, 16.sp),
                        fontWeight: FontWeight.w500,
                        color: ThemeProvider.whiteColor,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _statusActionButtons(
                  context,
                  controller,
                  controller.uploadedPlayerTrialDetail.data?.status,
                ),
                SizedBox(height: 2.h),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.drillList.length,
                    itemBuilder: (BuildContext context, index) {
                      final drillItem = controller.drillList[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget(
                            textAlign: TextAlign.start,
                            heading: "${drillItem.srNo}. ${drillItem.description?.tr}",
                            fontSize: Utils.responsiveFontSize(context, 15.sp),
                            fontWeight: FontWeight.w500,
                            color: ThemeProvider.whiteColor,
                            fontFamily: "Montserrat",
                          ),

                          SizedBox(height: 2.h),

                          GestureDetector(
                            onTap: () {
                             Get.to(()=>VideoPlayerScreen(videoUrl: Utils.trialVideo + drillItem.video!));
                            },
                            child: Container(
                              height: Get.height * 0.24,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ThemeProvider.hintText,
                                borderRadius: BorderRadius.circular(2.h),
                              ),
                              child: VideoThumb(
                                videoUrl: Utils.trialVideo + drillItem.video!,
                                thumbnail: drillItem.thumbnail ?? "",
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusActionButtons(
    BuildContext context,
    TrialPlayerDetailLogic controller,
    String? status,
  ) {
    /// When status is invited
    if (status == 'invited') {
      return _disabledStatusButton("Invited", ThemeProvider.primary);
    }

    /// When status is not-ready
    if (status == 'not-ready') {
      return _disabledStatusButton("Not Ready", ThemeProvider.primary);
    }

    /// Default (submitted / null)
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {


              showCommonDialog(
                svgContainer: Colors.white,
                showCloseButton: true,
                context: context,
                title: "Are you Sure?",
                message: "You’re about to invite this player. This action can’t be undone.",
                // svgAsset: AssetPath.,
                buttonText: "Cancel",
                onButtonTap: (){
                  Get.back();
                },
                buttonFilled: false,
                secondButtonText: "Yes",
                onSecondButtonTap: () {
                  Get.back();
                  controller.updateStatusApi(context, status: 'invited');

                },
              );

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeProvider.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.5.h),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.4.h),
            ),
            child: CommonTextWidget(
              fontSize: 16,
              heading: "Invite",
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        SizedBox(width: 3.w),

        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showCommonDialog(
                svgContainer: Colors.white,
                showCloseButton: true,
                context: context,
                title: "Are you Sure?",
                message: "You’re about to mark this player as not ready. This action can’t be undone.",
                // svgAsset: AssetPath.,
                buttonText: "Cancel",
                onButtonTap: (){
                  Get.back();
                },
                buttonFilled: false,
                secondButtonText: "Yes",
                onSecondButtonTap: () {
                  Get.back();
                  controller.updateStatusApi(context, status: 'not-ready');

                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeProvider.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.5.h),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.4.h),
            ),
            child: CommonTextWidget(
              fontSize: 16,
              heading: "Not Ready",
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _disabledStatusButton(String title, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: null, // ❌ untappable
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.5.h),
          ),
          padding: EdgeInsets.symmetric(vertical: 1.6.h),
        ),
        child: CommonTextWidget(
          heading: title,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
