import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_assets.dart';
import 'splash_controller.dart';
import '../../utils/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
       builder: (value) {
      return Scaffold(
        body:  Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ThemeProvider.whiteColor,
            image: DecorationImage(
                image: AssetImage(AssetPath.splash,),
              fit: BoxFit.cover
            )
          ),
        ),
      );
    });
  }
}

