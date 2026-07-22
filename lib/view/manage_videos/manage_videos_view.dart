import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/constants.dart';
import 'package:sizer/sizer.dart';

import '../../backend/model/player_module_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commonDialog.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/editDetailsBottomSheet.dart';
import '../uploaded_video/uploaded_video_logic.dart';

class ManageVideosPage extends StatefulWidget {
  const ManageVideosPage({super.key});

  @override
  State<ManageVideosPage> createState() => _ManageVideosPageState();
}

class _ManageVideosPageState extends State<ManageVideosPage> {
  final UploadedVideoLogic uploadedVideoLogic = Get.find<UploadedVideoLogic>();
  final RxString searchQuery = "".obs;

  // Format ISO datetime to "12 Dec 2025 12:09 PM"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            // Search Bar
            uploadedVideoLogic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                ?SizedBox.shrink()
                : CustomTextField(
              textInputStyle: TextStyle(
                color: ThemeProvider.hintText,
                fontSize: Utils.responsiveFontSize(context, 16.sp),
                fontFamily: 'Montserrat',
              ),
              prefixIcon: Icon(
                Icons.search_outlined,
                color: ThemeProvider.textColor,
                size: 30,
              ),
              maxLines: 1,
              hintText: "Search by player name or position".tr,
              onChanged: (value) {
                searchQuery.value = value; // reactive search
              },
            ),
            uploadedVideoLogic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                ?SizedBox.shrink()
                : SizedBox(height: 2.h),

