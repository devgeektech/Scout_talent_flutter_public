import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/view/club_scouting/club_scout_search__logic.dart';
import 'package:sizer/sizer.dart';
import '../../backend/helper/app_router.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/common_back_button.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';
import '../players_list/compare_players.dart';

class ClubScoutSearchPage extends StatefulWidget {
  const ClubScoutSearchPage({super.key});

  @override
  State<ClubScoutSearchPage> createState() => _ClubScoutSearchPageState();
}

class _ClubScoutSearchPageState extends State<ClubScoutSearchPage> {
  //final clubScoutSearchController = Get.find<ClubScoutSearchLogic>();
  final ClubScoutSearchLogic clubScoutSearchController = Get.put(ClubScoutSearchLogic(parser: Get.find()));

  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clubScoutSearchController.getRecentList(context);
      clubScoutSearchController.getPlayerList(context, page: clubScoutSearchController.currentPage);

      clubScoutSearchController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClubScoutSearchLogic>(
      init: clubScoutSearchController,
      builder: (controller) {
        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    expandedHeight: controller.searchController.text.trim().isEmpty ? 25.h : 35.h,
                    floating: true,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonBackButton(
                            onTap: () {
                              Get.back();
                            },
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonTextWidget(
                                textAlign: TextAlign.center,
                                heading: "Scouting Players".tr,
                                fontSize: Utils.responsiveFontSize(context, 20.sp),
                                fontWeight: FontWeight.w500,
                                color: ThemeProvider.whiteColor,
                                fontFamily: "Montserrat",
                              ),

                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus!.unfocus();
                                      Get.toNamed(AppRouter.savedPlayer)?.then((value) {
                                        clubScoutSearchController.currentPage = 1;
                                        clubScoutSearchController.getRecentList(context);
                                        clubScoutSearchController.getPlayerList(context, page: clubScoutSearchController.currentPage);
                                      },);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 2.w),
                                      child: CircleAvatar(
                                        radius: 2.h,
                                        backgroundColor: ThemeProvider.whitish,
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            SvgPicture.asset(AssetPath.file),
                                            Obx(() {
                                              return controller.isSavedCount.value == 0
                                                  ? SizedBox()
                                                  : Container(
                                                      transform: Matrix4.translationValues(8, -10, 0),
                                                      width: 15,
                                                      height: 15,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                        color: ThemeProvider.primary,
                                                      ),
                                                      child: CommonTextWidget(
                                                        textAlign: TextAlign.center,
                                                        heading: controller.isSavedCount.value.toString(),
                                                        fontSize: Utils.responsiveFontSize(context, 12.sp),
                                                        fontWeight: FontWeight.w700,
                                                        color: ThemeProvider.whiteColor,
                                                        fontFamily: "Montserrat",
                                                      ),
                                                    );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      if (controller.isCardCount.value >= 2) {
                                        Get.to(() => ComparePlayersScreen())?.then((value) {
                                          clubScoutSearchController.currentPage = 1;
                                          clubScoutSearchController.getRecentList(context);
                                          clubScoutSearchController.getPlayerList(context, page: clubScoutSearchController.currentPage);
                                        });
                                      } else {
                                        errorToast('Please select at least 2 players to compare'.tr);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 2.w),
                                      child: CircleAvatar(
                                        radius: 2.h,
                                        backgroundColor: controller.isCardCount.value != 0 ? ThemeProvider.whitish : Colors.grey,
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            SvgPicture.asset(AssetPath.exchangeHorizontal),
                                            Obx(() {
                                              return controller.isCardCount.value == 0
                                                  ? SizedBox()
                                                  : Container(
                                                      transform: Matrix4.translationValues(8, -10, 0),
                                                      width: 15,
                                                      height: 15,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                        color: ThemeProvider.primary,
                                                      ),
                                                      child: CommonTextWidget(
                                                        textAlign: TextAlign.center,
                                                        heading: controller.isCardCount.value.toString(),
                                                        fontSize: Utils.responsiveFontSize(context, 12.sp),
                                                        fontWeight: FontWeight.w700,
                                                        color: ThemeProvider.whiteColor,
                                                        fontFamily: "Montserrat",
                                                      ),
                                                    );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          CustomTextField(
                            controller: controller.searchController,
                            textInputStyle: TextStyle(
                              color: ThemeProvider.hintText,
                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                              fontFamily: 'Montserrat',
                            ),
                            prefixIcon: Icon(Icons.search_outlined, color: ThemeProvider.textColor, size: 23),
                            maxLines: 1,
                            hintText: "Search by player name or position".tr,
                            onChanged: (value) async {
                              clubScoutSearchController.searchController.addListener(controller.onSearchChanged);
                            },
                          ),

                          SizedBox(height: .5.h),

                          if (controller.searchController.text.trim().isNotEmpty)
                            Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(minHeight: 14.h, maxHeight: 14.h),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: controller.searchingList.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ...List.generate(controller.searchingList.length > 5 ? 5 : controller.searchingList.length, (index) {
                                            return InkWell(
                                              onTap: () async{
                                                controller.searchController.text = "";
                                                FocusManager.instance.primaryFocus!.unfocus();
                                                controller.addRecentList(context,controller.searchingList[index].id ?? "");
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonTextWidget(
                                                    maxLines: 1,
                                                    textOverflow: TextOverflow.ellipsis,
                                                    heading:
                                                        "${controller.searchingList[index].firstName ?? ""} ${controller.searchingList[index].lastName ?? ""}",
                                                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                    fontWeight: FontWeight.w700,
                                                    color: ThemeProvider.blackColor,
                                                  ),
                                                  Divider(color: ThemeProvider.gray),
                                                ],
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    )
                                  : CommonTextWidget(
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                      heading: "No data found".tr,
                                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                                      fontWeight: FontWeight.w700,
                                      color: ThemeProvider.blackColor,
                                    ),
                            ),

                          SizedBox(height: 1.h),
                          CommonTextWidget(
                            heading: 'Quick Filters'.tr,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat",
                            fontSize: 20,
                            color: ThemeProvider.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    collapsedHeight: 100,
                    automaticallyImplyLeading: false,
                    backgroundColor: ThemeProvider.bgColor,
                    foregroundColor: ThemeProvider.bgColor,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // selected filter list
                          Obx(() {
                            if (controller.appliedFilters.isEmpty) {
                              return Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, __) => SizedBox(width: 1.w),
                                  itemCount: controller.filterOptions.length,
                                  itemBuilder: (context, index) {
                                    final filter = controller.filterOptions[index];
                                    final isSelected = controller.selectedFilter?.value == filter["label"];

                                    return SizedBox(
                                      width: (Get.width - ((controller.filterOptions.length - 1) * 10.w)) / controller.filterOptions.length,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.selectFilter(filter["label"]!);
                                          final label = filter["label"];
                                          if (label == "Position") {
                                            controller.showSelectBottomSheet(
                                              buttonEnable: true,
                                              context: context,
                                              title: "Select Player Type".tr,
                                              name: 'Position',
                                              options: controller.positions,
                                              selectedValue: controller.primaryPosition,
                                            );
                                          } else if (label == "Foot") {
                                            controller.showSelectBottomSheet(
                                              context: context,
                                              name: 'Foot',
                                              buttonEnable: true,
                                              title: "Player Foot".tr,
                                              options: controller.footList,
                                              selectedValue: controller.playerFoot,
                                            );
                                          } else if (label == "Height") {
                                            controller.showSelectBottomSheetTextFieldHeight(
                                              context: context,
                                              buttonEnable: true,
                                              min: controller.heightParam.isNotEmpty
                                                  ? controller.parser.separateValue(value: controller.heightParam, key: 0)
                                                  : 160.0,
                                              max: controller.heightParam.isNotEmpty
                                                  ? controller.parser.separateValue(value: controller.heightParam, key: 1)
                                                  : 180.0,
                                              title: "Select Height".tr,
                                              name: 'Height'.tr,
                                              onDone: (value) {
                                                controller.heightParam = value;
                                              },
                                            );
                                          } else if (label == "Club") {
                                            controller.showSelectBottomSheetTextField(
                                              context: context,
                                              textValue: controller.clubParam,
                                              title: "Select Club".tr,
                                              name: 'Club',
                                              callBack: (value) {
                                                controller.clubParam = value;
                                              },
                                            );
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              filter["icon"]!,
                                              height: 30,
                                              width: 30,
                                              color: isSelected ? ThemeProvider.primary : ThemeProvider.unselectedFilter,
                                            ),
                                            SizedBox(height: 1.h),
                                            CommonTextWidget(
                                              heading: filter["label"]!.tr,
                                              fontSize: 14.sp,
                                              color: isSelected ? ThemeProvider.primary : ThemeProvider.unselectedFilter,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              // Show applied filters as key: value
                              return Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, __) => SizedBox(width: 1.w),
                                  itemCount: controller.appliedFilters.length,
                                  itemBuilder: (context, index) {
                                    final key = controller.appliedFilters.keys.elementAt(index);
                                    final value = controller.appliedFilters[key];
                                    return Container(
                                      margin: EdgeInsetsGeometry.symmetric(vertical: 20),
                                      decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(100)),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Center(
                                          child: CommonTextWidget(
                                            heading: "${key.tr}: ${value?.tr}",
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ThemeProvider.blackColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }),

                          GestureDetector(
                            onTap: () => filterBottomSheet(controller),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SvgPicture.asset(AssetPath.moreOption, height: 30, width: 30, color: ThemeProvider.unselectedFilter),
                                      if (controller.appliedFilters.isNotEmpty)
                                        Positioned(
                                          top: -8,
                                          right: -8,
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeProvider.primary),
                                            child: CommonTextWidget(
                                              textAlign: TextAlign.center,
                                              heading: controller.appliedFilters.length.toString(),
                                              fontSize: Utils.responsiveFontSize(context, 12.sp),
                                              fontWeight: FontWeight.w700,
                                              color: ThemeProvider.whiteColor,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  CommonTextWidget(heading: 'More'.tr, fontSize: 14.sp, color: ThemeProvider.unselectedFilter),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (controller.recentlyPlayerList.isNotEmpty && controller.appliedFilters.isEmpty)
                    SliverAppBar(
                      expandedHeight: 30.h,
                      floating: true,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      //automaticallyImplyActions: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget(
                              heading: 'Recent Searches'.tr,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              color: ThemeProvider.whiteColor,
                            ),
                            SizedBox(height: 2.h),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(controller.recentlyPlayerList.length, (index) {
                                  return Container(
                                    padding: EdgeInsetsGeometry.symmetric(horizontal: .8.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.h),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: Offset(0, 3))],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Image Stack
                                        Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                Get.toNamed(AppRouter.playerAllVideosPage, arguments: controller.recentlyPlayerList[index].id);
                                              },
                                              child: Container(
                                                height: Get.height * 0.18,
                                                width: Get.width * 0.45,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h)),
                                                ),
                                                child: controller.recentlyPlayerList[index].avatar != null
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h)),
                                                        child: Image.network(
                                                          Utils.imageUrl + controller.recentlyPlayerList[index].avatar!,
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                          errorBuilder: (context, error, stackTrace) =>
                                                              Image.asset('assets/images/dummyPerson.png', fit: BoxFit.cover, width: double.infinity),
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h)),
                                                        child: Image.asset('assets/images/dummyPerson.png'),
                                                      ),
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonTextWidget(
                                                    maxLines: 1,
                                                    textOverflow: TextOverflow.ellipsis,
                                                    heading:
                                                        "${controller.recentlyPlayerList[index].firstName ?? ""} ${controller.recentlyPlayerList[index].lastName ?? ""}",
                                                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                    fontWeight: FontWeight.w700,
                                                    color: ThemeProvider.whiteColor,
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  SizedBox(
                                                    width: Get.width * 0.40,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.toNamed(AppRouter.playerReport, arguments: [controller.recentlyPlayerList[index].id, "scouting"]);
                                                          },
                                                          child: Container(
                                                            height: 3.h,
                                                            alignment: Alignment.center,
                                                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: ThemeProvider.primary,
                                                            ),
                                                            child: CommonTextWidget(
                                                              maxLines: 1,
                                                              textAlign: TextAlign.center,
                                                              textOverflow: TextOverflow.ellipsis,
                                                              heading: "Profile".tr,
                                                              fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                              color: ThemeProvider.whiteColor,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Montserrat",
                                                            ),
                                                          ),
                                                        ),
                                                        // GestureDetector(
                                                        //   onTap: () {
                                                        //     Get.toNamed(AppRouter.playerAllVideosPage, arguments: controller.recentlyPlayerList[index].id);
                                                        //   },
                                                        //   child: Container(
                                                        //     height: 3.h,
                                                        //     alignment: Alignment.center,
                                                        //     padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                                                        //     decoration: BoxDecoration(
                                                        //       borderRadius: BorderRadius.circular(25),
                                                        //       color: ThemeProvider.primary,
                                                        //     ),
                                                        //     child: CommonTextWidget(
                                                        //       maxLines: 1,
                                                        //       textAlign: TextAlign.center,
                                                        //       textOverflow: TextOverflow.ellipsis,
                                                        //       heading: "Videos".tr,
                                                        //       fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                        //       color: ThemeProvider.whiteColor,
                                                        //       fontWeight: FontWeight.w700,
                                                        //       fontFamily: "Montserrat",
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),

                                        // Action Buttons Row
                                        Container(
                                          width: Get.width * 0.45,
                                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                child: InkWell(
                                                  onTap: () {
                                                    controller.recentlyPlayerList[index].isSelectSave =
                                                        !controller.recentlyPlayerList[index].isSelectSave;
                                                    for (int i = 0; i < controller.playerListBody.length; i++) {
                                                      if (controller.playerListBody[i].id == controller.recentlyPlayerList[index].id) {
                                                        controller.playerListBody[i].isSelectSave = controller.recentlyPlayerList[index].isSelectSave;
                                                      }
                                                    }

                                                    controller.update();
                                                    controller.addToSaved(
                                                      context,
                                                      controller.recentlyPlayerList[index].id ?? "",
                                                      controller.recentlyPlayerList[index].isSelectSave,
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        controller.recentlyPlayerList[index].isSelectSave ? AssetPath.save : AssetPath.unSave,
                                                        height: 23,
                                                      ),
                                                      SizedBox(height: .5.h),
                                                      CommonTextWidget(
                                                        maxLines: 1,
                                                        textOverflow: TextOverflow.ellipsis,
                                                        heading: "Save",
                                                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                        fontWeight: FontWeight.w500,
                                                        color: ThemeProvider.whiteColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.h,
                                                width: 5.w,
                                                child: VerticalDivider(width: 3, color: ThemeProvider.whiteColor.withOpacity(0.4)),
                                              ),

                                              Flexible(
                                                child: InkWell(
                                                  onTap: () {
                                                    controller.recentlyPlayerList[index].isAddToCard =
                                                        !controller.recentlyPlayerList[index].isAddToCard;

                                                    for (int i = 0; i < controller.playerListBody.length; i++) {
                                                      if (controller.playerListBody[i].id == controller.recentlyPlayerList[index].id) {
                                                        controller.playerListBody[i].isAddToCard = controller.recentlyPlayerList[index].isAddToCard;
                                                      }
                                                    }
                                                    controller.update();
                                                    controller.addToCompare(
                                                      context,
                                                      controller.recentlyPlayerList[index].id ?? "",
                                                      controller.recentlyPlayerList[index].isAddToCard,
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        controller.recentlyPlayerList[index].isAddToCard ? AssetPath.compare : AssetPath.unCompare,
                                                        height: 23,
                                                      ),
                                                      SizedBox(height: .5.h),
                                                      CommonTextWidget(
                                                        maxLines: 1,
                                                        textOverflow: TextOverflow.ellipsis,
                                                        heading: "Compare",
                                                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                        fontWeight: FontWeight.w500,
                                                        color: ThemeProvider.whiteColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.h,
                                                width: 5.w,
                                                child: VerticalDivider(width: 3, color: ThemeProvider.whiteColor.withOpacity(0.4)),
                                              ),

                                              Flexible(
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      AppRouter.ratePlayer,
                                                      arguments: [
                                                        controller.recentlyPlayerList[index].id,
                                                        controller.recentlyPlayerList[index].isSelectRate,
                                                      ],
                                                    )?.then((result) {
                                                      if (result == true) {
                                                        controller.recentlyPlayerList[index].isSelectRate = true;

                                                        for (int i = 0; i < controller.playerListBody.length; i++) {
                                                          if (controller.playerListBody[i].id == controller.recentlyPlayerList[index].id) {
                                                            controller.playerListBody[i].isSelectRate =
                                                                controller.recentlyPlayerList[index].isSelectRate;
                                                          }
                                                        }
                                                        controller.update();
                                                      }
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset( controller.recentlyPlayerList[index].isSelectRate == true
                                                          ? AssetPath.ratingStar
                                                          : AssetPath.unRate, height: 23),
                                                      SizedBox(height: .5.h),
                                                      CommonTextWidget(
                                                        maxLines: 1,
                                                        textOverflow: TextOverflow.ellipsis,
                                                        heading: "Rate".tr,
                                                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                        fontWeight: FontWeight.w500,
                                                        color: ThemeProvider.whiteColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
                body: NotificationListener<ScrollNotification>(
                  onNotification: controller.onScrollingPage,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2.h,
                        children: [
                          CommonTextWidget(
                            heading: (controller.appliedFilters.isNotEmpty || controller.searchController.text.trim().isNotEmpty)
                                ? "Matched Results".tr
                                : "Recently Joined Player's".tr,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat",
                            fontSize: 20,
                            color: ThemeProvider.whiteColor,
                          ),

                          if (controller.playerListBody.isNotEmpty)
                            Expanded(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: controller.playerListBody.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 2.h,
                                  mainAxisSpacing: 0.h,
                                  childAspectRatio: 0.72,
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.h),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: Offset(0, 3))],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Image Stack
                                        Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                Get.toNamed(AppRouter.playerAllVideosPage, arguments: controller.playerListBody[index].id);
                                              },
                                              child: Container(
                                                height: Get.height * 0.18,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h)),
                                                ),
                                                child: controller.playerListBody[index].avatar != null
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h)),
                                                        child: Image.network(
                                                          Utils.imageUrl + controller.playerListBody[index].avatar!,
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                          errorBuilder: (context, error, stackTrace) =>
                                                              Image.asset('assets/images/dummyPerson.png', fit: BoxFit.cover, width: double.infinity),
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h)),
                                                        child: Image.asset('assets/images/dummyPerson.png'),
                                                      ),
                                              ),
                                            ),



                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonTextWidget(
                                                    maxLines: 1,
                                                    textOverflow: TextOverflow.ellipsis,
                                                    heading:
                                                        "${controller.playerListBody[index].firstName ?? ""} ${controller.playerListBody[index].lastName ?? ""}",
                                                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                    fontWeight: FontWeight.w700,
                                                    color: ThemeProvider.whiteColor,
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.toNamed(AppRouter.playerReport, arguments: [controller.playerListBody[index].id,"scouting"]);
                                                        },
                                                        child: Container(
                                                          height: 3.h,
                                                          alignment: Alignment.center,
                                                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(25),
                                                            color: ThemeProvider.primary,
                                                          ),
                                                          child: CommonTextWidget(
                                                            maxLines: 1,
                                                            textAlign: TextAlign.center,
                                                            textOverflow: TextOverflow.ellipsis,
                                                            heading: "Profile".tr,
                                                            fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                            color: ThemeProvider.whiteColor,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Montserrat",
                                                          ),
                                                        ),
                                                      ),
                                                      // GestureDetector(
                                                      //   onTap: () {
                                                      //     Get.toNamed(AppRouter.playerAllVideosPage, arguments: controller.playerListBody[index].id);
                                                      //   },
                                                      //   child: Container(
                                                      //     height: 3.h,
                                                      //     alignment: Alignment.center,
                                                      //     padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                                                      //     decoration: BoxDecoration(
                                                      //       borderRadius: BorderRadius.circular(25),
                                                      //       color: ThemeProvider.primary,
                                                      //     ),
                                                      //     child: CommonTextWidget(
                                                      //       maxLines: 1,
                                                      //       textAlign: TextAlign.center,
                                                      //       textOverflow: TextOverflow.ellipsis,
                                                      //       heading: "Videos".tr,
                                                      //       fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                      //       color: ThemeProvider.whiteColor,
                                                      //       fontWeight: FontWeight.w700,
                                                      //       fontFamily: "Montserrat",
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 1.h),

                                        // Action Buttons Row
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                child: InkWell(
                                                  onTap: () {
                                                    controller.playerListBody[index].isSelectSave = !controller.playerListBody[index].isSelectSave;

                                                    for (int i = 0; i < controller.recentlyPlayerList.length; i++) {
                                                      if (controller.playerListBody[index].id == controller.recentlyPlayerList[i].id) {
                                                        controller.recentlyPlayerList[i].isSelectSave = controller.playerListBody[index].isSelectSave;
                                                      }
                                                    }
                                                    controller.update();
                                                    controller.addToSaved(
                                                      context,
                                                      controller.playerListBody[index].id ?? "",
                                                      controller.playerListBody[index].isSelectSave,
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        controller.playerListBody[index].isSelectSave ? AssetPath.save : AssetPath.unSave,
                                                        height: 23,
                                                      ),
                                                      SizedBox(height: .5.h),
                                                      CommonTextWidget(
                                                        maxLines: 1,
                                                        textOverflow: TextOverflow.ellipsis,
                                                        heading: "Save",
                                                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                        fontWeight: FontWeight.w500,
                                                        color: ThemeProvider.whiteColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.h,
                                                width: 5.w,
                                                child: VerticalDivider(width: 3, color: ThemeProvider.whiteColor.withValues(alpha: 0.4)),
                                              ),

                                              Flexible(
                                                child: InkWell(
                                                  onTap: () {
                                                    controller.playerListBody[index].isAddToCard = !controller.playerListBody[index].isAddToCard;

                                                    for (int i = 0; i < controller.recentlyPlayerList.length; i++) {
                                                      if (controller.playerListBody[index].id == controller.recentlyPlayerList[i].id) {
                                                        controller.recentlyPlayerList[i].isAddToCard = controller.playerListBody[index].isAddToCard;
                                                      }
                                                    }
                                                    controller.update();
                                                    controller.addToCompare(
                                                      context,
                                                      controller.playerListBody[index].id ?? "",
                                                      controller.playerListBody[index].isAddToCard,
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        controller.playerListBody[index].isAddToCard ? AssetPath.compare : AssetPath.unCompare,
                                                        height: 23,
                                                      ),
                                                      SizedBox(height: .5.h),
                                                      CommonTextWidget(
                                                        maxLines: 1,
                                                        textOverflow: TextOverflow.ellipsis,
                                                        heading: "Compare",
                                                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                        fontWeight: FontWeight.w500,
                                                        color: ThemeProvider.whiteColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.h,
                                                width: 5.w,
                                                child: VerticalDivider(width: 3, color: ThemeProvider.whiteColor.withOpacity(0.4)),
                                              ),

                                              Flexible(
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      AppRouter.ratePlayer,
                                                      arguments: [controller.playerListBody[index].id, controller.playerListBody[index].isSelectRate],
                                                    )?.then((result) {
                                                      print("result--->$result");
                                                      if (result == true) {
                                                        controller.playerListBody[index].isSelectRate = true;

                                                        for (int i = 0; i < controller.recentlyPlayerList.length; i++) {
                                                          if (controller.playerListBody[index].id == controller.recentlyPlayerList[i].id) {
                                                            controller.recentlyPlayerList[i].isSelectRate =
                                                                controller.playerListBody[index].isSelectRate;
                                                          }
                                                        }
                                                        controller.update();
                                                      }
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        controller.playerListBody[index].isSelectRate == true
                                                            ? AssetPath.ratingStar
                                                            : AssetPath.unRate,
                                                        height: 23,
                                                      ),

                                                      SizedBox(height: .5.h),
                                                      CommonTextWidget(
                                                        maxLines: 1,
                                                        textOverflow: TextOverflow.ellipsis,
                                                        heading: "Rate".tr,
                                                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                                                        fontWeight: FontWeight.w500,
                                                        color: ThemeProvider.whiteColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
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

                          if (controller.playerListBody.isEmpty && !controller.isLoading)
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: CommonTextWidget(
                                  heading: "No Data Found".tr,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
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
          ),
        );
      },
    );
  }

  void filterBottomSheet(ClubScoutSearchLogic controller) {
    FocusManager.instance.primaryFocus!.unfocus();
    showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: Get.height * 0.85),
      context: context,
      backgroundColor: ThemeProvider.alertColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (builder) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              decoration: BoxDecoration(
                color: ThemeProvider.alertColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
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
                          icon: Icon(Icons.close, color: ThemeProvider.closeIcon),
                        ),
                      ],
                    ),

                    Expanded(
                      child: GridView.builder(
                        itemCount: controller.filter.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 2.h,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final item = controller.filter[index];
                          final title = item["title"];
                          final icon = item["icon"];
                          final isSelected1 = item["isSelected"];
                          return Obx(() {
                            final isSelected = controller.selectedFilter?.value == title;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.chooseFilter(title);
                                  final filter = title;
                                  if (filter == "Player type") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Player type',
                                      title: "Select Player Type".tr,
                                      options: controller.playerTypeList,
                                      selectedValue: controller.playerType,
                                    );
                                  }

                                  if (filter == "County (Romania)") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'County (Romania)',
                                      title: "Select County".tr,
                                      options: controller.countryList,
                                      selectedValue: controller.county,
                                    );
                                  }

                                  if (filter == "Consistency") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Consistency',
                                      title: "Consistency".tr,
                                      options: controller.consistencyList,
                                      selectedValue: controller.consistencyText,
                                    );
                                  }

                                  if (filter == "Foot") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      title: "Player Foot".tr,
                                      buttonEnable: false,
                                      name: 'Foot',
                                      options: controller.footList,
                                      selectedValue: controller.playerFoot,
                                    );
                                  }

                                  if (filter == "Experience Level") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Experience Level',
                                      title: "Select Experience Level Role".tr,
                                      options: controller.experience,
                                      selectedValue: controller.experienceParam,
                                    );
                                  }

                                  if (filter == "Video Type") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Video Type',
                                      title: "Select Video Type".tr,
                                      options: controller.videoTypeList,
                                      selectedValue: controller.videoType,
                                    );
                                  }

                                  if (filter == "Height") {
                                    controller.showSelectBottomSheetTextFieldHeight(
                                      context: context,
                                      min: controller.heightParam.isNotEmpty
                                          ? controller.parser.separateValue(value: controller.heightParam, key: 0)
                                          : 160.0,
                                      max: controller.heightParam.isNotEmpty
                                          ? controller.parser.separateValue(value: controller.heightParam, key: 1)
                                          : 180.0,
                                      title: "Select Height".tr,
                                      name: 'Height',
                                      onDone: (value) {
                                        controller.heightParam = value;
                                      },
                                    );
                                  }
                                  if (filter == "Weight") {
                                    controller.showSelectBottomSheetTextFieldHeight(
                                      context: context,
                                      min: controller.weightParam.isNotEmpty
                                          ? controller.parser.separateValue(value: controller.weightParam, key: 0)
                                          : 50.0,
                                      max: controller.weightParam.isNotEmpty
                                          ? controller.parser.separateValue(value: controller.weightParam, key: 1)
                                          : 100.0,
                                      title: "Select Weight".tr,
                                      name: 'Weight',
                                      onDone: (value) {
                                        controller.weightParam = value;
                                      },
                                    );
                                  }

                                  if (filter == "Under Contract") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Under Contract',
                                      title: "Contract Status".tr,
                                      options: controller.contractStatusList,
                                      selectedValue: controller.contractStatus,
                                    );
                                  }

                                  if (filter == "Available for Loan") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Available for Loan',
                                      title: "Available for Loan".tr,
                                      options: controller.availableLoanList,
                                      selectedValue: controller.availableForLoan,
                                    );
                                  }

                                  if (filter == "Playing Style") {
                                    controller.showSelectBottomSheetCheckBox(
                                      context: context,
                                      name: "Playing Style",
                                      title: "Select Playing Style".tr,
                                      options: controller.parser.playingStyleList,
                                      selectedValue: controller.playingStyle,
                                    );
                                  }

                                  if (filter == "Technical Attributes") {
                                    controller.showSelectBottomSheetCheckBox(
                                      context: context,
                                      name: "Technical Attributes",
                                      title: "Select Technical Attribute".tr,
                                      options: controller.parser.technicalAttributesList,
                                      selectedValue: controller.technicalAttribute,
                                    );
                                  }

                                  if (filter == "Verified") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Verified',
                                      title: "Verification Status".tr,
                                      options: controller.verificationList,
                                      selectedValue: controller.verificationStatus,
                                    );
                                  }

                                  if (filter == "Primary Position") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Primary Position',
                                      title: "Select Primary Position".tr,
                                      options: controller.primaryPositionList,
                                      selectedValue: controller.primaryPosition,
                                    );
                                  }

                                  if (filter == "Nationality") {
                                    controller.showSelectBottomSheetCountryCode(
                                      context: context,
                                      selectedValue: controller.nationalityParam,
                                      options: controller.parser.nationalityOptions,
                                      title: "Select Nationality".tr,
                                      name: 'Nationality',
                                      onDone: (value) {
                                        controller.nationalityParam.value = value;
                                      },
                                    );
                                  }

                                  if (filter == "Speed") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Speed',
                                      title: "Select Speed Level".tr,
                                      options: controller.speedOptions,
                                      selectedValue: controller.speed,
                                    );
                                  }

                                  if (filter == "Strength") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Strength',
                                      title: "Select Strength Level".tr,
                                      options: controller.strengthOptions,
                                      selectedValue: controller.strength,
                                    );
                                  }

                                  if (filter == "League Level Played") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'League Level Played',
                                      title: "Select League Level".tr,
                                      options: controller.leagueLevelPlayedOptions,
                                      selectedValue: controller.leaugeLevelPlayed,
                                    );
                                  }

                                  if (filter == "Age") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Age',
                                      title: "Select Age Level".tr,
                                      options: controller.ageOptions,
                                      selectedValue: controller.age,
                                    );
                                  }

                                  if (filter == "Acceleration") {
                                    controller.showSelectBottomSheet(
                                      context: context,
                                      name: 'Acceleration',
                                      title: "Select Acceleration Level".tr,
                                      options: controller.accelerateOptions,
                                      selectedValue: controller.acceleration,
                                    );
                                  }

                                  if (filter == "Secondary Role") {
                                    controller.showSelectBottomSheetCheckBox(
                                      context: context,
                                      name: "Secondary Role",
                                      title: "Select Secondary Role".tr,
                                      options: controller.parser.secondaryRoleList,
                                      selectedValue: controller.secondaryRole,
                                    );
                                  }

                                });
                              },

                              child: SafeArea(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.h),
                                    border: Border.all(color: (isSelected || isSelected1) ? ThemeProvider.primary : ThemeProvider.whiteColor),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        icon, color: (isSelected || isSelected1) ? ThemeProvider.primary : ThemeProvider.filterIconColor,
                                      ),
                                      SizedBox(height: 1.h),
                                      CommonTextWidget(
                                        maxLines: 3,
                                        lineHeight: 1.5,
                                        textAlign: TextAlign.center,
                                        heading: "$title".tr,
                                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                                        fontWeight: FontWeight.w500,
                                        color: isSelected || isSelected1 ? ThemeProvider.primary : ThemeProvider.whiteColor,
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                            ),
                            onPressed: () {
                              controller.applyFilters();
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

                        if (controller.appliedFilters.isNotEmpty)
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: ThemeProvider.primary),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              ),
                              onPressed: () {
                                controller.clearAllFilters();
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

  void showPositionBottomSheet(BuildContext context, RxString selectedPosition, ClubScoutSearchLogic controller) {
    showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: Get.height * 0.40),
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeProvider.bgColor,
      // dark background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      builder: (builder) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: "Select Position".tr,
                      fontSize: Utils.responsiveFontSize(context, 18.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),

                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close, color: ThemeProvider.closeIcon),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// LIST OF POSITIONS
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.positions.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final position = controller.positions[index];

                      return Obx(() {
                        final isSelected = selectedPosition.value == position;

                        return GestureDetector(
                          onTap: () {
                            selectedPosition.value = position;
                            controller.positionParam = position;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// TEXT
                                Expanded(
                                  child: CommonTextWidget(
                                    textAlign: TextAlign.start,
                                    heading: position.tr,
                                    fontSize: Utils.responsiveFontSize(context, 18.sp),
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? ThemeProvider.primary : ThemeProvider.whiteColor,
                                    fontFamily: "Montserrat",
                                  ),
                                ),

                                /// RADIO ICON
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: isSelected ? ThemeProvider.primary : ThemeProvider.whiteColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
