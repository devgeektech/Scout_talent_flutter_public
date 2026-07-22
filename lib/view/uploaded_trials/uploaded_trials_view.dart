import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/validation.dart';
import 'package:scouttalent2/view/uploaded_trials/uploaded_trials_logic.dart';
import 'package:sizer/sizer.dart';

import '../../utils/utils.dart';
import '../../widget/commonDialog.dart';
import '../../widget/commontext.dart';

class UploadedTrialsPage extends StatefulWidget {
  const UploadedTrialsPage({super.key});

  @override
  State<UploadedTrialsPage> createState() => _UploadedTrialsPageState();
}

class _UploadedTrialsPageState extends State<UploadedTrialsPage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadedTrialsLogic>(
        builder: (controller) {
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                CommonTextWidget(
                  textAlign: TextAlign.center,
                  heading: "Uploaded Trails",
                  fontSize: Utils.responsiveFontSize(context, 18.sp),
                  fontWeight: FontWeight.w600,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(
                  height: 4.h,
                ),

                controller.trialVideosList.isEmpty
                    ?SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: CommonTextWidget(
                      heading: 'No video available.',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )
                    :Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _headerRow(context),
                      const Divider(height: 1),
                      ...List.generate(controller.trialVideosList.length, (index) {
                        final playerItem = controller.trialVideosList[index].player;
                        return Column(
                          children: [
                            _playerRow(
                              context,
                              index,
                              ('${playerItem?.firstName ?? ''} ${playerItem?.lastName ?? ''}').trim().isNotEmpty
                                  ? ('${playerItem?.firstName ?? ''} ${playerItem?.lastName ?? ''}').trim()
                                  : 'N/A',
                              playerItem?.avatar ??"",
                              playerId: controller.trialVideosList[index].playerId??"",
                              trialId: controller.trialVideosList[index].trialId??"",
                              controller: controller,
                              sId: controller.trialVideosList[index].sId??""
                            ),
                            index == controller.trialVideosList.length - 1
                                ? SizedBox.shrink()
                                : const Divider(height: 1),
                          ],
                        );
                      }),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      );
    });
  }
}


Widget _headerRow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
    child: Row(
      children: [
        SizedBox(
          width: 40,
          child: CommonTextWidget(
            textAlign: TextAlign.start,
            heading: "Sr No",
            fontSize: Utils.responsiveFontSize(context, 15.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.blackColor,
            fontFamily: "Montserrat",
          ),),
        SizedBox(
          width: 15,
        ),
        Expanded(child: CommonTextWidget(
          textAlign: TextAlign.start,
          heading: "Player’s",
          fontSize: Utils.responsiveFontSize(context, 15.sp),
          fontWeight: FontWeight.w600,
          color: ThemeProvider.blackColor,
          fontFamily: "Montserrat",
        ),),
        CommonTextWidget(
          textAlign: TextAlign.start,
          heading: "Action’s",
          fontSize: Utils.responsiveFontSize(context, 15.sp),
          fontWeight: FontWeight.w600,
          color: ThemeProvider.blackColor,
          fontFamily: "Montserrat",
        ),
      ],
    ),
  );
}

Widget _playerRow(BuildContext context, int index, String name, String image, {
  required String trialId,
  required String playerId,
  required String sId,
  required UploadedTrialsLogic controller,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Row(
      children: [
        SizedBox(
          width: 40,
          child: CommonTextWidget(
            textAlign: TextAlign.start,
            heading: "${index + 1}",
            fontSize: Utils.responsiveFontSize(context, 15.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.blackColor,
            fontFamily: "Montserrat",
          ),
        ),
        SizedBox(
          width: 15,
        ),
        CircleAvatar(
          radius: 14,
          backgroundImage: image.profileImage,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CommonTextWidget(
            textOverflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.start,
            heading: name,
            fontSize: Utils.responsiveFontSize(context, 15.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.blackColor,
            fontFamily: "Montserrat",
          ),
        ),
        SizedBox(width: 3.w),
        _actionButton(
          context,
          child: Icon(
            Icons.visibility_outlined,
            color: Colors.white,
            size: 18,
          ),
          onTap: () {
            Get.toNamed(AppRouter.trialPlayerDetail, arguments: [
              trialId,
              playerId
            ]);
          },
        ),

        SizedBox(width: 8),
        _actionButton(
          context,
            child: SvgPicture.asset(
          AssetPath.delete,
          height: 18,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
            enabled: controller.trialVideosList[index].myPlayer ?? false,
            onTap: () {
          showCommonDialog(
            showCloseButton: true,
            context: context,
            title: "Are you Sure?",
            message: "You are about to delete this Player from your list. You won’t be able to recover them.",
            svgAsset: AssetPath.deleteSuccess,
            buttonText: "Cancel",
            onButtonTap: (){
              Get.back();
            },
            buttonFilled: false,
            secondButtonText: "Delete",
            onSecondButtonTap: () {
              Navigator.of(context).pop();
              controller.deletePlayerVideo(sId,index, context);
            },
          );
        }),
      ],
    ),
  );
}

Widget _actionButton(
    BuildContext context,
    {
  required Widget child,
  required VoidCallback onTap,
  bool enabled = true, // new parameter
}) {
  return InkWell(
    onTap: enabled ? onTap : () {
      // show snackbar if disabled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You can not perform this action on other players.".tr),
        ),
      );
    },
    borderRadius: BorderRadius.circular(20),
    child: CircleAvatar(
      radius: 14,
      backgroundColor: enabled ? ThemeProvider.primary : Colors.grey.withOpacity(0.5),
      child: child,
    ),
  );
}


