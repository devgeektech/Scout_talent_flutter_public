import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_assets.dart';
import '../utils/theme.dart';
import 'commontext.dart';

class CommonMenuWidget extends StatelessWidget {
  final double screenWidth;
  final String userIconAssetPath;
  final String accountText;

  const CommonMenuWidget({super.key, 
    required this.screenWidth,
    required this.userIconAssetPath,
    required this.accountText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [

              Container(
                width: Get.width * 0.13,
                height: Get.width  * 0.13,
                decoration: BoxDecoration(
                  color: ThemeProvider.primary.withOpacity(0.05),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: SvgPicture.asset(userIconAssetPath,
                    colorFilter: ColorFilter.mode(ThemeProvider.primary, BlendMode.srcIn),
                  ),
                ),
              ),

              SizedBox(width: screenWidth * 0.09),
              CommonTextWidget(
                heading: accountText,
                fontSize: 16.sp,
                color: ThemeProvider.blackColor,
                fontFamily: 'bold',
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child:
                SvgPicture.asset(AssetPath.splash, width: Get.width * 0.02,color: ThemeProvider.primary,),
          ),
        ],
      ),
    );
  }
}
