import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/subscription_pricing/subscription_pricing_view.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';
import '../subscription/subscription_logic.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionLogic>(
      builder: (controller) {
        final bool isPlayer =
            controller.state.sharedPreferencesManager
                .getString('selectedUserRole') ==
                Constants.userRolePlayer;

        return DefaultTabController(
          length: isPlayer ? 1 : 2,
          child: Scaffold(
            backgroundColor: ThemeProvider.bgColor,
            body: SafeArea(
              child: Padding(
                padding:
                EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      heading: "Budget-Friendly Options".tr,
                      fontSize:
                      Utils.responsiveFontSize(context, 22.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),

                    SizedBox(height: 2.h),

                    CommonTextWidget(
                      heading:
                      "Find the right plan for your goals.".tr,
                      fontSize:
                      Utils.responsiveFontSize(context, 16.sp),
                      fontWeight: FontWeight.w500,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),

                    SizedBox(height: 5.h),

                    /// 🔹 TAB BAR
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeProvider.whiteColor,
                          borderRadius:
                          BorderRadius.circular(4.h),
                        ),
                        child: TabBar(

                          dividerColor: Colors.transparent,
                          indicatorSize:
                          TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: ThemeProvider.primary,
                            borderRadius:
                            BorderRadius.circular(4.h),
                          ),
                          unselectedLabelColor:
                          ThemeProvider.primary,
                          labelColor:
                          ThemeProvider.whiteColor,
                          labelStyle: TextStyle(
                            fontSize:
                            Utils.responsiveFontSize(
                                context, 16.sp),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                          ),
                          tabs: isPlayer
                              ? const [
                            Tab(text: "Monthly"),
                          ]
                              : const [
                            Tab(text: "Monthly"),
                            Tab(text: "Annually"),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    /// 🔹 TAB VIEW
                    Expanded(
                      child: TabBarView(
                        children: isPlayer
                            ? [
                          SingleChildScrollView(
                            child: SubscriptionPricingPage(pricing: "monthly", isRestoredSubscription: controller.isRestoredSubscription,subscriptionPlan: controller.plan,),
                          ),
                        ]
                            : [
                          SingleChildScrollView(
                            child: SubscriptionPricingPage(pricing: "monthly", isRestoredSubscription: controller.isRestoredSubscription,subscriptionPlan: controller.plan,),
                          ),
                          SingleChildScrollView(
                            child: SubscriptionPricingPage(pricing: "annual", isRestoredSubscription: controller.isRestoredSubscription,subscriptionPlan: controller.plan,),
                          ),
                        ],
                      ),
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
}
