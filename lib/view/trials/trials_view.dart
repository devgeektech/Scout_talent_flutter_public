import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/view/trials/all_trials/all_trials_view.dart';
import 'package:scouttalent2/view/trials/my_trials/my_trials_view.dart';
import 'package:sizer/sizer.dart';
import '../../widget/commontext.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import 'trials_logic.dart';

class TrialsScreen extends StatelessWidget {
  const TrialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrialsLogic>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          appBar: AppBar(
            forceMaterialTransparency: true,
            backgroundColor: ThemeProvider.bgColor,
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
          ),

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  CommonTextWidget(
                    textAlign: TextAlign.center,
                    heading: "Trials".tr,
                    fontSize: Utils.responsiveFontSize(context, 18.sp),
                    fontWeight: FontWeight.w600,
                    color: ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: ThemeProvider.primary,
                        borderRadius: BorderRadius.circular(4.h),
                        border: Border.all(color: ThemeProvider.whiteColor)
                    ),
                    child: TabBar(
                      controller: controller.tabController,
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
                        Tab(text: "All trials".tr),
                        Tab(text: "My Trials".tr),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.w),


                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        AllTrialsPage(),
                        MyTrialsPage()
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
