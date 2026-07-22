import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/constants.dart';
import 'package:scouttalent2/utils/string.dart';
import 'package:scouttalent2/view/profile/profile_controller.dart';
import 'package:scouttalent2/widget/commonDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../backend/helper/app_router.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';
import '../../widget/profileTile.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Scaffold(
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
      extendBodyBehindAppBar: false,
      backgroundColor: ThemeProvider.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CommonTextWidget(
                  heading: "Account Settings",
                  color: ThemeProvider.whiteColor,
                  fontSize: Utils.responsiveFontSize(context, 18.sp),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 3.h),

              /// ---------------------- SETTINGS CARD ----------------------
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Obx(
                      () => ProfileTile(
                  icon: AssetPath.notifications,
                  title: 'Notifications',
                  toggle: true,
                  toggleValue: controller.notificationsEnabled.value,
                  onToggleChanged: (value) {
                    controller.toggleNotifications(value, context);
                  },
                ),
              ),

                      ProfileTile(
                        icon: AssetPath.delete,
                        title: 'Delete Account',
                        isRead: true,
                        onTap: () async {
                          await controller.loadUserProfile(context);
                          print("controller.subscriptionStatus.value---->${controller.subscriptionStatus.value}");
                          controller.subscriptionStatus.value == Constants.subscriptionActive
                          ?showCommonDialog(
                            bgColor: ThemeProvider.whiteColor,
                            showCloseButton: true,
                            closeIconColor: ThemeProvider.blackColor,
                            context: context,
                            title: "Active Subscription Found",
                            titleColor: ThemeProvider.blackColor,
                            messageColor: ThemeProvider.textColor,
                            message:
                            "Your account currently has an active subscription.\n\nPlease cancel it before deleting your account.",
                            svgAsset: AssetPath.deleteSuccess,
                            circleSize: 80,
                            buttonText: "Not Now",
                            onButtonTap: () {
                              Get.back();
                            },
                            buttonFilled: false,
                            secondButtonText: "Cancel",
                            onSecondButtonTap: () {
                              Navigator.of(context).pop();
                              controller.openAppleSubscriptions();
                            },
                          )
                          :showCommonDialog(
                            bgColor: ThemeProvider.whiteColor,
                            showCloseButton: true,
                            closeIconColor: ThemeProvider.blackColor,
                            context: context,
                            title: "Are you Sure?",
                            titleColor: ThemeProvider.blackColor,
                            messageColor: ThemeProvider.textColor,
                            message:
                            "You are about to delete your account. You won’t be able to recover them.",
                            svgAsset: AssetPath.deleteSuccess,
                            circleSize: 80,
                            buttonText: "Cancel",
                            onButtonTap: () {
                              Get.back();
                            },
                            buttonFilled: false,
                            secondButtonText: "Delete",
                            onSecondButtonTap: () {
                              Navigator.of(context).pop();
                              controller.deleteAccount(context);
                            },
                          );
                        },
                      ),
                      ProfileTile(
                        icon: AssetPath.logOut,
                        title: "Log Out",
                        onTap: () {
                          showCommonDialog(
                            buttonFilled: false,
                            secondButtonFilled: false,
                            svgContainer: Colors.white,
                            svgAsset: AssetPath.logOut,
                            context: context,
                            title: "Log Out",
                            message: "Are you sure you want to log out?",
                            buttonText: "No",
                            secondButtonText: "Yes",
                            onSecondButtonTap: () async {
                              /* SharedPreferences prefs = await SharedPreferences.getInstance();


                              await prefs.remove(AppString.authToken);
                              await prefs.remove(AppString.uid);
                              Get.offAllNamed(AppRouter.login);*/
                              controller.logout();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
