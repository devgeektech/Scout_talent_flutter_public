import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:sizer/sizer.dart';

import '../../backend/helper/app_router.dart';
import '../../utils/utils.dart';
import '../../widget/common_back_button.dart';
import '../../widget/commontext.dart';
import 'saved_player_logic.dart';

class SavedPlayersPage extends StatelessWidget {
  SavedPlayersPage({super.key});

  final logic = Get.find<SavedPlayerLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.bgColor,
      appBar: AppBar(
        backgroundColor: ThemeProvider.bgColor,
        elevation: 0,
        leading: CommonBackButton(onTap: () => Get.back()),
        centerTitle: true,
      ),

      body: SafeArea(
        child: GetBuilder<SavedPlayerLogic>(
          builder: (logic) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        heading: "savedPlayers",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),

                      if(logic.savedPlayerList.isNotEmpty)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: ThemeProvider.primary),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          logic.clearSavedPlayers(context);
                        },
                        child: CommonTextWidget(
                          heading: "Clear".tr,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ThemeProvider.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),

                logic.savedPlayerList.isNotEmpty
                    ? Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: logic.onScrollingPage,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: logic.savedPlayerList.length,
                            itemBuilder: (context, index) {
                              final player = logic.savedPlayerList[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRouter.playerReport,arguments: player.playerInfo!.id);
                                      },
                                      child:CircleAvatar(
                                        radius: 24,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: (player.playerInfo != null &&
                                              player.playerInfo!.avatar != null &&
                                              player.playerInfo!.avatar!.isNotEmpty)
                                              ? Image.network(
                                            Utils.imageUrl + player.playerInfo!.avatar!,
                                            fit: BoxFit.cover,
                                            width: 48,
                                            height: 48,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/dummyPerson.png',
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                              : Image.asset(
                                            'assets/images/dummyPerson.png',
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonTextWidget(
                                            heading: "${player.playerInfo?.firstName ?? ""} ${player.playerInfo?.lastName ?? ""}",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(height: 3),
                                          CommonTextWidget(
                                            heading: player.playerInfo?.email ?? "",
                                            fontSize: 13,
                                            color: Colors.grey[700]!,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          const SizedBox(height: 2),
                                          CommonTextWidget(
                                            heading: player.playerInfo?.position ?? "",
                                            fontSize: 12,
                                            color: ThemeProvider.blackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Expanded(child: Center(child: CommonTextWidget(heading: 'No Saved Players'.tr, fontSize: 16, color: Colors.white))),
              ],
            );
          },
        ),
      ),
    );
  }
}
