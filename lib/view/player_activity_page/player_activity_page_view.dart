import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sizer/sizer.dart';

import '../../backend/helper/app_router.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/common_back_button.dart';
import '../../widget/commontext.dart';
import 'player_activity_page_logic.dart';

class PlayerActivityPage extends StatefulWidget {
  const PlayerActivityPage({super.key});

  @override
  State<PlayerActivityPage> createState() => _PlayerActivityPageState();
}

class _PlayerActivityPageState extends State<PlayerActivityPage> {
  final PlayerActivityPageLogic playersListLogic = Get.put(PlayerActivityPageLogic(state: Get.find()));


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
        child: GetBuilder<PlayerActivityPageLogic>(
          builder: (logic) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                  child: CommonTextWidget(
                    heading: "Player Activity",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                logic.playerActivitiesList.isNotEmpty
                    ? Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: logic.onScrollingPage,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: logic.playerActivitiesList.length,
                      itemBuilder: (context, index) {
                        final player = logic.playerActivitiesList[index];
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
                                  //Get.toNamed(AppRouter.playerReport,arguments: player.id);
                                },
                                child:CircleAvatar(
                                  radius: 24,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: (player.avatar != null &&
                                        player.avatar!.isNotEmpty)
                                        ? Image.network(
                                      Utils.imageUrl + player.avatar!,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CommonTextWidget(
                                            heading: logic.selectedLanguage.value == 'en'
                                                ? (player.title?.en ?? '')
                                                : (player.title?.ro ?? ''),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        CommonTextWidget(
                                          heading: player.createdAt != null
                                              ? formatTimeforComments(player.createdAt!)
                                              : '',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    CommonTextWidget(
                                      heading: player.name ?? "",
                                      fontSize: 13,
                                      color: Colors.grey[700]!,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 2),
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
                    : Expanded(child: Center(child: CommonTextWidget(heading: 'No Player Activity Found!'.tr, fontSize: 16, color: Colors.white))),
              ],
            );
          },
        ),
      ),
    );
  }
}
