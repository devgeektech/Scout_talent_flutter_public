import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/view/player_all_videos/player_all_videos_logic.dart';
import 'package:sizer/sizer.dart';

import '../../backend/helper/app_router.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/common_back_button.dart';
import '../../widget/commontext.dart';

class PlayerAllVideosPage extends StatefulWidget {
  const PlayerAllVideosPage({super.key});

  @override
  State<PlayerAllVideosPage> createState() => _PlayerAllVideosPageState();
}

class _PlayerAllVideosPageState extends State<PlayerAllVideosPage> {
  final PlayerAllVideosLogic playersListLogic = Get.put(PlayerAllVideosLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerAllVideosLogic>(
        builder: (logic) {
      return Scaffold(
        backgroundColor: ThemeProvider.bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: ThemeProvider.whiteColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CommonTextWidget(
                    textAlign: TextAlign.center,
                    heading: "Latest Videos".tr,
                    fontSize: Utils.responsiveFontSize(context, 20.sp),
                    fontWeight: FontWeight.w500,
                    color: ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),

                logic.playerVideosList.isNotEmpty
                    ?Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: logic.onScrollingPage,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: logic.playerVideosList.length,
                      itemBuilder: (_, index) {
                        final player = logic.playerVideosList[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: Stack(
                            children: [
                              Container(
                                width: Get.width,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 2))
                                  ],
                                    image: DecorationImage(
                                      image:NetworkImage(
                                        Utils.imageUrl1 + player.thumbnail!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.play_circle,
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      Get.toNamed(
                                        AppRouter.playVideosScreen,
                                        arguments: {
                                          "videoId": player.sId,
                                          "videoUrl": "${Utils.videoUrl}${player.video}",
                                        },
                                      );
                                    },

                                  )
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
                    : Expanded(child: Center(child: CommonTextWidget(heading: 'No video uploaded yet.'.tr, fontSize: 16, color: Colors.white))),
              ],
            ),
          ),
        ),
      );
    });
  }
}
