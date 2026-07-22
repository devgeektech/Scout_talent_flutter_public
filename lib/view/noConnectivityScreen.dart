import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';
import '../widget/commontext.dart';

class NoConnectivityScreen extends StatelessWidget {
  const NoConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ThemeProvider.bgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Icon(
                      Icons.signal_cellular_connected_no_internet_4_bar_sharp,
                    color: ThemeProvider.whiteColor,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Center(
                    child: CommonTextWidget(
                      heading: "Oops!".tr,
                      fontSize: 14.sp,
                      color: ThemeProvider.whiteColor,
                      fontFamily: "ManropeSemiBold",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CommonTextWidget(
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    heading: "It seems you're not connected to the internet. Please check your connection and try again.",
                    fontSize: Utils.responsiveFontSize(context, 14.sp),
                    fontWeight: FontWeight.w600,
                    color: ThemeProvider.whiteColor,
                    fontFamily: "Montserrat",
                    lineHeight: 1.3,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:CommonTextWidget(
                  textOverflow: TextOverflow.ellipsis,
                  heading: "Try again",
                  fontSize: 12.sp,
                  color: ThemeProvider.primary,
                  fontFamily: "ManropeSemibold",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}