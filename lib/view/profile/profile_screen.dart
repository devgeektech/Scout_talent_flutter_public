import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import 'package:scouttalent2/view/profile/profile_controller.dart';
import 'package:scouttalent2/view/profile/update_profile.dart';
import 'package:scouttalent2/widget/profileTile.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../utils/webViewOpen.dart';
import '../../widget/commontext.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import 'accountSettngs.dart';
import 'notes_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  String? emailID;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: ThemeProvider.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CommonTextWidget(
                  heading: "Settings",
                  color: ThemeProvider.whiteColor,
                  fontSize: Utils.responsiveFontSize(context, 18.sp),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 2.h),

              /// ---------------------- PROFILE IMAGE ----------------------
              Obx(() {
                final avatar = controller.profile.value?.data?.avatar;
                return Stack(
                  children: [
                    CircleAvatar(
                      radius: 25.sp,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: avatar != null && avatar.isNotEmpty
                          ? NetworkImage(Utils.imageUrl + avatar)
                          : null,
                      child: avatar == null || avatar.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.white70,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPicture.asset(AssetPath.camera),
                    ),
                  ],
                );
              }),

              SizedBox(height: 2.h),

              /// ---------------------- NAME ----------------------
              Obx(() {
                final firstName =
                    controller.profile.value?.data?.firstName ?? '';
                final lastName = controller.profile.value?.data?.lastName ?? '';
                return CommonTextWidget(
                  heading: '$firstName $lastName',
                  color: ThemeProvider.whiteColor,
                  fontSize: Utils.responsiveFontSize(context, 18.sp),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  textAlign: TextAlign.center,
                );
              }),

              SizedBox(height: 0.5.h),

              /// ---------------------- EMAIL ----------------------
              Obx(() {
                final email = controller.profile.value?.data?.email ?? '';
                emailID = email;
                return CommonTextWidget(
                  heading: email,
                  color: ThemeProvider.whiteColor,
                  fontSize: Utils.responsiveFontSize(context, 14.sp),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  textAlign: TextAlign.center,
                );
              }),

              SizedBox(height: 4.h),

              /// ---------------------- SETTINGS CARD ----------------------
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ProfileTile(
                            onTap: (){
                              Get.to(() => UpdateProfile());
                            },
                            icon: AssetPath.profile, title: 'Profile'),
                        controller.parser.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer ?SizedBox():  ProfileTile(
                          onTap: (){
                            Get.toNamed(AppRouter.savedPlayer);
                          },
                          icon: AssetPath.profile,
                          title: "Saved Players",
                        ),
                        controller.parser.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer ?SizedBox():      ProfileTile(
                            onTap: (){
                              Get.to(NotesScreen());
                            },
                            icon: AssetPath.profile, title: "Notes".tr),
                        ProfileTile(
                          onTap: () {
                            Get.toNamed(
                              AppRouter.subScriptionSetting,
                              arguments: {
                                "email": emailID,
                              },
                            );
                          },
                          icon: AssetPath.billingsAndSubscriptions,
                          title: "Billing & Subscription",
                        ),
                        ProfileTile(
                          icon: AssetPath.changePassword,
                          title: "Change Password",
                          onTap: () => Get.toNamed(AppRouter.changePassword),
                        ),
                        ProfileTile(
                          icon: AssetPath.policy,
                          title: "Privacy Policy",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewOpen(webViewUrl: "https://scouttalentworld.com/privacy-policy")));
                          },
                        ),
                        ProfileTile(
                          icon: AssetPath.termsAndConditions,
                          title: "Terms & Conditions",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewOpen(webViewUrl: "https://scouttalentworld.com/terms-and-conditions")));
                          },
                        ),
                        ProfileTile(
                          onTap: () => Get.toNamed(AppRouter.getContactUs()                           ),

                          icon: AssetPath.contact_us,
                          title: "Contact Us",
                        ),
                        ProfileTile(
                          icon: AssetPath.accountSettings,
                          title: "Account Settings",
                          onTap: () {
                            Get.to(() => const AccountSettings());
                          },
                        ),
                      ],
                    ),
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
