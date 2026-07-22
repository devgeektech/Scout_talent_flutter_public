import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/model/player_subs_model.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/view/subscription_pricing/subscription_pricing_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';

import '../../backend/model/GetAllPlayerPlansModel.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commonDialog.dart';
import '../../widget/commontext.dart';

class SubscriptionPricingPage extends StatefulWidget {
  final String pricing;
  final bool isRestoredSubscription;
  final SubscriptionPlan? subscriptionPlan;

  const SubscriptionPricingPage({super.key, this.pricing = "",this.isRestoredSubscription = false, this.subscriptionPlan});

  @override
  State<SubscriptionPricingPage> createState() =>
      _SubscriptionPricingPageState();
}

class _SubscriptionPricingPageState extends State<SubscriptionPricingPage> {
  final SubscriptionPricingLogic subscriptionPricingLogic = Get.put(
    SubscriptionPricingLogic(state: Get.find()),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("widget.isRestoredSubscription=====>${widget.isRestoredSubscription}");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionPricingLogic>(
      init: subscriptionPricingLogic,
      builder: (controller) {
        final bool isPlayer =
            controller.state.sharedPreferencesManager.getString(
              'selectedUserRole',
            ) ==
            Constants.userRolePlayer;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.4,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: widget.pricing == "monthly"
                  ? controller.monthlyPlans.length
                  : controller.annualPlans.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildSubscriptionCard(
                    index,
                    widget.pricing,
                    isPlayer ? "2 Months FREE" : 'First Month FREE',
                    controller,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubscriptionCard(
    int index,
    String pricing,
    String title,
    SubscriptionPricingLogic controller,
  ) {
    final isMonthly = pricing == "monthly".tr;
    final plan = isMonthly
        ? controller.monthlyPlans[index]
        : controller.annualPlans[index];

    final restrictionList =
        ((controller.currentLang ?? "").isEmpty ||
                    controller.currentLang == "en"
                ? plan.restrictions
                : plan.roRestrictions)
            ?.where((f) => f.trim().isNotEmpty)
            .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(2.h),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: SvgPicture.asset(AssetPath.featuredIcon)),
                  SizedBox(height: 10),
                  Center(
                    child: CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading:
                          ((controller.currentLang ?? "").isEmpty ||
                              controller.currentLang == "en")
                          ? (pricing == "monthly".tr
                                ? (controller.monthlyPlans[index].title ?? "")
                                : (controller.annualPlans[index].title ?? ""))
                          : (pricing == "monthly".tr
                                ? (controller.monthlyPlans[index].roTitle ?? "")
                                : (controller.annualPlans[index].roTitle ??
                                      "")),
                      fontSize: Utils.responsiveFontSize(context, 20.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.primary,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: CommonTextWidget(
                      textAlign: TextAlign.start,
                      heading: pricing == "monthly"
                          ? '€ ${controller.monthlyPlans[index].price}/Monthly'
                                .tr
                          : '€ ${controller.annualPlans[index].price}/Annually'
                                .tr,
                      fontSize: Utils.responsiveFontSize(context, 20.sp),
                      fontWeight: FontWeight.w700,
                      color: ThemeProvider.navyBlue,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.center,
                    child: firstMonthBanner(title,context),
                  ),
                  SizedBox(height: 1.h),
                  // --- Feature List (Dynamic) ---
                  Align(
                    alignment: Alignment.topLeft,
                    child: CommonTextWidget(
                      textAlign: TextAlign.start,
                      heading: "Features".tr,
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontWeight: FontWeight.w700,
                      color: ThemeProvider.navyBlue,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Column(
                    children: () {
                      final isMonthly = pricing == "monthly".tr;
                      final plan = isMonthly
                          ? controller.monthlyPlans[index]
                          : controller.annualPlans[index];

                      // Choose correct language list
                      // Remove empty items → icon + text won't show
                      final featureList =
                          ((controller.currentLang ?? "").isEmpty ||
                                      controller.currentLang == "en"
                                  ? plan.features
                                  : plan.roFeatures)
                              ?.where((f) => f.trim().isNotEmpty)
                              .toList();

                      return List.generate(featureList!.length, (i) {
                        final feature = featureList[i];

                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.2.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: ThemeProvider.navyBlue,
                                size: 2.h,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: CommonTextWidget(
                                  heading: feature.tr,
                                  fontSize: Utils.responsiveFontSize(
                                    context,
                                    16.sp,
                                  ),
                                  fontWeight: FontWeight.w500,
                                  color: ThemeProvider.navyBlue,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    }(),
                  ),

                  if (restrictionList != null &&
                      restrictionList.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.topLeft,
                      child: CommonTextWidget(
                        textAlign: TextAlign.start,
                        heading: "Restrictions".tr,
                        fontSize: Utils.responsiveFontSize(context, 16.sp),
                        fontWeight: FontWeight.w700,
                        color: ThemeProvider.navyBlue,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Column(
                      children: () {
                        return List.generate(restrictionList.length, (i) {
                          final feature = restrictionList[i];

                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.2.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: ThemeProvider.navyBlue,
                                  size: 2.h,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: CommonTextWidget(
                                    heading: feature.tr,
                                    fontSize: Utils.responsiveFontSize(
                                      context,
                                      16.sp,
                                    ),
                                    fontWeight: FontWeight.w500,
                                    color: ThemeProvider.navyBlue,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      }(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Button(
            onPressed: () {
              print("BUTTON CLICKED");

              final isMonthly = pricing == "monthly".tr;
              final plan = isMonthly
                  ? controller.monthlyPlans[index]
                  : controller.annualPlans[index];

              if (Platform.isIOS) {
                if(widget.isRestoredSubscription == true){
                  showIOSSubscriptionDialog(context,controller,widget.subscriptionPlan!);
                }else{
                  controller.buyApplePlan(plan);
                }

              } else {
                controller.makePayment(
                  context,
                  email: Utils.userEmail,
                  plan: plan.priceId,
                  planId: plan.sId,
                );
              }

              // Get.toNamed(AppRouter.dashboard);
            },
            title: "Continue",
          ),
        ],
      ),
    );
  }
}

Widget firstMonthBanner(String title,BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F5E9), // light green bg
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        Icon(
          Icons.check_circle,
          color: ThemeProvider.greenColor,
          size: 2.h,
        ),
        SizedBox(
          width: 5,
        ),
        // Text column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonTextWidget(
              textAlign: TextAlign.start,
              heading: title.tr,
              fontSize: Utils.responsiveFontSize(context, 16.sp),
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
              fontFamily: "Montserrat",
            ),
            SizedBox(
              height: 2,
            ),
            CommonTextWidget(
              textAlign: TextAlign.start,
              heading: "Cancel anytime!".tr,
              fontSize: Utils.responsiveFontSize(context, 11),
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
              fontFamily: "Montserrat",
            ),
          ],
        ),
      ],
    ),
  );
}
void showIOSSubscriptionDialog(
    BuildContext context,
    SubscriptionPricingLogic controller,
    SubscriptionPlan plan
    ) {
  showCommonDialog(
    context: context,
    bgColor: ThemeProvider.whiteColor,
    showCloseButton: true,
    closeIconColor: ThemeProvider.blackColor,
    title: "Subscription Found",
    titleColor: ThemeProvider.blackColor,
    messageColor: ThemeProvider.textColor,
    message:"You already have an active subscription. You can restore your subscription from Apple settings before purchasing a new plan.",

    circleSize: 80,
    buttonText: "Restore",
    buttonFilled: false,
    onButtonTap: () async {
      Get.back();
      await controller.restoreApplePurchase(plan);
    },
    secondButtonText: "Cancel",
    onSecondButtonTap: () {
      Get.back();
      // controller.openAppleSubscriptions();
    },
  );
}