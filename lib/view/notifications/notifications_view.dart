import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/model/notification_model.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/widget/common_back_button.dart';
import 'package:scouttalent2/widget/commontext.dart';
import 'package:sizer/sizer.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/customDropDown.dart';
import 'notifications_logic.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsLogic logic = Get.put(
        NotificationsLogic(state: Get.find()));
    return GetBuilder(
      init: NotificationsLogic(state: Get.find()),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: ThemeProvider.bgColor,
            elevation: 0,
            leading: CommonBackButton(onTap: () => Get.back()),
          ),
          body: SafeArea(
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    title: CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: "Notifications".tr,
                      fontSize: Utils.responsiveFontSize(context, 20.sp),
                      fontWeight: FontWeight.w500,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ],
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: controller.onScrollingPage,
                      child: CustomScrollView(
                        controller: controller.scrollController,
                        slivers: [
            
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: CustomDropdownButton(
                                              hintText: 'all_notification'.tr,
                                              items: controller.privacyMap.values
                                                  .toList(),
                                              selectedValue: controller
                                                  .privacyMap[controller
                                                  .selectedPrivacy],
                                              onChanged: (value) {
                                                final key = controller.privacyMap
                                                    .entries
                                                    .firstWhere((e) =>
                                                e.value == value)
                                                    .key;
                                                controller.updateSelectedPrivacy(key);
                                              },
                                              isExpanded: true,
                                            ),
                                          ),
                                        ],
                                      ),
            
                                      Obx(() {
                                        final bool hasUnread = logic.unreadCount.value > 0;
                                        return GestureDetector(
                                          onTap: () {
                                            if (hasUnread) {
                                              controller.markAllRead();
                                            } else {
                                              successToast("All notifications are already marked as read");
                                            }
                                          },
                                          child: Container(
                                            height: 4.h,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: hasUnread == true ? ThemeProvider
                                                  .primary : ThemeProvider
                                                  .unselectedFilter,
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Center(
                                              child: CommonTextWidget(
                                                heading: "Mark all as read".tr,
                                                fontSize: Utils.responsiveFontSize(
                                                    context, 14.sp),
                                                color: hasUnread == true
                                                    ? ThemeProvider.whiteColor
                                                    : ThemeProvider.whitish,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],
                            ),
                          ),
            
                          controller.notificationList.isNotEmpty
                              ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) => cardComponent(logic,context, index,
                                  controller.notificationList[index], (
                                      int callBackIndex) {}),
                              childCount: controller.notificationList.length,
                            ),
                          )
                              : SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: CommonTextWidget(
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                                heading: "No data found".tr,
                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                fontWeight: FontWeight.w700,
                                color: ThemeProvider.whitish,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
            
            
                )
            ),
          ),
        );
      },
    );
  }

  cardComponent(NotificationsLogic logic,BuildContext context, int index, NotificationList data,
      Function(int) callBack) {
    return GestureDetector(
      onTap: () => callBack(index),
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(vertical: 2.h, horizontal: 2.5.w),
        margin: EdgeInsetsGeometry.symmetric(vertical: .5.h),
        decoration: BoxDecoration(
          color: ThemeProvider.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: .8.h,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 3.h,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: ThemeProvider.primary),
                child: CommonTextWidget(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  lineHeight: 1.5,
                  textOverflow: TextOverflow.ellipsis,
                  heading: data.type ?? "",
                  fontSize: Utils.responsiveFontSize(context, 14.sp),
                  color: ThemeProvider.whiteColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                ),
              ),
            ),


            CommonTextWidget(
              textAlign: TextAlign.center,
              heading:logic.selectedLanguage.value == 'en'
                  ? (data.title?.en ?? '')
                  : (data.title?.ro ?? ''),
              fontSize: Utils.responsiveFontSize(context, 14.sp),
              fontWeight: FontWeight.w600,
              color: data.isRead == false
                  ? ThemeProvider.blackColor
                  : ThemeProvider.unselectedFilter,
              fontFamily: "Montserrat",
            ),

            CommonTextWidget(
              textAlign: TextAlign.left,
              heading: logic.selectedLanguage.value == 'en'
                  ? (data.description?.en ?? '')
                  : (data.description?.ro ?? ''),
              fontSize: Utils.responsiveFontSize(context, 14.sp),
              fontWeight: FontWeight.w400,
              color: ThemeProvider.gray,
              fontFamily: "Montserrat",
            ),

            CommonTextWidget(
              textAlign: TextAlign.left,
              heading: "${formatLocalDate(data.createdAt!)} , ${formatTime(data.createdAt!)}",
              fontSize: Utils.responsiveFontSize(context, 14.sp),
              fontWeight: FontWeight.w400,
              color: ThemeProvider.gray,
              fontFamily: "Montserrat",
            ),

          ],
        ),
      ),
    );
  }
}
