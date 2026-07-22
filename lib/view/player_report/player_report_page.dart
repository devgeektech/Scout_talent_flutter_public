import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/utils/validation.dart';
import 'package:scouttalent2/view/player_report/pdfView.dart';
import 'package:scouttalent2/view/player_report/player_report_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../backend/helper/app_router.dart';
import '../../utils/app_assets.dart';
import '../../utils/constants.dart';
import '../../utils/generatePlayerReport.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';

class PlayerReportPage extends StatefulWidget {
  const PlayerReportPage({super.key});

  @override
  State<PlayerReportPage> createState() => _PlayerReportPageState();
}

class _PlayerReportPageState extends State<PlayerReportPage> {
  @override
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GetBuilder<PlayerReportController>(
      builder: (controller) {
        final player = controller.getPlayerDetailModal.data;
        if (player == null) {
          return SizedBox();
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
            actions: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    borderRadius: BorderRadius.circular(10),
                    value: controller.selectedLanguage.value.isNotEmpty
                        ? controller.selectedLanguage.value
                        : 'en',
                    isDense: true,
                    isExpanded: false,
                    dropdownColor: ThemeProvider.bgColor,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: ThemeProvider.textColor,
                    ),
                    style: TextStyle(
                      color: ThemeProvider.whiteColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateLanguage(value);
                      }
                    },

                    selectedItemBuilder: (context) {
                      return ['en', 'ro'].map((langCode) {
                        return Row(
                          children: [
                            // SVG Icon
                            SvgPicture.asset(
                              controller.selectedLanguage.value == 'en'
                                  ? AssetPath.english
                                  : AssetPath.romanian, // Romanian flag SVG
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            // spacing between icon and text
                            // Language Name
                            Text(
                              _getLanguageName(langCode),
                              style: TextStyle(
                                fontFamily: 'regular',
                                color: ThemeProvider.whiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },

                    items: ['en', 'ro'].map((langCode) {
                      return DropdownMenuItem(
                        value: langCode,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 2),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    /// -------- FLAG ICON --------
                                    SvgPicture.asset(
                                      langCode == 'en'
                                          ? AssetPath
                                                .english // your english flag svg
                                          : AssetPath.romanian,
                                      // your Romanian flag svg
                                      width: 28,
                                      height: 28,
                                    ),

                                    const SizedBox(width: 10),

                                    /// -------- LANGUAGE NAME --------
                                    CommonTextWidget(
                                      heading: _getLanguageName(langCode),
                                      fontSize: Utils.responsiveFontSize(
                                        context,
                                        16.sp,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      color: ThemeProvider.whiteColor,
                                      fontFamily: 'regular',
                                    ),
                                  ],
                                ),

                                /// -------- RADIO CHECK --------
                                Icon(
                                  controller.selectedLanguage.value == langCode
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color:
                                      controller.selectedLanguage.value ==
                                          langCode
                                      ? ThemeProvider.appColor
                                      : Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),

                            Divider(
                              color: ThemeProvider.textColor.withAlpha(20),
                            ),

                            const SizedBox(height: 2),
                          ],
                        ),
                      );
                    }).toList(),

                    //Language
                  ),
                ), // )
              ),
            ],
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Avatar and name
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 5.1.h,
                        backgroundColor: ThemeProvider.whiteColor,
                        child: CircleAvatar(
                          radius: 5.h,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 4.9.h,
                            backgroundColor: Colors.grey,
                            //profileImage image extension
                            backgroundImage: player.avatar?.profileImage,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonTextWidget(
                        heading:
                            ('${player.firstName ?? ''} ${player.lastName ?? ''}')
                                .trim()
                                .isNotEmpty
                            ? ('${player.firstName ?? ''} ${player.lastName ?? ''}')
                                  .trim()
                            : 'N/A',
                        fontSize: Utils.responsiveFontSize(context, 18.sp),
                        fontWeight: FontWeight.w600,
                        color: ThemeProvider.primary,
                        fontFamily: "Montserrat",
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  /// PLAYER DETAILS CARD
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeProvider.alertColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailItem(
                          title: "Actual Club",
                          value: player.displayCurrentTeamClub.toString(),
                        ),
                        _divider(),
                        DetailItem(
                          title: "DOB",
                          value: formatDate((player.dob ?? '').toString()),
                        ),
                        _divider(),
                        DetailItem(
                          title: "Age",
                          // value: getAgeFromDobString(
                          //   (player.dob ?? '').toString(),
                          // ),
                          value: player.displayAge,
                        ),
                        _divider(),
                        DetailItem(
                          title: "Height",
                          value: player.displayHeight.toString(),
                        ),
                        _divider(),
                        DetailItem(
                          title: "Weight",
                          value: player.weight.toString(),
                        ),
                        _divider(),
                        DetailItem(
                          title: "Preferred Foot",
                          value: player.displayPreferredFoot.toString(),
                        ),
                        _divider(),
                        DetailItem(
                          title: "Position",
                          value: player.getDisplayPosition(controller.selectedLanguage.value),
                        ),
                        _divider(),
                        DetailItem(
                          title: "Nationality",
                          value: player.nationality?.capitalizeFirst??"",
                          countryCode: player.countryCode??"",
                        ),
                        _divider(),
                        DetailItem(
                          title: "Comp Level",
                          value: player.competitionLevel.toString(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  /// HEATMAP
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "Heatmap (Last 5 matches)".tr,
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: ThemeProvider.alertColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.all(2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2.h,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // if (controller.parser.sharedPreferencesManager
                            //         .getString('selectedUserRole') !=
                            //     Constants.userRoleClubScout)
                            if (controller.type != "scouting")
                              Expanded(
                                child: Row(
                                  children: [
                                    Obx(() {
                                      return CheckboxTheme(
                                        data: CheckboxThemeData(
                                          visualDensity: const VisualDensity(
                                            horizontal: -4,
                                            vertical: -4,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        child: Checkbox(
                                          activeColor: ThemeProvider.primary,
                                          checkColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          value:
                                              controller.isEditingEnabled.value,
                                          onChanged: (value) {
                                            controller.isEditingEnabledChecked(
                                              value!,
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                    Expanded(
                                      child: CommonTextWidget(
                                        heading: "Enable Editing".tr,
                                        fontSize: Utils.responsiveFontSize(
                                          context,
                                          16.sp,
                                        ),
                                        fontWeight: FontWeight.w500,
                                        color: ThemeProvider.whiteColor,
                                        fontFamily: "Montserrat",
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            /// RIGHT SIDE (Points)
                            Flexible(
                              child: Obx(() {
                                return CommonTextWidget(
                                  heading:
                                      "${"Points Added".tr}: ${controller.points.length}",
                                  fontSize: Utils.responsiveFontSize(
                                    context,
                                    16.sp,
                                  ),
                                  fontWeight: FontWeight.w500,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: "Montserrat",
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                );
                              }),
                            ),
                          ],
                        ),

                        /// Image + Tap Detection
                        Obx(() {
                          final points = controller.points.value;
                          return SizedBox(
                            height: 180,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final width = constraints.maxWidth;
                                final height = constraints.maxHeight;
                                return GestureDetector(
                                  onTapDown: (TapDownDetails details) {
                                    if (controller.type != "scouting") {
                                      if (controller.isEditingEnabled.value) {
                                        final localPos = details.localPosition;
                                        controller.addPoint(
                                          localPos,
                                          width,
                                          height,
                                        );
                                      } else {
                                        errorToast(
                                          "Enable editing to add points".tr,
                                        );
                                      }
                                    }
                                  },

                                  child: Stack(
                                    children: [
                                      /// Ground Image
                                      Container(
                                        width: width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              AssetPath.footballPitch,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),

                                      /// Draw All Circles
                                      ...points.map((p) {
                                        return Positioned(
                                          // left: (p.x! / 100) * width - 6,
                                          // // center small circle
                                          // top: (p.y! / 100) * height - 6,
                                          left: (p.x! / controller.Wm) * width - 6,
                                          // center small circle
                                          top: (p.y! / controller.Hm) * height - 6,
                                          child: Container(
                                            width: 5,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: ThemeProvider.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),

                        // if (controller.parser.sharedPreferencesManager
                        //         .getString('selectedUserRole') !=
                        //     Constants.userRoleClubScout)
                        if (controller.type != "scouting")
                          Row(
                            children: [
                              Expanded(
                                child: Button(
                                  fontSize: 14.sp,
                                  color: Colors.blue,
                                  onPressed: () {
                                    if (controller.isEditingEnabled.value) {
                                      controller.saveHeatmapApi();
                                    } else {
                                      errorToast(
                                        "Enable editing to add points".tr,
                                      );
                                    }
                                  },
                                  title: "Save Heatmap",
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Button(
                                  fontSize: 14.sp,
                                  color: Colors.yellow.shade800,
                                  onPressed: () {
                                    if (controller.isEditingEnabled.value) {
                                      controller.undoPoint();
                                    } else {
                                      errorToast(
                                        "Enable editing to add points".tr,
                                      );
                                    }
                                  },
                                  title: "Undo Last Point",
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  /// RADAR TITLE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "Performance Radar",
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),

                  SizedBox(height: 2.h),

                  /// RADAR CHART
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff1C1D22),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CommonTextWidget(
                            heading: "Performance (%)",
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 1.h),

                        SizedBox(
                          height: 220,
                          child: RadarChart(
                            features: controller.features,
                            data: controller.pentagonData,
                            ticks: const [20, 40, 60, 80, 100],
                            sides: 5,
                            graphColors: [Colors.deepOrange],
                            outlineColor: Colors.grey.withOpacity(0.3),
                            axisColor: Colors.grey.withOpacity(0.2),
                            featuresTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  /// STATS TITLE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "Statistics",
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: ThemeProvider.alertColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 3.h,
                      horizontal: 4.w,
                    ),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.8,
                      children: [
                        StatCard(
                          title: player.matchesPlayed.toString(),
                          value: "Matches",
                        ),
                        StatCard(
                          title: player.competitionLevel.toString(),
                          value: "Comp. Level",
                        ),
                        StatCard(
                          title: player.squadNumber.toString(),
                          value: "Squad No",
                        ),
                        StatCard(
                          title: player.goals.toString(),
                          value: "Goals",
                        ),
                        StatCard(
                          title: player.assists.toString(),
                          value: "Assists",
                        ),
                        StatCard(
                          title: player.minutes.toString(),
                          value: "Minutes",
                        ),
                        StatCard(
                          title: player.passAccuracy.toString(),
                          value: "Pass Acu",
                        ),
                        StatCard(
                          title: player.duelsWon.toString(),
                          value: "Duel Won",
                        ),
                        StatCard(
                          title: player.passCompletion.toString(),
                          value: "Pass Comp.",
                        ),
                        StatCard(
                          title: player.shotsOnTarget.toString(),
                          value: "Shots on Target",
                        ),
                        StatCard(
                          title: player.dribblesCompleted.toString(),
                          value: "Dribbles Comp.",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  /// TROPHIES
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "Trophies",
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  player.trophies?.isEmpty == true
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: CommonTextWidget(
                            heading: "N/A",
                            fontSize: Utils.responsiveFontSize(context, 17.sp),
                            fontWeight: FontWeight.w600,
                            color: ThemeProvider.whiteColor,
                            fontFamily: "Montserrat",
                          ),
                        )
                      : SizedBox(
                          width: width,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: player.trophies?.length ?? 0,
                            itemBuilder: (context, index) {
                              final trophy = player.trophies?[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: TrophyImageTextRow(
                                  imagePath: trophy?.icon ?? "",
                                  text: "${trophy?.name} (${trophy?.year})",
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(height: 2.h),

                  /// Career
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "Career",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  _buildTable(context, controller),
                  SizedBox(height: 3.h),

                  ///Contact Information
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "Contract Information",
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 1.h),
                  DetailItem(
                    title: "Contract Start",
                    value: formatDate(
                      (player.contractStart ?? '').toString(),
                      showDayFirst: true,
                    ),
                  ),
                  DetailItem(
                    title: "Contract End",
                    value: formatDate(
                      (player.contractEnd ?? '').toString(),
                      showDayFirst: true,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  ///National Call ups
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "National Information",
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 2.h),
                  NationalInformationRow(
                    text:
                        "${controller.valueOrNA(player.callUps)} ${"Calls Up".tr}",
                  ),
                  SizedBox(height: 1.h),
                  NationalInformationRow(
                    text: "${controller.valueOrNA(player.caps)} ${"Caps".tr}",
                  ),
                  SizedBox(height: 1.h),
                  NationalInformationRow(
                    text: "${"Transfer Status".tr} : ${player.transferStatus}",
                  ),
                  SizedBox(height: 3.h),

                  ///You tube
                  /*Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "Youtube_Highlight_Video",
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    height: 20.h,
                    width: width,
                    // padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeProvider.alertColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: controller.youtubePlayerController == null
                        ? Center(
                            child: CommonTextWidget(
                              textAlign: TextAlign.center,
                              heading: "No video available.",
                              fontSize: Utils.responsiveFontSize(
                                context,
                                17.sp,
                              ),
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: YoutubePlayer(
                              bottomActions: [
                                CurrentPosition(),
                                ProgressBar(isExpanded: true),
                                RemainingDuration(),
                                PlaybackSpeedButton(),
                                // Do NOT include FullScreenButton()
                              ],
                              controller: controller.youtubePlayerController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.red,
                              progressColors: const ProgressBarColors(
                                playedColor: Colors.red,
                                handleColor: Colors.redAccent,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 3.h),*/

                  //Videos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CommonTextWidget(
                          heading: "Latest Videos",
                          fontSize: Utils.responsiveFontSize(context, 17.sp),
                          fontWeight: FontWeight.w600,
                          color: ThemeProvider.whiteColor,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      if(player.playerVideos != null && player.playerVideos!.isNotEmpty)
                      TextButton(
                          onPressed: () {
                            Get.toNamed(AppRouter.playerAllVideosPage,arguments: player.sId);
                          },
                        child: CommonTextWidget(
                        heading: "View All",
                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                        fontWeight: FontWeight.w600,
                        color: ThemeProvider.primary,
                        fontFamily: "Montserrat",
                      ),)

                    ],
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: Get.size.height * 0.2,
                    child: player.playerVideos != null && player.playerVideos!.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: player.playerVideos?.length ?? 0,
                      itemBuilder: (_, index) {
                        return Stack(
                          children: [
                            Container(
                              width: Get.width * 0.8,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                                image: DecorationImage(
                                  image:NetworkImage(
                                  Utils.imageUrl1 + player.playerVideos![index].thumbnail!,
                                ),
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                            Positioned(
                              top:0,
                                bottom:0,
                                left:0,
                                right:0,
                                child:IconButton(
                                  icon:Icon(
                                      Icons.play_circle,
                                    size: 50,
                                  ),
                                  onPressed: () {
                                    Get.toNamed(
                                      AppRouter.playVideosScreen,
                                      arguments: {
                                        "videoId": player.playerVideos?[index].sId,
                                        "videoUrl": "${Utils.videoUrl}${player.playerVideos?[index].video}",
                                      },
                                    );
                                  },

                                )
                            )
                          ],
                        );
                      },
                    )
                    :Container(
                      height: 20.h,
                      width: width,
                      // padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeProvider.alertColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child:Center(
                        child: CommonTextWidget(
                          textAlign: TextAlign.center,
                          heading: "No video available.",
                          fontSize: Utils.responsiveFontSize(
                            context,
                            17.sp,
                          ),
                          fontWeight: FontWeight.w600,
                          color: ThemeProvider.whiteColor,
                          fontFamily: "Montserrat",
                        ),
                      )
                    ),
                  ),
                  SizedBox(height: 3.h),

                  ///NOtes
                  if(controller.parser.sharedPreferencesManager.getString('selectedUserRole') != Constants.userRolePlayer)...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CommonTextWidget(
                        heading: "${"Note".tr}:",
                        fontSize: Utils.responsiveFontSize(context, 17.sp),
                        fontWeight: FontWeight.w600,
                        color: ThemeProvider.whiteColor,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CommonTextWidget(
                        heading: player.note ?? "N/A",
                        fontSize: Utils.responsiveFontSize(context, 16.sp),
                        fontWeight: FontWeight.w500,
                        color: ThemeProvider.whiteColor,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],


                  ///Document
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      heading: "Document",
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _documentRow("CV", controller, "${player.cv}"),
                  SizedBox(height: 1.h),
                  _documentRow(
                    "Medical",
                    controller,
                    "${player.medicalCertificate}",
                  ),
                  SizedBox(height: 4.h),

                  //Button
                  Button(
                    onPressed: () {
                      generatePDF(
                        playerName:
                            ('${player.firstName ?? ''} ${player.lastName ?? ''}')
                                .trim()
                                .isNotEmpty
                            ? ('${player.firstName ?? ''} ${player.lastName ?? ''}')
                                  .trim()
                            : 'N/A',
                        club: controller.valueOrNA(player.displayCurrentTeamClub),
                        height: int.tryParse(player.displayHeight),
                        weight: player.weight ?? 0,
                        nationality: controller.selectedLanguage.value == 'en'
                            ? player.nationality
                            : player.roNationality,
                        dob: (player.dob != null && player.dob!.trim().isNotEmpty)
                            ? formatDate(player.dob!)
                            : 'N/A',
                        age: (player.dob != null && player.dob!.trim().isNotEmpty)
                            ? int.tryParse(getAgeFromDobString(player.dob!))
                            : null,
                        preferredFoot: player.displayPreferredFoot.toString(),
                        position: controller.valueOrNA(player.getDisplayPosition(controller.selectedLanguage.value)),

                        // Stats
                        matches: player.matches,
                        compLevel: player.competitionLevel,
                        squadNo: player.squadNumber,
                        goals: player.goals,
                        assists: player.assists,
                        minutes: player.minutes,
                        passAccuracy: player.passAccuracy,
                        dualWons: player.duelsWon,
                        passComp: player.passCompletion,
                        shortsOnTarget: player.shotsOnTarget,
                        dribles: player.dribblesCompleted,
                        callUps: controller.valueOrNA(player.callUps),
                        caps: controller.valueOrNA(player.caps),
                        transferStatus: player.transferStatus,
                        contractStart: formatDate(
                          (player.contractStart ?? '').toString(),
                          showDayFirst: true,
                        ),
                        contractEnd: formatDate(
                          (player.contractStart ?? '').toString(),
                          showDayFirst: true,
                        ),
                        career: controller.getPlayerDetailModal.data?.career,
                        trophies:
                            controller.getPlayerDetailModal.data?.trophies,
                      );
                    },
                    title: "Download Report",
                  ),
                  SizedBox(height: 2.h),
                  Button(
                    filledColor: false,
                    onPressed: () {
                      openSendProfileSheet(context, controller);
                    },
                    title: "Send",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTable(BuildContext context, PlayerReportController controller) {
    final player = controller.getPlayerDetailModal.data;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeProvider.whiteColor,
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: const FixedColumnWidth(120), // 👈 important
            border: TableBorder.symmetric(
              inside: BorderSide(color: ThemeProvider.hintText),
            ),
            children: [
              _tableHeader(["Season", "Club", "Matches", "Minutes", "Goals"]),
              // 🔹 Dynamic rows
              ...?player?.career?.map(
                (career) => _tableRow([
                  career.season ?? "-",
                  career.club ?? "-",
                  career.matches ?? "0",
                  career.minutes ?? "0",
                  career.goals ?? "0",
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _tableHeader(List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white10),
      children: cells
          .map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CommonTextWidget(
                textAlign: TextAlign.center,
                heading: e,
                fontSize: 13,
                color: ThemeProvider.hintText,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
          .toList(),
    );
  }

  TableRow _tableRow(List<String> cells) {
    return TableRow(
      children: cells
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(10),
              child: CommonTextWidget(
                textAlign: TextAlign.center,
                heading: e,
                fontSize: 12,
                color: ThemeProvider.hintText,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _documentRow(
    String title,
    PlayerReportController controller,
    String docURl,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image(image: AssetImage(AssetPath.doc)),
            SizedBox(width: 5),
            CommonTextWidget(
              heading: title,
              fontSize: Utils.responsiveFontSize(context, 17.sp),
              fontWeight: FontWeight.w600,
              color: ThemeProvider.whiteColor,
              fontFamily: "Montserrat",
            ),
          ],
        ),
        InkWell(
          onTap: () async {
            // final file = await controller.downloadPdf(
            //   url: docURl,
            //   fileName: 'player_cv.pdf',
            // );
            //
            // if (file != null) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text("PDF downloaded successfully")),
            //   );
            // }
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("In progress ")),
            // );
            if (docURl == "null" || docURl.isEmpty) {
              // Show error or info
              successToast("Document not available");
              return; // Stop navigation
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PdfPreviewScreen(
                  pdfUrl: "${Utils.docBaseUrl}$docURl",
                  fileName: 'player_cv.pdf',
                ),
              ),
            );
          },
          child: CommonTextWidget(
            textDecoration: TextDecoration.underline,
            heading: "Download",
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w500,
            color: ThemeProvider.primary,
            fontFamily: "Montserrat",
          ),
        ),
      ],
    );
  }

  Widget _divider() => Divider(color: ThemeProvider.whiteColor.withAlpha(40));
}

String _getLanguageName(String code) {
  switch (code) {
    case 'en':
      return 'EN';
    case 'ro':
      return 'RO';

    default:
      return code;
  }
}

/// ===============================================A
/// ITEM ROW WIDGET
/// ===============================================

class DetailItem extends StatelessWidget {
  final String title;
  final String? value;
  final String? countryCode;

  const DetailItem({super.key, required this.title, required this.value,this.countryCode});

  @override
  Widget build(BuildContext context) {
    final displayValue =
        value != null &&
            value!.trim().isNotEmpty &&
            value!.trim().toLowerCase() != "null"
        ? value!
        : "N/A";
    final flag = countryCode != null
        ? countryCodeToFlag(countryCode!)
        : '';


    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonTextWidget(
            heading: "${title.tr} :  ",
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
          ),

          if (flag.isNotEmpty && value!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                flag,
                style: TextStyle(fontSize: 15.sp),
              ),
            ),

          CommonTextWidget(
            heading: displayValue,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w500,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
          ),
        ],
      ),
    );
  }
}

/// ===============================================
/// STAT CARD
/// ===============================================

class StatCard extends StatelessWidget {
  final String? title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final displayValue =
        title != null &&
            title!.trim().isNotEmpty &&
            title!.trim().toLowerCase() != "null"
        ? title!
        : "N/A";
    return Container(
      decoration: BoxDecoration(
        color: ThemeProvider.closeIcon.withAlpha(40),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonTextWidget(
            heading: displayValue,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
          ),

          SizedBox(height: 2.h),
          CommonTextWidget(
            textAlign: TextAlign.center,
            heading: value,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w500,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
          ),
        ],
      ),
    );
  }
}

class TrophyImageTextRow extends StatelessWidget {
  final String imagePath;
  final String text;

  const TrophyImageTextRow({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 15.h,
          width: 25.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imagePath.profileImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: CommonTextWidget(
            heading: text,
            fontSize: Utils.responsiveFontSize(context, 17.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class NationalInformationRow extends StatelessWidget {
  final String text;

  const NationalInformationRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: ThemeProvider.whiteColor, radius: 5),
        SizedBox(width: 2.w),
        Expanded(
          child: CommonTextWidget(
            heading: text,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
          ),
        ),
      ],
    );
  }
}

Future<void> openSendProfileSheet(
  BuildContext context,
  PlayerReportController controller,
) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  await showModalBottomSheet(
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
      return Padding(
        padding: EdgeInsets.only(
          left: 4.w,
          right: 4.w,
          top: 2.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 5.h,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
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
                CommonTextWidget(
                  heading: "Share Profile",
                  textAlign: TextAlign.center,
                  fontSize: Utils.responsiveFontSize(context, 22.sp),
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.whiteColor,
                ),
                SizedBox(height: 3.h),
                GestureDetector(
                  onTap:  () {
                    final String currentLang = Get.locale?.languageCode ?? 'en';
                    String? role =
                    controller.parser.sharedPreferencesManager.getString('selectedUserRole');

                    final playerId = controller.getPlayerDetailModal.data?.sId;

                    if (role == null || playerId == null) return;

                    final String path = role == 'player'
                        ? '/dashboard/player/profile/details/$playerId?lang=$currentLang'
                        : '/dashboard/$role/players/details/$playerId?lang=$currentLang';

                    final String url = '${Utils.profileBaseUrl}$path';

                    print("role ---> $role");
                    print("url ---> $url");

                    shareToWhatsApp(url);
                  },
                  child: SvgPicture.asset(
                    AssetPath.whatsappLogo
                  ),
                ),
                SizedBox(height: 3.h),

                /// Title
                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Enter Email Id",
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !Validators.isEmailValid(value)) {
                      return 'Enter a valid email'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                /// Submit Button
                Button(
                  title: "Send Email",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.sendProfileLinkApi();
                    }
                  },
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      );
    },
  ).whenComplete(() {
    controller.emailController.clear();
    controller.update();
  });
}
Widget _smallCard(int index) {
  return Container(
    width: 150,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
    ),
    child: Center(child: Text("Item ${index + 1}")),
  );
}
