import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/manage_videos/manage_videos_view.dart';
import 'package:scouttalent2/view/uploaded_video/uploaded_video_page.dart';
import 'package:scouttalent2/view/videos_screen/videos_screen_logic.dart';
import 'package:scouttalent2/widget/commontext.dart';
import 'package:sizer/sizer.dart';
import '../../utils/utils.dart';



class VideosScreenPage extends StatefulWidget {
  const VideosScreenPage({super.key});

  @override
  State<VideosScreenPage> createState() => _VideosScreenPageState();
}

class _VideosScreenPageState extends State<VideosScreenPage> {
  final VideosScreenLogic videosScreenLogic = Get.put(
      VideosScreenLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideosScreenLogic>(
        init: videosScreenLogic,
        builder: (logic) {
          return Scaffold(
            backgroundColor: ThemeProvider.bgColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: CommonTextWidget(
                textAlign: TextAlign.center,
                heading: "Videos".tr,
                fontSize: Utils.responsiveFontSize(context, 20.sp),
                fontWeight: FontWeight.w500,
                color: ThemeProvider.whiteColor,
                fontFamily: "Montserrat",
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 4.w),
                    //   child: CommonTextWidget(
                    //     textAlign: TextAlign.center,
                    //     heading: "Videos".tr,
                    //     fontSize: Utils.responsiveFontSize(context, 20.sp),
                    //     fontWeight: FontWeight.w500,
                    //     color: ThemeProvider.whiteColor,
                    //     fontFamily: "Montserrat",
                    //   ),
                    // ),
                    // SizedBox(height: 3.h),
              
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ThemeProvider.primary,
                            borderRadius: BorderRadius.circular(4.h),
                            border: Border.all(color: ThemeProvider.whiteColor)
                        ),
                        child: TabBar(
                          controller: logic.tabController,
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: ThemeProvider.whiteColor,
                            borderRadius: BorderRadius.circular(4.h),
                          ),
                          unselectedLabelColor: ThemeProvider.whiteColor,
                          labelColor: ThemeProvider.blackColor,
                          labelStyle: TextStyle(
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontWeight: FontWeight.w600,
                            color: ThemeProvider.blackColor,
                            fontFamily: "Montserrat",
                          ),
                          tabs: [
                            Tab(
                              child: Text(
                                "Uploaded Video".tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Manage Videos".tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
              
                    SizedBox(
                      height: 2.h,
                    ),
              
                    Expanded(
                      child: TabBarView(
                        controller: logic.tabController,
                        children: [
                          UploadedVideoPage(),
                          ManageVideosPage()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void filterBottomSheet(VideosScreenLogic controller) {
    showModalBottomSheet(
      constraints: BoxConstraints(
        //Increase if height is more than req
        maxHeight: Get.width / 0.6,
      ),
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
        return Container(
          decoration: BoxDecoration(
            color: ThemeProvider.alertColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),

          height: Get.width / 0.6,
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              children: [
                // SizedBox(
                //   height: 2.h,
                // ),
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
                        }, icon: Icon(
                      Icons.close,
                      color: ThemeProvider.closeIcon,
                    ))
                  ],
                ),

                Expanded(
                  child: GridView.builder(
                    itemCount: controller.filters.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 2.h,
                      childAspectRatio: 0.85

                    ),
                    itemBuilder: (context, index) {
                      final item = controller.filters[index];
                      final title = item["title"];
                      final icon = item["icon"];
                      return Obx(() {
                        final isSelected = controller.selectedFilter?.value == title;

                        return GestureDetector(
                          onTap: () {
                            controller.chooseFilter(title);
                            Get.back();
                            showPositionBottomSheet(context, controller.selectedPosition,controller);
                          },
                          child: Container(
                            padding: EdgeInsets.all(1.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.h),
                              border: Border.all(
                                color: isSelected ? ThemeProvider.primary : ThemeProvider.whiteColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  icon,
                                  color: isSelected
                                      ? ThemeProvider.primary
                                      : ThemeProvider.filterIconColor,
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                CommonTextWidget(
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  heading: "$title".tr,
                                  fontSize: Utils.responsiveFontSize(
                                      context, 16.sp),
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? ThemeProvider.primary
                                      : ThemeProvider.whiteColor,
                                  fontFamily: "Montserrat",
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showPositionBottomSheet(BuildContext context, RxString selectedPosition,VideosScreenLogic controller) {
    showModalBottomSheet(
      constraints: BoxConstraints(
        //Increase if height is more than req
        maxHeight: Get.height / 2.2,
      ),
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E), // dark background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (builder) {
        return Padding(
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
                    child: Icon(
                      Icons.close,
                      color: ThemeProvider.closeIcon,
                    ),
                  )
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
                      onTap: () => selectedPosition.value = position,
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
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
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
        );
      },
    );
  }
}