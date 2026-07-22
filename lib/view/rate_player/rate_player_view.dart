import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/view/rate_player/rate_player_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/customSlider.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';

class RatePlayerPage extends StatefulWidget {
  const RatePlayerPage({super.key});

  @override
  State<RatePlayerPage> createState() => _RatePlayerPageState();
}

class _RatePlayerPageState extends State<RatePlayerPage> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatePlayerLogic>(
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                CommonTextWidget(
                  heading: "Rate Player",
                  fontSize: Utils.responsiveFontSize(context, 20.sp),
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(
                  height: 4.h,
                ),


                // Technical
                CommonTextWidget(
                  heading: "Technical",
                  fontSize: Utils.responsiveFontSize(context, 18.sp),
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(height: 2.h),
                ratingRow("Shooting", controller.shootingSlider, (val) =>
                    setState(() => controller.shootingSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Passing", controller.passingSlider, (val) =>
                    setState(() => controller.passingSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Dribbling", controller.dribblingSlider, (val) =>
                    setState(() => controller.dribblingSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Ball Control", controller.ballControlSlider, (val) =>
                    setState(() => controller.ballControlSlider = val)),

                SizedBox(height: 4.h),

                // Physical
                CommonTextWidget(
                  heading: "Physical",
                  fontSize: Utils.responsiveFontSize(context, 18.sp),
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(height: 2.h),
                ratingRow("Speed", controller.speedSlider, (val) =>
                    setState(() => controller.speedSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Strength", controller.strengthSlider, (val) =>
                    setState(() => controller.strengthSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Stamina", controller.staminaSlider, (val) =>
                    setState(() => controller.staminaSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Agility", controller.agilitySlider, (val) =>
                    setState(() => controller.agilitySlider = val)),

                SizedBox(height: 4.h),

                // Defensive / Offensive
                CommonTextWidget(
                  heading: "Defensive / Offensive",
                  fontSize: Utils.responsiveFontSize(context, 18.sp),
                  fontWeight: FontWeight.w500,
                  color: ThemeProvider.whiteColor,
                  fontFamily: "Montserrat",
                ),
                SizedBox(height: 2.h),
                ratingRow("Tackling", controller.tacklingSlider, (val) =>
                    setState(() => controller.tacklingSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Positioning", controller.positioningSlider, (val) =>
                    setState(() => controller.positioningSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Vision", controller.visionSlider, (val) =>
                    setState(() => controller.visionSlider = val)),
                SizedBox(height: 2.h),
                ratingRow("Off-the-ball Movement", controller.offTheBallSlider, (val) =>
                    setState(() => controller.offTheBallSlider = val)),

                SizedBox(height: 4.h),

                Button(onPressed: () {
                  controller.ratePlayerApi(context);
                }, title: "Submit")

              ],
            ),
          ),
        ),
      );
    });
  }

  Widget ratingRow(String heading, double value,
      ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: CommonTextWidget(
            heading: heading,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w500,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 14,
              trackShape: const RoundedSliderTrackShape(),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8,
              ),
              thumbColor: Colors.white,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
                value: value,
                min: 0,
                max: 100,
                onChanged: onChanged
            ),
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 25,
          child: CommonTextWidget(
            textAlign: TextAlign.end,
            heading: value.toInt().toString(),
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w500,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
          ),
        ),
      ],
    );
  }
}
