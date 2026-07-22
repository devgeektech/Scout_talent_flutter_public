import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/utils/string.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/players_list/players_list_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commonDialog.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';
import '../add_player_screen/add_player_screen_logic.dart';
import '../club_scouting/club_scout_state.dart' hide NationalityOption;

class PlayersListPage extends StatefulWidget {
  const PlayersListPage({super.key});

  @override
  State<PlayersListPage> createState() => _PlayersListPageState();
}

class _PlayersListPageState extends State<PlayersListPage> {
  final PlayersListLogic playersListLogic = Get.put(
    PlayersListLogic(state: Get.find()),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playersListLogic.getClubPlayersApi(
        Get.context!,
        currentPage: playersListLogic.currentPage,
      );
      playersListLogic.loadPlayerLimit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayersListLogic>(
      init: playersListLogic,
      builder: (controller) {
        // final int playerLimit =
        //     playersListLogic.state.sharedPreferencesManager.getInt(
        //       AppString.playerLimit,
        //     ) ??
        //     0;
        // isLimitReached is true if limit is 0 (no players allowed) OR totalCount >= limit
        /*final bool isLimitReached =
            controller.playerLimit == 0 || controller.totalCount >= controller.playerLimit;*/

        final bool isLimitReached = !controller.isUnlimited &&
            controller.totalCount >= controller.playerLimit;
        print("controller.playerLimit--->${controller.playerLimit}");

        /*final bool shouldDisableButton =
            !controller.hasSubscription || isLimitReached;*/
        final bool shouldDisableButton =
            controller.subscriptionStatus.value == Constants.subscriptionCancel ||
                isLimitReached;
        print("controller.subscriptionStatus--->${controller.subscriptionStatus.value}");
        print("isLimitReached--->${isLimitReached}");
        print("shouldDisableButton--->${shouldDisableButton}");
        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: CommonTextWidget(
              textAlign: TextAlign.center,
              heading: "Players".tr,
              fontSize: Utils.responsiveFontSize(context, 20.sp),
              fontWeight: FontWeight.w500,
              color: ThemeProvider.whiteColor,
              fontFamily: "Montserrat",
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 2.h,
              children: [
                CustomTextField(
                  onChanged: (value) => controller.searchPlayerController
                      .addListener(controller.onSearchChanged),
                  controller: controller.searchPlayerController,
                  textInputStyle: TextStyle(
                    color: ThemeProvider.hintText,
                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                    fontFamily: 'Montserrat',
                  ),
                  suffixIcon: InkWell(
                    onTap: () => filterBottomSheet(controller),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SvgPicture.asset(AssetPath.filters),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: ThemeProvider.textColor,
                    size: 23,
                  ),
                  maxLines: 1,
                  hintText: "Search by player name or position".tr,
                ),

                Expanded(
                  child: controller.playersList.isEmpty
                      ? Center(
                          child: CommonTextWidget(
                            heading: 'No Player found.',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: controller.onScrollingPage,
                          child: GridView.builder(
                            controller: controller.scrollController,
                            itemCount: controller.playersList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 1.h,
                                  mainAxisSpacing: 1.h,
                                  childAspectRatio: 1.1,
                                  crossAxisCount: 2,
                                ),
                            itemBuilder: (context, index) {
                              var player = controller.playersList[index];
                              return GestureDetector(
                                onTap: () {},
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    color: Colors.grey,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Stack(
                                            children: [
                                              Positioned.fill(
                                                child: Image.network(
                                                  player.avatar != null &&
                                                          player
                                                              .avatar!
                                                              .isNotEmpty
                                                      ? Utils.imageUrl +
                                                            player.avatar!
                                                      : 'https://media.istockphoto.com/id/1288129985/vector/missing-image-of-a-person-placeholder.jpg?s=612x612&w=0&k=20&c=9kE777krx5mrFHsxx02v60ideRWvIgI1RWzR1X4MG2Y=',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              // More Icon
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: PopupMenuButton(
                                                  onSelected: (value) {
                                                    FocusManager
                                                        .instance
                                                        .primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  // padding: EdgeInsets.zero,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                14.0,
                                                              ),
                                                            ),
                                                      ),
                                                  color:
                                                      ThemeProvider.whiteColor,
                                                  padding: EdgeInsets.zero,
                                                  position:
                                                      PopupMenuPosition.under,
                                                  surfaceTintColor:
                                                      ThemeProvider.whiteColor,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        ThemeProvider.primary,
                                                    radius: 1.5.h,
                                                    child: Icon(
                                                      Icons.more_vert,
                                                      color: ThemeProvider
                                                          .whiteColor,
                                                      size: 15,
                                                    ),
                                                  ),
                                                  itemBuilder: (BuildContext context) {
                                                    return <PopupMenuEntry>[
                                                      PopupMenuItem(
                                                        value: 'edit',
                                                        onTap: () async {
                                                          //FocusManager.instance.primaryFocus?.unfocus();
                                                          Get.toNamed(
                                                            AppRouter
                                                                .addPlayerScreen,
                                                            arguments: {
                                                              "mode": "edit",
                                                              "id": player.sId,
                                                            },
                                                          )?.whenComplete(() {
                                                            controller
                                                                    .currentPage =
                                                                1;
                                                            controller
                                                                .getClubPlayersApi(
                                                                  context,
                                                                  currentPage:
                                                                      controller
                                                                          .currentPage,
                                                                );
                                                          });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .mode_edit_outline_outlined,
                                                              color: ThemeProvider
                                                                  .blackColor,
                                                            ),
                                                            SizedBox(
                                                              width: 2.w,
                                                            ),
                                                            CommonTextWidget(
                                                              heading:
                                                                  "Edit".tr,
                                                              fontSize:
                                                                  Utils.responsiveFontSize(
                                                                    context,
                                                                    16.sp,
                                                                  ),
                                                              color: ThemeProvider
                                                                  .blackColor,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        enabled: false,
                                                        height: 1,
                                                        child: Divider(
                                                          thickness: 1,
                                                          color: ThemeProvider
                                                              .textColor
                                                              .withOpacity(
                                                                0.25,
                                                              ),
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 'delete',
                                                        onTap: () async {
                                                          showCommonDialog(
                                                            bgColor:
                                                                ThemeProvider
                                                                    .whiteColor,
                                                            showCloseButton:
                                                                true,
                                                            closeIconColor:
                                                                ThemeProvider
                                                                    .blackColor,
                                                            context: context,
                                                            title:
                                                                "Are you Sure?",
                                                            titleColor:
                                                                ThemeProvider
                                                                    .blackColor,
                                                            messageColor:
                                                                ThemeProvider
                                                                    .textColor,
                                                            message:
                                                                "You are about to delete this Player from your list. You won’t be able to recover them.",
                                                            svgAsset: AssetPath
                                                                .deleteSuccess,
                                                            circleSize: 80,
                                                            buttonText:
                                                                "Cancel",
                                                            onButtonTap: () {
                                                              Get.back();
                                                            },
                                                            buttonFilled: false,
                                                            secondButtonText:
                                                                "Delete",
                                                            onSecondButtonTap: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                              controller
                                                                  .deletePlayer(
                                                                    player.sId!,
                                                                    index,
                                                                    context,
                                                                  );
                                                            },
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              AssetPath.delete,
                                                              color: ThemeProvider
                                                                  .blackColor,
                                                            ),
                                                            SizedBox(
                                                              width: 2.w,
                                                            ),
                                                            CommonTextWidget(
                                                              heading:
                                                                  "Delete".tr,
                                                              fontSize:
                                                                  Utils.responsiveFontSize(
                                                                    context,
                                                                    16.sp,
                                                                  ),
                                                              color: ThemeProvider
                                                                  .blackColor,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ];
                                                  },
                                                ),
                                              ),

                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: InkWell(
                                                  onTap: () {
                                                    FocusManager
                                                        .instance
                                                        .primaryFocus
                                                        ?.unfocus();
                                                    Get.toNamed(
                                                      AppRouter.playerReport,
                                                      arguments:
                                                        player.sId,
                                                    );
                                                  },
                                                  child: Container(
                                                    height: Get.height * 0.07,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 0.6.h,
                                                          horizontal: 1.w,
                                                        ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 2.w,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonTextWidget(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  textOverflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  heading:
                                                                      ('${player.firstName ?? ''} ${player.lastName ?? ''}')
                                                                          .trim()
                                                                          .isNotEmpty
                                                                      ? ('${player.firstName ?? ''} ${player.lastName ?? ''}')
                                                                            .trim()
                                                                      : 'N/A',
                                                                  fontSize:
                                                                      Utils.responsiveFontSize(
                                                                        context,
                                                                        16.sp,
                                                                      ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: ThemeProvider
                                                                      .whiteColor,
                                                                  fontFamily:
                                                                      "Montserrat",
                                                                ),
                                                                SizedBox(
                                                                  height: 0.5.h,
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        1.5.w,
                                                                    vertical:
                                                                        0.3.h,
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    color: ThemeProvider
                                                                        .primary,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          2.h,
                                                                        ),
                                                                  ),
                                                                  child: CommonTextWidget(
                                                                    // heading: (player.role ?? '').trim().isNotEmpty
                                                                    //     ? (player.role ?? '').trim().trim()
                                                                    //     : 'N/A',
                                                                    heading:
                                                                        "Player Profile",
                                                                    fontSize:
                                                                        Utils.responsiveFontSize(
                                                                          context,
                                                                          14.sp,
                                                                        ),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: ThemeProvider
                                                                        .whiteColor,
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Expanded(
                                        //   flex: 1,
                                        //   child: Container(
                                        //     color: ThemeProvider.bgColor,
                                        //     padding: EdgeInsets.symmetric(horizontal: 5),
                                        //     child: Row(
                                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        //       children: [
                                        //
                                        //         /// save
                                        //         Column(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: [
                                        //             SvgPicture.asset(
                                        //               AssetPath.save,
                                        //               height: 15,
                                        //             ),
                                        //             SizedBox(height: 0.4.h),
                                        //             CommonTextWidget(
                                        //               textAlign: TextAlign.center,
                                        //               heading: "Save".tr,
                                        //               fontSize: Utils.responsiveFontSize(
                                        //                   context, 14.sp),
                                        //               fontWeight: FontWeight.w500,
                                        //               color: ThemeProvider.whiteColor,
                                        //               fontFamily: "Montserrat",
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         /// Divider 1
                                        //         VerticalDivider(
                                        //           indent: 15,
                                        //           width: 1,
                                        //           thickness: 1,
                                        //           color: Colors.white24,
                                        //           endIndent: 15,
                                        //         ),
                                        //         /// compare
                                        //         Column(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: [
                                        //             SvgPicture.asset(
                                        //                 AssetPath.compare,
                                        //               height: 15,
                                        //             ),
                                        //             SizedBox(height: 0.4.h),
                                        //             CommonTextWidget(
                                        //               textAlign: TextAlign.center,
                                        //               heading: "Compare".tr,
                                        //               fontSize: Utils.responsiveFontSize(
                                        //                   context, 14.sp),
                                        //               fontWeight: FontWeight.w500,
                                        //               color: ThemeProvider.whiteColor,
                                        //               fontFamily: "Montserrat",
                                        //             ),
                                        //           ],
                                        //         ),
                                        //
                                        //         /// Divider 1
                                        //         VerticalDivider(
                                        //           indent: 15,
                                        //           width: 1,
                                        //           thickness: 1,
                                        //           color: Colors.white24,
                                        //           endIndent: 15,
                                        //         ),
                                        //         /// ratingStar
                                        //         Column(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: [
                                        //             SvgPicture.asset(
                                        //                 AssetPath.ratingStar,
                                        //               height: 15,
                                        //             ),
                                        //             SizedBox(height: 0.4.h),
                                        //             CommonTextWidget(
                                        //               textAlign: TextAlign.center,
                                        //               heading: "Rate".tr,
                                        //               fontSize: Utils.responsiveFontSize(
                                        //                   context, 14.sp),
                                        //               fontWeight: FontWeight.w500,
                                        //               color: ThemeProvider.whiteColor,
                                        //               fontFamily: "Montserrat",
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),

                Opacity(
                  opacity: shouldDisableButton ? 0.5 : 1.0,
                  child: Button(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final hasSubscription = await getHasSubscription();

                      // No subscription
                      if (controller.subscriptionStatus.value != Constants.subscriptionActive) {
                        errorToast("You don’t have any plan subscribed for this feature.");
                        return;
                      }
                      if (isLimitReached) {
                        errorToast("You have reached your plan limit to add players.");
                        return;
                      }

                      Get.toNamed(
                        AppRouter.addPlayerScreen,
                        arguments: {"mode": "add"},
                      )?.whenComplete(() {
                        controller.currentPage = 1;
                        controller.getClubPlayersApi(
                          context,
                          currentPage: controller.currentPage,
                        );
                      });
                    },
                    title: "Add Player".tr,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  filterBottomSheet(PlayersListLogic controller) {
    FocusManager.instance.primaryFocus!.unfocus();
    showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: Get.width / 0.8),
      context: context,
      backgroundColor: ThemeProvider.alertColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              decoration: BoxDecoration(
                color: ThemeProvider.alertColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonTextWidget(
                          textAlign: TextAlign.center,
                          heading: "Filter By".tr,
                          fontSize: Utils.responsiveFontSize(context, 18.sp),
                          fontWeight: FontWeight.w600,
                          color: ThemeProvider.whiteColor,
                          fontFamily: "Montserrat",
                        ),

                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: ThemeProvider.closeIcon,
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: GridView.builder(
                        itemCount: controller.state.filterList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 2.h,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final item = controller.state.filterList[index];
                          final title = item["title"];
                          final icon = item["icon"];
                          final isSelected1 = item["isSelected"];
                          return Obx(() {
                            final isSelected =
                                controller.selectedFilter?.value == title;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.chooseFilter(title);
                                  final filter = title;

                                  if (filter == "Position") {
                                    showSelectBottomSheet(
                                      context: context,
                                      title: "Select Player Type".tr,
                                      name: 'Position',
                                      options: controller.state.positions,
                                      selectedValue:
                                          controller.state.primaryPosition,
                                    );
                                  }
                                  if (filter == "Foot") {
                                    showSelectBottomSheet(
                                      context: context,
                                      title: "Player Foot".tr,
                                      buttonEnable: false,
                                      name: 'Foot',
                                      options: controller.state.footList,
                                      selectedValue:
                                          controller.state.playerFoot,
                                    );
                                  }
                                  if (filter == "Height") {
                                    showSelectBottomSheetTextFieldHeight(
                                      context: context,
                                      min:
                                          controller
                                              .state
                                              .playerHeight
                                              .isNotEmpty
                                          ? separateValue(
                                              value: controller
                                                  .state
                                                  .playerHeight
                                                  .value,
                                              key: 0,
                                            )
                                          : 160.0,
                                      max:
                                          controller
                                              .state
                                              .playerHeight
                                              .isNotEmpty
                                          ? separateValue(
                                              value: controller
                                                  .state
                                                  .playerHeight
                                                  .value,
                                              key: 1,
                                            )
                                          : 180.0,
                                      title: "Select Height".tr,
                                      name: 'Height',
                                      onDone: (value) {
                                        controller.state.playerHeight.value =
                                            value;
                                      },
                                    );
                                  }
                                  if (filter == "Weight") {
                                    showSelectBottomSheetTextFieldHeight(
                                      context: context,
                                      min:
                                          controller
                                              .state
                                              .playerWeight
                                              .isNotEmpty
                                          ? separateValue(
                                              value: controller
                                                  .state
                                                  .playerWeight
                                                  .value,
                                              key: 0,
                                            )
                                          : 50.0,
                                      max:
                                          controller
                                              .state
                                              .playerWeight
                                              .isNotEmpty
                                          ? separateValue(
                                              value: controller
                                                  .state
                                                  .playerWeight
                                                  .value,
                                              key: 1,
                                            )
                                          : 100.0,
                                      title: "Select Weight".tr,
                                      name: 'Weight',
                                      onDone: (value) {
                                        controller.state.playerWeight.value =
                                            value;
                                      },
                                    );
                                  }
                                  if (filter == "Age") {
                                    showSelectBottomSheet(
                                      context: context,
                                      name: 'Age',
                                      title: "Select Age Level".tr,
                                      options: controller.state.ageOptions,
                                      selectedValue: controller.state.playerAge,
                                    );
                                  }
                                  if (filter == "Player type") {
                                    showSelectBottomSheet(
                                      context: context,
                                      name: 'Player type',
                                      title: "Select Player Type".tr,
                                      options: controller.state.playerTypeList,
                                      selectedValue:
                                          controller.state.playerCountry,
                                    );
                                  }
                                  if (filter == "County (Romania)") {
                                    showSelectBottomSheet(
                                      context: context,
                                      name: 'County (Romania)',
                                      title: "Select County".tr,
                                      options: controller.state.countryList,
                                      selectedValue:
                                          controller.state.playerCounty,
                                    );
                                  }
                                  if (filter == "Under Contract") {
                                    showSelectBottomSheet(
                                      context: context,
                                      name: 'Under Contract',
                                      title: "Contract Status".tr,
                                      options:
                                          controller.state.contractStatusList,
                                      selectedValue:
                                          controller.state.playerUnderContract,
                                    );
                                  }
                                  if (filter == "Available for Loan") {
                                    showSelectBottomSheet(
                                      context: context,
                                      name: 'Available for Loan',
                                      title: "Available for Loan".tr,
                                      options:
                                          controller.state.availableLoanList,
                                      selectedValue: controller
                                          .state
                                          .playerAvailableForLoan,
                                    );
                                  }
                                  if (filter == "Nationality") {
                                    showSelectBottomSheetCountryCode(
                                      context: context,
                                      selectedValue:
                                          controller.state.playerNationality,
                                      options:
                                          controller.state.nationalityOptions,
                                      title: "Select Nationality".tr,
                                      name: 'Nationality',
                                      onDone: (value) {
                                        controller
                                                .state
                                                .playerNationality
                                                .value =
                                            value;
                                      },
                                    );
                                  }
                                  if (filter == "Experience Level") {
                                    showSelectBottomSheet(
                                      context: context,
                                      name: 'Experience Level',
                                      title: "Select Experience Level Role".tr,
                                      options: controller.state.experience,
                                      selectedValue: controller
                                          .state
                                          .playerExperienceLevel,
                                    );
                                  }
                                  if (filter == "Consistency") {
                                    showSelectBottomSheet(
                                      context: context,
                                      name: 'Consistency',
                                      title: "Consistency".tr,
                                      options: controller.state.consistencyList,
                                      selectedValue:
                                          controller.state.playerConsistency,
                                    );
                                  }

                                  if (filter == "Playing Style") {
                                    showSelectBottomSheetCheckBox(
                                      context: context,
                                      name: "Playing Style",
                                      title: "Select Playing Style".tr,
                                      options:
                                          controller.state.playingStyleList,
                                      selectedValue:
                                          controller.state.playingStyle,
                                    );
                                  }

                                  if (filter == "Technical Attributes") {
                                    showSelectBottomSheetCheckBox(
                                      context: context,
                                      name: "Technical Attributes",
                                      title: "Select Technical Attribute".tr,
                                      options: controller
                                          .state
                                          .technicalAttributesList,
                                      selectedValue:
                                          controller.state.technicalAttribute,
                                    );
                                  }

                                  if (filter == "Secondary Role") {
                                    showSelectBottomSheetCheckBox(
                                      context: context,
                                      name: "Secondary Role",
                                      title: "Select Secondary Role".tr,
                                      options:
                                          controller.state.secondaryRoleList,
                                      selectedValue:
                                          controller.state.secondaryRole,
                                    );
                                  }
                                });
                              },

                              child: SafeArea(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.h),
                                    border: Border.all(
                                      color: (isSelected || isSelected1)
                                          ? ThemeProvider.primary
                                          : ThemeProvider.whiteColor,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        icon,
                                        color: (isSelected || isSelected1)
                                            ? ThemeProvider.primary
                                            : ThemeProvider.filterIconColor,
                                      ),
                                      SizedBox(height: 1.h),
                                      CommonTextWidget(
                                        maxLines: 3,
                                        lineHeight: 1.5,
                                        textAlign: TextAlign.center,
                                        heading: "$title".tr,
                                        fontSize: Utils.responsiveFontSize(
                                          context,
                                          14.sp,
                                        ),
                                        fontWeight: FontWeight.w500,
                                        color: isSelected || isSelected1
                                            ? ThemeProvider.primary
                                            : ThemeProvider.whiteColor,
                                        fontFamily: "Montserrat",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),

                    // --- Clear All Filters Button ---
                    SizedBox(height: 2.h),

                    Row(
                      spacing: 2.w,
                      children: [
                        Expanded(
                          flex: 8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeProvider.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 1.5.h,
                                horizontal: 5.w,
                              ),
                            ),
                            onPressed: () async {
                              await controller.state.applyFilters();
                              controller.currentPage = 1;
                              controller.getClubPlayersApi(
                                context,
                                currentPage: controller.currentPage,
                              );
                              Get.back();
                            },
                            child: CommonTextWidget(
                              heading: "Apply Filters".tr,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                            ),
                          ),
                        ),

                        if (controller.state.appliedFilters.isNotEmpty)
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: ThemeProvider.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              ),
                              onPressed: () async {
                                await controller.state.clearAllFilters();
                                controller.currentPage = 1;
                                controller.getClubPlayersApi(
                                  context,
                                  currentPage: controller.currentPage,
                                );
                                Get.back();
                              },
                              child: CommonTextWidget(
                                heading: "Clear".tr,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: ThemeProvider.whiteColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showSelectBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required RxString selectedValue,
    required String name,
    bool buttonEnable = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            constraints: BoxConstraints(maxHeight: 600, minHeight: 100),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(
                      heading: title.tr,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: ThemeProvider.closeIcon),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      String item = options[index];

                      return Obx(() {
                        final isSelected = selectedValue.value == item;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedValue.value = item;

                              for (final item
                                  in playersListLogic.state.filterList) {
                                if (item['title'] == name) {
                                  item['isSelected'] = true;
                                }
                              }
                            });

                            if (!buttonEnable) {
                              Get.back();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: item.tr,
                                  fontSize: 16.sp,
                                  color: isSelected
                                      ? ThemeProvider.primary
                                      : ThemeProvider.whiteColor,
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? ThemeProvider.primary
                                      : ThemeProvider.whiteColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),

                if (buttonEnable)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeProvider.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 1.5.h,
                        horizontal: 5.w,
                      ),
                    ),
                    onPressed: () {
                      // applyFilters();
                      Get.back();
                    },
                    child: CommonTextWidget(
                      heading: "Apply Filters".tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  showSelectBottomSheetCountryCode({
    required BuildContext context,
    required String title,
    required String name,
    required Function(String) onDone,
    required RxString selectedValue,
    required List<NationalityOption> options,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            constraints: BoxConstraints(maxHeight: 600, minHeight: 100),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(
                      heading: title.tr,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: ThemeProvider.closeIcon),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      var item = options[index];

                      return Obx(() {
                        final isSelected = selectedValue.value == item.en;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              onDone(item.en);

                              for (final item
                                  in playersListLogic.state.filterList) {
                                if (item['title'] == name) {
                                  item['isSelected'] = true;
                                }
                              }
                            });

                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(
                                  heading: item.en.tr,
                                  fontSize: 16.sp,
                                  color: isSelected
                                      ? ThemeProvider.primary
                                      : ThemeProvider.whiteColor,
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? ThemeProvider.primary
                                      : ThemeProvider.whiteColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
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

  showSelectBottomSheetTextFieldHeight({
    required BuildContext context,
    required double min,
    required double max,
    required String title,
    required Function(String value) onDone,
    required String name,
    bool buttonEnable = false,
  }) {
    RangeValues currentRangeValues = RangeValues(min, max);
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: const Color(0xFF1E1E1E),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Header with Done
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: CupertinoColors.separator,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: CommonTextWidget(
                                heading: "Cancel".tr,
                                fontSize: 16.sp,
                                color: ThemeProvider.redColor,
                              ),
                              onPressed: () => Get.back(),
                            ),
                            CommonTextWidget(
                              heading: title.tr,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                            ),

                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: CommonTextWidget(
                                heading: "Done".tr,
                                fontSize: 16.sp,
                                color: ThemeProvider.primary,
                              ),
                              onPressed: () {
                                onDone(
                                  "${currentRangeValues.start.round().toString()}-${currentRangeValues.end.round().toString()}",
                                );
                                for (final item
                                    in playersListLogic.state.filterList) {
                                  if (item['title'] == name) {
                                    item['isSelected'] = true;
                                  }
                                }

                                if (buttonEnable) {
                                  // applyFilters();
                                }
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      RangeSlider(
                        values: currentRangeValues,
                        max: 200,
                        min: name == "Weight" ? 10 : 100,
                        activeColor: ThemeProvider.primary,
                        divisions: (200 - (name == "Weight" ? 10 : 100)),
                        labels: RangeLabels(
                          currentRangeValues.start.round().toString(),
                          currentRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            currentRangeValues = values;
                          });
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget(
                            heading: currentRangeValues.start
                                .round()
                                .toString(),
                            fontSize: 14.sp,
                            color: ThemeProvider.whiteColor,
                          ),
                          CommonTextWidget(
                            heading: currentRangeValues.end.round().toString(),
                            fontSize: 14.sp,
                            color: ThemeProvider.whiteColor,
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
      },
    );
  }

  showSelectBottomSheetCheckBox({
    required BuildContext context,
    required String title,
    required List<DemoModelCheckBox> options,
    required String name,
    bool buttonEnable = false,
    required RxList<String> selectedValue,
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            constraints: BoxConstraints(maxHeight: 600, minHeight: 100),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(
                      heading: title.tr,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: ThemeProvider.closeIcon),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      var item = options[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            item.isSelect = !item.isSelect;

                            if (item.isSelect) {
                              selectedValue.add(toCamelCase(item.title));
                            } else {
                              selectedValue.removeAt(index);
                            }

                            for (final item
                                in playersListLogic.state.filterList) {
                              if (item['title'] == name) {
                                item['isSelected'] = true;
                              }
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonTextWidget(
                                heading: item.title.tr,
                                fontSize: 16.sp,
                                color: item.isSelect
                                    ? ThemeProvider.primary
                                    : ThemeProvider.whiteColor,
                              ),
                              Icon(
                                item.isSelect
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: item.isSelect
                                    ? ThemeProvider.primary
                                    : ThemeProvider.whiteColor,
                              ),
                            ],
                          ),
                        ),
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
}