            uploadedVideoLogic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer?Expanded(
              child: Obx(() {
                final model = uploadedVideoLogic.playerListModuleModel.value;
                final list = model?.data ?? [];

                if (list == null || list.isEmpty) {
                  return Center(
                    child: CommonTextWidget(
                      heading: 'No video available.',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  );
                }

                final filteredList = list.where((video) {
                  final query = searchQuery.value.toLowerCase();
                  final name = (video.creator?.firstName ?? "").toLowerCase();
                  final role = (video.creator?.role ?? "").toLowerCase();
                  return name.contains(query) || role.contains(query);
                }).toList();

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return buildVideoCard(filteredList[index], context);
                  },
                );
              })

            )

        :  Expanded(
              child: Obx(() {
                final model = uploadedVideoLogic.videosListRes.value;

                if (model == null) {
                  return  Center(
                    child: CommonTextWidget(heading: 'No video available.', fontSize: 16, color: Colors.white),
                  );
                }



                // Filter by search query
                final filteredList = model.data!.where((video) {
                  final nameMatch =
                      video.playerName?.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      ) ??
                      false;
                  final roleMatch =
                      video.role?.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      ) ??
                      false;
                  return nameMatch || roleMatch;
                }).toList();

                if (filteredList.isEmpty) {
                  return  Center(
                    child: Text(
                      "No video available.".tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final video = filteredList[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: ThemeProvider.whiteColor,
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Avatar + Name + Role + Popup
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // Avatar
                                    CircleAvatar(
                                      radius: 2.5.h,
                                      backgroundColor: Colors.grey.shade300,
                                      backgroundImage:
                                          (video.avatar != null &&
                                              video.avatar!.isNotEmpty)
                                          ? NetworkImage(
                                              Utils.imageUrl + video.avatar!,
                                            )
                                          : null,
                                      child:
                                          (video.avatar == null ||
                                              video.avatar!.isEmpty)
                                          ? Icon(
                                              Icons.person,
                                              size: 3.h,
                                              color: Colors.grey.shade700,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 2.w),

                                    // Name + Role
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget(
                                          heading:
                                              video.playerName ??
                                              "Unknown Player",
                                          fontSize: Utils.responsiveFontSize(
                                            context,
                                            16.sp,
                                          ),
                                          fontWeight: FontWeight.w600,
                                          color: ThemeProvider.blackColor,
                                          fontFamily: "Montserrat",
                                          maxLines: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 0.5.h),
                                        if (video.role != null &&
                                            video.role!.isNotEmpty)
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.65, // 65% of screen
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ThemeProvider.primary,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: CommonTextWidget(
                                              heading: video.student?.email ?? '',
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              maxLines: 1,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Popup Menu Placeholder
                                PopupMenuButton(
                                  offset: const Offset(-8, 30),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                  ),
                                  color: ThemeProvider.whiteColor,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 14,
                                    child: Icon(
                                      Icons.more_vert,
                                      color: ThemeProvider.blackColor,
                                    ),
                                  ),
                                  itemBuilder: (BuildContext context) => [

                                    PopupMenuItem(
                                      value: 'edit',
                                      onTap: () async {
                                        await Future.delayed(
                                          const Duration(milliseconds: 100),
                                        );

                                        openEditBottomSheet(
                                          context: context,
                                          logic: uploadedVideoLogic,
                                          sheetTitle: "Edit Details",
                                          buttonText: "Update",
                                          showDescription: true,
                                          prefilledTitle: video.title,
                                          prefilledDescription:
                                              video.description,
                                          onSubmit: (result) async {
                                            if (kDebugMode) {
                                              print("TITLE = ${result.title}");
                                            }
                                            if (kDebugMode) {
                                              print(
                                              "DESC = ${result.description}",
                                            );
                                            }
                                            if (kDebugMode) {
                                              print("PLAYER = ${result.player}");
                                            }
                                            if (kDebugMode) {
                                              print(
                                              "VISIBILITY = ${result.visibility}",
                                            );
                                            }

                                            // 🔹 Call update API
                                            final updated =
                                                await uploadedVideoLogic
                                                    .updateVideo(
                                                      videoId: video.id!,
                                                      playerId:
                                                          video.student?.id ??
                                                          "",
                                                    );

                                            if (updated != null) {
                                              await showCommonDialog(
                                                showCloseButton: true,
                                                context: context,
                                                title: "Successfully Updated!",
                                                message:
                                                    "Your video has been uploaded and is now available in your library.",
                                                svgAsset:
                                                    AssetPath.successFilled,
                                              );
                                            }
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.mode_edit_outline_outlined,
                                            color: ThemeProvider.blackColor,
                                          ),
                                          SizedBox(width: 2.w),
                                          CommonTextWidget(
                                            heading: "Edit",
                                            fontSize: Utils.responsiveFontSize(
                                              context,
                                              16.sp,
                                            ),
                                            color: ThemeProvider.blackColor,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                    /// 🔹 Divider
                                    PopupMenuItem(
                                      enabled: false,
                                      height: 1,
                                      child: Divider(
                                        thickness: 1,
                                        color: ThemeProvider.textColor.withOpacity(0.25),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        showCommonDialog(
                                          showCloseButton: true,
                                          context: context,
                                          title: "Are you Sure?",
                                          message:
                                              "You’re about to delete this video. This action can’t be undone.",
                                          svgAsset: AssetPath.deleteSuccess,
                                          buttonText: "Cancel",
                                          onButtonTap: () {
                                            Get.back(); // Close dialog
                                          },
                                          buttonFilled: false,
                                          secondButtonText: "Delete",
                                          onSecondButtonTap: () {
                                            Get.back();
                                            // Call your delete API
                                            uploadedVideoLogic.deleteVideo(
                                              context,
                                              video.id ?? "",
                                            );
                                          },
                                        );
                                      },

                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AssetPath.delete),
                                          SizedBox(width: 2.w),
                                          CommonTextWidget(
                                            heading: "Delete",
                                            fontSize: Utils.responsiveFontSize(
                                              context,
                                              16.sp,
                                            ),
                                            color: ThemeProvider.blackColor,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 2.h),

                            // Video description
                            CommonTextWidget(
                              heading: video.description ?? "",
                              fontSize: Utils.responsiveFontSize(
                                context,
                                16.sp,
                              ),
                              fontWeight: FontWeight.w400,
                              color: ThemeProvider.textColor,
                              fontFamily: "Montserrat",
                              maxLines: 3,
                              textOverflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: 2.h),

                            // Date / Time / Verified
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: ThemeProvider.blackColor,
                                ),
                                SizedBox(width: 2.w),
                                CommonTextWidget(
                                  heading: video.createdAt != null
                                      ? formatLocalDate(video.createdAt!)
                                      : "",
                                  fontSize: Utils.responsiveFontSize(
                                    context,
                                    14.sp,
                                  ),
                                  fontWeight: FontWeight.w400,
                                  color: ThemeProvider.textColor,
                                  fontFamily: "Montserrat",
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.access_time_rounded,
                                  color: ThemeProvider.blackColor,
                                ),
                                SizedBox(width: 2.w),
                                CommonTextWidget(
                                  heading: video.createdAt != null
                                      ? formatTime(video.createdAt!)
                                      : "",
                                  fontSize: Utils.responsiveFontSize(
                                    context,
                                    14.sp,
                                  ),
                                  fontWeight: FontWeight.w400,
                                  color: ThemeProvider.textColor,
                                  fontFamily: "Montserrat",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildVideoCard(PlayerListModuleBody video, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(2.5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Title + Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  video.title ?? "Untitled Drill",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
              PopupMenuButton(
                offset: const Offset(-8, 30),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                color: ThemeProvider.whiteColor,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 14,
                  child: Icon(
                    Icons.more_vert,
                    color: ThemeProvider.blackColor,
                  ),
                ),
                itemBuilder: (BuildContext context) => [

                  PopupMenuItem(
                    value: 'edit',
                    onTap: () async {
                      await Future.delayed(
                        const Duration(milliseconds: 100),
                      );

                      openEditBottomSheet(
                        context: context,
                        logic: uploadedVideoLogic,
                        sheetTitle: "Edit Details",
                        buttonText: "Update",
                        showDescription: true,
                        prefilledTitle: video.title,
                        prefilledDescription:
                        video.description,
                        onSubmit: (result) async {
                          if (kDebugMode) {
                            print("TITLE = ${result.title}");
                          }
                          if (kDebugMode) {
                            print(
                            "DESC = ${result.description}",
                          );
                          }
                          if (kDebugMode) {
                            print("PLAYER = ${result.player}");
                          }
                          if (kDebugMode) {
                            print(
                            "VISIBILITY = ${result.visibility}",
                          );
                          }

                          // 🔹 Call update API
                          final updated =
                          await uploadedVideoLogic
                              .updateVideo(
                            videoId: video.id!,
                            playerId: "",
                          );

                          if (updated != null) {
                            await showCommonDialog(
                              showCloseButton: true,
                              context: context,
                              title: "Successfully Updated!",
                              message:
                              "Your video has been uploaded and is now available in your library.",
                              svgAsset:
                              AssetPath.successFilled,
                            );
                          }
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.mode_edit_outline_outlined,
                          color: ThemeProvider.blackColor,
                        ),
                        SizedBox(width: 2.w),
                        CommonTextWidget(
                          heading: "Edit",
                          fontSize: Utils.responsiveFontSize(
                            context,
                            16.sp,
                          ),
                          color: ThemeProvider.blackColor,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  /// 🔹 Divider
                  PopupMenuItem(
                    enabled: false,
                    height: 1,
                    child: Divider(
                      thickness: 1,
                      color: ThemeProvider.textColor.withOpacity(0.25),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      showCommonDialog(
                        showCloseButton: true,
                        context: context,
                        title: "Are you Sure?",
                        message:
                        "You’re about to delete this video. This action can’t be undone.",
                        svgAsset: AssetPath.deleteSuccess,
                        buttonText: "Cancel",
                        onButtonTap: () {
                          Get.back(); // Close dialog
                        },
                        buttonFilled: false,
                        secondButtonText: "Delete",
                        onSecondButtonTap: () {
                          Get.back();
                          // Call your delete API
                          uploadedVideoLogic.deleteVideo(
                            context,
                            video.id ?? "",
                          );
                        },
                      );
                    },

                    value: 'delete',
                    child: Row(
                      children: [
                        SvgPicture.asset(AssetPath.delete),
                        SizedBox(width: 2.w),
                        CommonTextWidget(
                          heading: "Delete",
                          fontSize: Utils.responsiveFontSize(
                            context,
                            16.sp,
                          ),
                          color: ThemeProvider.blackColor,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// Description
          Text(
            video.description ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),

           SizedBox(height: 2.h),

          /// Date & Time
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                video.createdAt != null ? formatLocalDate(video.createdAt!) : "",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const SizedBox(width: 18),
              Icon(Icons.access_time_outlined, size: 14, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                video.createdAt != null ? formatTime(video.createdAt!) : "",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
