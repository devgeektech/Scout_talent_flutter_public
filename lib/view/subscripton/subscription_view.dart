import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/subscripton/subscription_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:scouttalent2/widget/commontext.dart';
import 'package:sizer/sizer.dart';

import '../../backend/model/player_subs_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/constants.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commonDialog.dart';
import '../player_report/pdfView.dart';

class SubscriptionSettingPage extends StatefulWidget {
  const SubscriptionSettingPage({super.key});

  @override
  State<SubscriptionSettingPage> createState() =>
      _SubscriptionSettingPageState();
}

class _SubscriptionSettingPageState extends State<SubscriptionSettingPage> {
  final email = Get.arguments["email"];
  bool isAutoRenew = true;

  late SubscriptionSettingLogic logic;

  @override
  void initState() {
    super.initState();
    logic = Get.find<SubscriptionSettingLogic>();
    loadAllUserData();
    logic.loadFreeAccountFlag();
    logic.getAllSubsTrans(email: email);
    logic.getSubsciptions();
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              CommonTextWidget(
                textAlign: TextAlign.start,
                heading: "Billing & Subscription".tr,
                fontSize: Utils.responsiveFontSize(context, 18.sp),
                fontWeight: FontWeight.w600,
                color: ThemeProvider.whiteColor,
                fontFamily: "Montserrat",
              ),

              //Is Free account check
/*              Obx(() {
                if (logic.isFreeAccount.value == true && logic.hasSubscription.value == false) {
                  return Column(
                    children: [
                      SizedBox(height: 3.h),
                      _freeTrialBanner(),
                      SizedBox(height: 2.h),
                      _upgradeButton(),
                    ],
                  );
                }else{
                  return Column(
                    children: [
                      SizedBox(height: 3.h),

                      Obx(() {
                        final subs = logic.playerSubs.value;

                        if (subs == null) {
                          return Center(
                            child: _subscriptionCardFallback(),
                          );
                        }

                        if (subs.responseCode == 404) {
                          return _subscriptionCardFallback();
                        }

                        return _subscriptionCardFromApi(subs);
                      }),

                      SizedBox(height: 3.h),
                      _autoRenewSwitch(),
                      SizedBox(height: 3.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Divider(
                              height: 2,
                              color: ThemeProvider.whiteColor.withAlpha(80),
                              endIndent: 10,
                            ),
                          ),

                          CommonTextWidget(
                            textAlign: TextAlign.start,
                            heading: "Payment History".tr,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontWeight: FontWeight.w500,
                            color: ThemeProvider.whiteColor,
                            fontFamily: "Montserrat",
                          ),
                          Expanded(
                            child: Divider(
                              height: 2,
                              color: ThemeProvider.whiteColor.withAlpha(80),
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),


                      Obx(() {
                        final res = logic.allTransRes.value;

                        if (res == null) {
                          return Center(
                            child: CircularProgressIndicator(color: Colors.orange),
                          );
                        }

                        if (res.data!.isEmpty) {
                          return Center(
                            child: CommonTextWidget(
                              textAlign: TextAlign.center,
                              heading: "No payment history found.".tr,
                              fontSize: Utils.responsiveFontSize(context, 17.sp),
                              fontWeight: FontWeight.w600,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Montserrat",
                            ),
                          );
                        }

                        return Column(
                          children: res.data!.map(
                                (d) => _paymentHistoryTile(
                                plan: d.planDetail?.title ?? "Plan",
                                amount: "${d.planDetail?.price}",
                                // date: DateTime.fromMillisecondsSinceEpoch(
                                //     (d.created! * 1000).toInt())
                                //     .toLocal()
                                //     .toString()
                                //     .split(" ")[0],
                                date: formatDate(d.subscribeDate,showNumeric: true),
                                docURl: d.invoicePdf??""
                            ),
                          )
                              .toList(),
                        );
                      }),
                    ],
                  );
                }
              },),*/
              Column(
            children: [
              SizedBox(height: 3.h),

              Obx(() {
                final subs = logic.playerSubs.value;

                if (subs == null) {
                  return Center(
                    child: _subscriptionCardFallback(),
                  );
                }

                if (subs.responseCode == 404) {
                  return _subscriptionCardFallback();
                }

                return _subscriptionCardFromApi(logic,subs);
              }),

              SizedBox(height: 3.h),
              /*if(logic.hasSubscription.value == true)
              _autoRenewSwitch(),
              if(logic.hasSubscription.value == true)
              SizedBox(height: 3.h),*/
              Obx(() => Column(
                children: [
                  if (logic.subscriptionStatus.value ==
                      Constants.subscriptionActive) ...[
                    _autoRenewSwitch(),
                    SizedBox(height: 3.h),
                  ],
                ],
              )),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Divider(
                      height: 2,
                      color: ThemeProvider.whiteColor.withAlpha(80),
                      endIndent: 10,
                    ),
                  ),

                  CommonTextWidget(
                    textAlign: TextAlign.start,
                    heading: "Payment History".tr,
                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                    fontWeight: FontWeight.w500,
                    color: ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                  ),
                  Expanded(
                    child: Divider(
                      height: 2,
                      color: ThemeProvider.whiteColor.withAlpha(80),
                      indent: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),


              Obx(() {
                final res = logic.allTransRes.value;

                if (res == null) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                if (res.data!.isEmpty) {
                  return Center(
                    child: CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: "No payment history found.".tr,
                      fontSize: Utils.responsiveFontSize(context, 17.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "Montserrat",
                    ),
                  );
                }

                return Column(
                  children: res.data!.map(
                        (d) => _paymentHistoryTile(
                        plan: d.planDetail?.title ?? "Plan",
                        amount: "${d.amount}",
                        // date: DateTime.fromMillisecondsSinceEpoch(
                        //     (d.created! * 1000).toInt())
                        //     .toLocal()
                        //     .toString()
                        //     .split(" ")[0],
                        date: formatDate(d.subscribeDate,showNumeric: true),
                        docURl: d.invoicePdf??""
                    ),
                  )
                      .toList(),
                );
              }),
            ],
          ),

            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // UI WIDGETS ↓↓↓
  // ----------------------------------------------------------

  Widget _freeTrialBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
      decoration: BoxDecoration(
        color: ThemeProvider.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeProvider.primary, width: 1.2),
      ),
      child: CommonTextWidget(
        textAlign: TextAlign.center,
        heading: "A limited-time free trial, courtesy of the admin. Enjoy full access for a short period!".tr,
        fontSize: Utils.responsiveFontSize(context, 15.sp),
        fontWeight: FontWeight.w500,
        color: ThemeProvider.whiteColor,
        fontFamily: "Montserrat",
      ),
    );
  }

  Widget _subscriptionCardFromApi(SubscriptionSettingLogic logic,PlayerSubsModel subs) {
    final data = subs.data!;
    final plan = data.plan;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               CommonTextWidget(
                heading: "Current Plan".tr,
                fontSize: Utils.responsiveFontSize(context, 16.sp),
                fontWeight: FontWeight.w700,
                color: ThemeProvider.blackColor,
                fontFamily: "Montserrat",
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: CommonTextWidget(
                  textAlign: TextAlign.end,
                  heading: plan?.title ?? "N/A",
                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                  fontWeight: FontWeight.w700,
                  color: ThemeProvider.blackColor,
                  fontFamily: "Montserrat",
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Price
          Align(
            alignment: Alignment.centerRight,
            child: CommonTextWidget(
              heading: "€${plan?.finalPrice ?? plan?.price ?? 0} / ${capitalize(plan?.type)}",
              fontSize: Utils.responsiveFontSize(context, 16.sp),
              color: ThemeProvider.primary,
              fontWeight: FontWeight.w600,
              fontFamily: "Montserrat",
            ),
          ),

          SizedBox(height: 2.h),

          // Renew Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextWidget(
                heading: logic.subscriptionStatus.value ==
                    Constants.subscriptionCancel
                    ? "Expires On:".tr
                    : "Renews On:".tr,
                fontSize: Utils.responsiveFontSize(context, 16.sp),
                fontWeight: FontWeight.w700,
                color: ThemeProvider.blackColor,
                fontFamily: "Montserrat",
              ),
              CommonTextWidget(
                heading: data.expiryDate != null
                    ? formatDate("${data.expiryDate}")
                    : "N/A",
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),

          SizedBox(
            height: 1.5.h,
          ),
          Divider(
            color: ThemeProvider.blackColor.withAlpha(10),
          ),
          SizedBox(
            height: 1.5.h,
          ),
          // _upgradeButton(),
          // SizedBox(height: 1.h),
          logic.subscriptionStatus.value ==
              Constants.subscriptionCancel
          ?_upgradeButton(logic)
          :_cancelButton(logic,context),
        ],
      ),
    );
  }

  // Backup Card (if API fails)
  Widget _subscriptionCardFallback() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child:  Column(
        children: [
          CommonTextWidget(
            textAlign: TextAlign.center,
            heading: "No subscription plan found".tr,
            fontSize: Utils.responsiveFontSize(context, 17.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.hintText,
            fontFamily: "Montserrat",
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Divider(
            color: ThemeProvider.blackColor.withAlpha(10),
          ),
          SizedBox(
            height: 1.5.h,
          ),
          _upgradeButton(logic)
        ],
      ),
    );
  }

  Widget _upgradeButton(SubscriptionSettingLogic logic) {
    return Button(onPressed: () {
      Get.toNamed(AppRouter.subscriptionView,arguments: [logic.restoreSubscription,logic.playerSubs.value?.data?.plan]);
    }, title: "Upgrade Plan");
  }

  Widget _cancelButton(SubscriptionSettingLogic logic, BuildContext context) {
    return Button(
      filledColor: false,
        onPressed: () {
        if(logic.playerSubs.value?.data?.paymentType =="stripe"){
          showCommonDialog(
            svgContainer: Colors.white,
            showCloseButton: true,
            context: context,
            title: "Are you Sure?".tr,
            message: "You’re about to Cancel this Subscription. This action can’t be undone.".tr,
            svgAsset: AssetPath.delete,
            buttonText: "Cancel",
            onButtonTap: (){
              Get.back();
            },
            buttonFilled: false,
            secondButtonText: "Yes".tr,
            onSecondButtonTap: () {
              Get.back();
              logic.cancelSubscription(context);
              // logic.handleUserFlow();



            },
          );
        }
        else if(logic.playerSubs.value?.data?.paymentType =="ios"){
          showCommonDialog(
            svgContainer: Colors.white,
            showCloseButton: true,
            context: context,
            title: "Manage Subscription".tr,
            message: "This subscription is managed by Apple. You can cancel it from Apple Subscriptions.".tr,
            svgAsset: AssetPath.delete,
            buttonText: "Cancel",
            onButtonTap: (){
              Get.back();
            },
            buttonFilled: false,
            secondButtonText: "Ok".tr,
            onSecondButtonTap: () {
              Get.back();
              if(Platform.isIOS) {
                logic.openAppleSubscriptions().whenComplete(() {
                //logic.cancelSubscription(context);
                logic.handleUserFlow();

              },);
              }

            },
          );
        }else{
          errorToast("Unable to determine subscription type");
        }


          // logic.playerSubs.value?.data?.paymentType =="stripe"
          // ? showCommonDialog(
          //    svgContainer: Colors.white,
          //    showCloseButton: true,
          //    context: context,
          //    title: "Are you Sure?".tr,
          //    message: "You’re about to Cancel this Subscription. This action can’t be undone.".tr,
          //    svgAsset: AssetPath.delete,
          //    buttonText: "Cancel",
          //    onButtonTap: (){
          //      Get.back();
          //    },
          //    buttonFilled: false,
          //    secondButtonText: "Yes".tr,
          //    onSecondButtonTap: () {
          //      Get.back();
          //      logic.cancelSubscription(context);
          //
          //    },
          //  )
          // :showCommonDialog(
          //   svgContainer: Colors.white,
          //   showCloseButton: true,
          //   context: context,
          //   title: "Manage Subscription".tr,
          //   message: "This subscription is managed by Apple. You can cancel it from Apple Subscriptions.".tr,
          //   svgAsset: AssetPath.delete,
          //   buttonText: "Cancel",
          //   onButtonTap: (){
          //     Get.back();
          //   },
          //   buttonFilled: false,
          //   secondButtonText: "Ok".tr,
          //   onSecondButtonTap: () {
          //     Get.back();
          //     logic.openAppleSubscriptions();
          //
          //   },
          // );
        },
    title: "Cancel Subscription");
  }

  Widget _autoRenewSwitch() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                textAlign: TextAlign.start,
                heading: "Auto-Renewal".tr,
                fontSize: Utils.responsiveFontSize(context, 16.sp),
                fontWeight: FontWeight.w600,
                color: ThemeProvider.blackColor,
                fontFamily: "Montserrat",
              ),
              SizedBox(
                height: 1.h,
              ),
              CommonTextWidget(
                textAlign: TextAlign.start,
                heading: "Automatically renew your subscription".tr,
                fontSize: Utils.responsiveFontSize(context, 14.sp),
                fontWeight: FontWeight.w500,
                color: ThemeProvider.blackColor,
                fontFamily: "Montserrat",
              ),
            ],
          ),
          FlutterSwitch(
            activeToggleColor: ThemeProvider.whiteColor,
            inactiveColor:ThemeProvider.blackColor,
            activeColor: ThemeProvider.primary,
            inactiveToggleColor: ThemeProvider.whiteColor,
            width: 50,
            height:30,
            value: true,
            borderRadius: 20.0,
            onToggle: (val) {
              setState(() {
                isAutoRenew = val;
              });
            },
          ),

        ],
      ),
    );
  }

  Widget _paymentHistoryTile({
    required String plan,
    required String amount,
    required String date,
    required String docURl,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.symmetric(vertical:2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal:4.w),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CommonTextWidget(
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      heading: plan,
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.blackColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  CommonTextWidget(
                    textAlign: TextAlign.center,
                    heading: "€$amount",
                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                    fontWeight: FontWeight.w600,
                    color: ThemeProvider.primary,
                    fontFamily: "Montserrat",
                  ),
                ]),
          ),
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:4.w),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget(
                    textAlign: TextAlign.start,
                    heading: date,
                    fontSize: Utils.responsiveFontSize(context, 15.sp),
                    fontWeight: FontWeight.w500,
                    color: ThemeProvider.closeIcon,
                    fontFamily: "Montserrat",
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 0.5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.h),
                      color: ThemeProvider.slightlyColor
                    ),
                    child: CommonTextWidget(
                      textAlign: TextAlign.start,
                      heading: "Paid".tr,
                      fontSize: Utils.responsiveFontSize(context, 15.sp),
                      fontWeight: FontWeight.w600,
                      color: ThemeProvider.darkGreenColor,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ]),
          ),

          //Download invoice on android only
          if(Platform.isAndroid)...[
            SizedBox(height: 2.h),
            Divider(
              height: 2,
              color: ThemeProvider.blackColor.withAlpha(20),
              endIndent: 10,
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:4.w),
              child: InkWell(
                onTap: () {
                  if (kDebugMode) {
                    print("docURl--->$docURl");
                  }
                  if (docURl == "null" || docURl.isEmpty) {
                    // Show error or info
                    successToast("Document not available",);
                    return; // Stop navigation
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PdfPreviewScreen(
                            pdfUrl: docURl,
                            fileName: 'player_cv.pdf',
                            type: "invoice",
                          ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget(
                      textAlign: TextAlign.start,
                      heading: "Download Invoice".tr,
                      fontSize: Utils.responsiveFontSize(context, 15.sp),
                      fontWeight: FontWeight.w500,
                      color: ThemeProvider.blueColor,
                      fontFamily: "Montserrat",
                    ),

                    SvgPicture.asset(
                        AssetPath.download
                    )
                  ],
                ),
              ),
            ),
          ]

        ],
      ),
    );
  }
}
