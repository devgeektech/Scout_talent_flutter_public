import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/view/home/trending_all_videos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../backend/helper/app_router.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final logic = Get.put(HomeScreenController(parser: Get.find()));
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logic.getTrendingVideos(context);
      logic.getNotificationList(context);
      final role =
      logic.parser.sharedPreferencesManager.getString('selectedUserRole');

      if (role == Constants.userRolePlayer) {
        logic.loadProfileAndShowCompletion(context);
      }

    });
    // logic.getTrendingVideos(context);
    // logic.getNotificationList(getContext);
  }


  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        userId = prefs.getString('uid') ?? '';
      });
    }
    logic.getTrendingVideos(context,);
    logic.getLogos(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: CommonTextWidget(
              textAlign: TextAlign.center,
              heading: "Welcome!".tr,
              fontSize: Utils.responsiveFontSize(context, 20.sp),
              fontWeight: FontWeight.w500,
              color: ThemeProvider.whiteColor,
              fontFamily: "Montserrat",
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRouter.notificationsPage)?.then((value) {
                    logic.getNotificationList(context);
                  },);
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      AssetPath.notificationIcon,
                      width: 24,
                      height: 24,
                    ),

                    // Badge
                    logic.unreadCount.value == 0
                    ?SizedBox.shrink()
                    :Positioned(
                      right: -4,
                      top: -6,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: ThemeProvider.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Obx(() {
                          return Center(
                            child: Text(
                              '${logic.unreadCount.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      if(logic.parser.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer){
                        Get.toNamed(AppRouter.playerReport,arguments:userId );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 2.h,
                          child: CircleAvatar(
                            radius: 1.8.h,
                            backgroundImage: Utils.userProfileImage.isNotEmpty
                                ? NetworkImage(Utils.imageUrl + Utils.userProfileImage)
                                : null,
                            child:  (logic.parser.sharedPreferencesManager.getString('avatar') ?? '').isNotEmpty
                                ? ClipOval(
                                  child: CachedNetworkImage(
                                                          imageUrl: Utils.imageUrl +
                                    logic.parser.sharedPreferencesManager.getString('avatar')!,
                                                          memCacheHeight: 120,
                                                          memCacheWidth: 120,
                                                          fit: BoxFit.cover,
                                                          errorWidget: (_, __, ___) =>
                                                          const Image(image: AssetImage('assets/images/dummyPerson.png')),
                                                        ),
                                )
                                :const Image(image: AssetImage('assets/images/dummyPerson.png')),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        if (logic.parser.sharedPreferencesManager.getString('selectedUserRole') ==
                            Constants.userRolePlayer)
                        CommonTextWidget(
                          textAlign: TextAlign.center,
                          heading: "View Profile".tr,
                          fontSize: Utils.responsiveFontSize(context, 12.sp),
                          fontWeight: FontWeight.w500,
                          color: ThemeProvider.whiteColor,
                          fontFamily: "Montserrat",
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        title: "Find new talent and track favorite players",
                        value: "Start Scouting",
                        imagePath: AssetPath.startScout,
                        topRightLabel: "SCOUTING",
                        buttonText: "Open",
                        onButtonTap: () async {

                          String? role = await Utils().getUserType();

                          if (role== Constants.userRolePlayer) {
                            successToast("No scouting available for this role.".tr);
                          }else {
                            Get.toNamed(AppRouter.clubScoutSearch);
                          }

                        /*  if (controller.parser.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRoleClubScout) {
                            Get.toNamed(AppRouter.clubScoutPlayer);
                          } else {

                          }*/
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        title: "See the latest trials for all positions",
                        value: "Trials",
                        imagePath: AssetPath.trials,
                        topRightLabel: "TRIALS",
                        buttonText: "View Trials",
                        onButtonTap: () async {

                          String? role = await Utils().getUserType();
                          debugPrint("role====> $role");

                          if (role== Constants.userRoleClubScout || role== Constants.userRoleAgent) {
                            successToast("No trials available for this role.".tr);
                          }else  if (role == "club") {
                            Get.toNamed(AppRouter.trials);
                          } else {
                            Get.toNamed(AppRouter.playerTrial);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// ✅ FULL-WIDTH HORIZONTAL CARD
                _horizontalStatCard(
                  title: "Keep up with the latest player actions and updates.",
                  value: "Player Activity",
                  imagePath: AssetPath.latestTransfer,
                  buttonText: "View All",
                  onButtonTap: () {
                    Get.toNamed(AppRouter.playerActivityPage);
                  },
                ),
                const SizedBox(height: 10),

                if (controller.trendingList.isNotEmpty)
                  Column(
                    spacing: 12,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending Videos".tr,
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TrendingAllVideos(),
                                ),
                              ).whenComplete(() async {
                                await logic.getTrendingVideos(context);
                                logic.update();
                              },);
                            },
                            child: Text(
                              "View All".tr,
                              style: TextStyle(color: ThemeProvider.primary, fontWeight: FontWeight.w500),
                            ),

                          ),
                        ],
                      ),

                      SizedBox(
                        height: Get.size.height * 0.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.trendingList.length > 5 ? 5 : controller.trendingList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  AppRouter.playVideosScreen,
                                  arguments: {
                                    "videoId": controller.trendingList[index].id,
                                    "videoUrl": "${Utils.videoUrl}${controller.trendingList[index].video}",
                                  },
                                )?.then((value) async {
                                  /*if (value == null) return;

                                  final item = controller.trendingList[index];

                                  final bool likeMismatch =
                                      item.isLikeBtn != value['like'] ||
                                          item.likeTotalCount != value['likeCount'];

                                  final bool commentMismatch =
                                      item.comments != value['commentCount'];

                                  final bool shareMismatch =
                                      item.shares != value['shareCount'];
                                  if (controller.trendingList[index].isLikeBtn != value['like']) {
                                    if (value['like']) {
                                      controller.trendingList[index].likeTotalCount = controller.trendingList[index].likeTotalCount + 1;
                                    } else {
                                      controller.trendingList[index].likeTotalCount = controller.trendingList[index].likeTotalCount - 1;
                                    }
                                  }
                                  controller.trendingList[index].isLikeBtn = value['like'];

                                  if (likeMismatch || commentMismatch || shareMismatch) {
                                    debugPrint("🔄 Like / Comment / Share mismatch → reloading trending list");
                                    await controller.getTrendingVideos(context,);
                                  }

                                  controller.update();*/
                                  await logic.getTrendingVideos(context);
                                  logic.update();
                                });
                              },
                              child: _trendingCard(index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                if (controller.logosList.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Partners and collaborators who are already with us'.tr,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: Get.size.height * 0.17,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.logosList.length,
                            itemBuilder: (_, index) {
                              return _smallCard(index);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _horizontalStatCard({
    required String title,
    required String value,
    required String imagePath,
    required String buttonText,
    required VoidCallback onButtonTap,
  }) {
    return Container(
      height: Get.size.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          // Gradient overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.black26, Colors.transparent, Colors.black26],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Bottom left content: value + title + button
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(title.tr, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 6),
                SizedBox(
                  width: 140, // optional fixed width for button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: onButtonTap,
                    child: Text(buttonText.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper Widgets
  Widget _statCard({
    required String title,
    required String value,
    required String imagePath,
    required String topRightLabel,
    required String buttonText,
    required VoidCallback onButtonTap,
  }) {
    return Container(
      height: Get.size.height * 0.35, // card height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          // Top-right dynamic label
          Positioned(
            top: 12,
            left: 12,
            child: Text(
              topRightLabel.tr,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Bottom content: texts + button
          Positioned(
            bottom: 16, // padding from bottom
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Value
                Text(
                  value.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Title
                Text(
                  title.tr,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Bottom button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: onButtonTap,
                    child: Text(buttonText.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _trendingCard(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: _cardDecoration(),
      child: Stack(
        children: [
          // Video frame
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(14),
            child: logic.trendingList[index].thumbnail != null
                ? SizedBox(
                    height: Get.size.height * 0.2,
                    child: CachedNetworkImage(
                      imageUrl: Utils.imageUrl1 + logic.trendingList[index].thumbnail!,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Image.asset(AssetPath.latestTransfer, fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image.asset(AssetPath.latestTransfer, fit: BoxFit.cover),
                    )
                  )
                : SizedBox(child: Image.asset(AssetPath.latestTransfer, height: Get.size.height * 0.2)),
          ),

          // Bottom gradient -- design
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 45,
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              ),
              child: Row(
                spacing: 8.w,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AssetPath.unLike,
                        height: 20,
                        color: logic.trendingList[index].isLikeBtn ? ThemeProvider.redColor : ThemeProvider.whiteColor,
                      ),
                      SizedBox(height: 4),
                      if (logic.trendingList[index].likes.isNotEmpty)
                        CommonTextWidget(
                          heading: logic.trendingList[index].likes.length.toString(),
                          fontSize: 16,
                          color: ThemeProvider.whiteColor,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetPath.commentIcon,height: 20),
                      SizedBox(height: 4),
                      if (logic.trendingList[index].comments.isNotEmpty)
                        CommonTextWidget(
                          heading: logic.trendingList[index].comments.length.toString(),
                          fontSize: 16,
                          color: Colors.white,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetPath.sharePost,height: 20),
                      SizedBox(height: 4),
                      if (logic.trendingList[index].shares.isNotEmpty )
                        CommonTextWidget(
                          heading: logic.trendingList[index].shares.length.toString(),
                          fontSize: 16,
                          color: Colors.white,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallCard(int index) {
    return Container(
      width: Get.size.height * 0.17,
      margin: const EdgeInsets.only(right: 12),
      decoration: _cardDecoration(),
      child: logic.logosList[index].isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(5),
              child: Image.network(
                Utils.imageUrl + logic.logosList[index],
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => Image.asset(AssetPath.latestTransfer, fit: BoxFit.cover),
              ),
            )
          : SizedBox(child: Image.asset(AssetPath.latestTransfer, height: Get.size.height * 0.2)),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
    );
  }
}
