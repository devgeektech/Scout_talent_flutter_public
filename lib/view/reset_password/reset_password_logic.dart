import 'package:get/get.dart';

import '../../backend/helper/app_router.dart';
import '../../backend/model/CommonResponseCodeAndMessageModel.dart';
import '../../backend/model/LoginResModel.dart';
import '../../utils/api_exception.dart';
import '../../utils/app_assets.dart';
import '../../utils/toast.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commonDialog.dart';
import 'reset_password_state.dart';
import 'package:flutter/material.dart';

class ResetPasswordLogic extends GetxController {
  final ResetPasswordState state;
  ResetPasswordLogic({required this.state});

  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update(); // Trigger UI update using GetBuilder
  }
  Future<void> resetPassword(BuildContext context) async {
    LoaderDialog.show(context);

    final response = await state.apiService.postApi(
      endpoint: "auth/reset_password",
      data: {"email": emailController.text.trim(),
              "password":passwordController.text,
              "otp":otpController.text,

      },
    );

    LoaderDialog.hide(context);

    if (response != null) {
      final model = ResponseCodeAndMessageModel.fromJson(response.data);

      if (model.responseCode == 200) {
        successToast(model.responseMessage ?? "Email sent!");
        showCommonDialog(
          // svgContainer: Colors.green,
          context: context,
          title: "Updated Successfully",
          message: "Your password has been changed successfully",
          buttonText: "Back to login",
          svgAsset: AssetPath.success,
          onButtonTap: (){
            Get.offNamed(AppRouter.login);
            emailController.clear();
            passwordController.clear();
            otpController.clear();

          },
        );
        /// Navigate to Reset Password


      } else {
        errorToast(model.responseMessage ?? "Something went wrong");
      }
    } else {
      errorToast("Failed. Try again.");
    }
  }

  Future<void> resendOtpForVerification(BuildContext context) async {
    try {
      LoaderDialog.show(context);
      Map<String, Object> body = {
        "email": emailController.text.trim(),
      };
      var response = await state.resendOtp(body);
      final loginResponseModel = LoginResModel.fromJson(response.data);
      if (response.statusCode == 200) {
        LoaderDialog.hide(context);
        successToast(loginResponseModel.responseMessage.toString().tr);
      } else {
        LoaderDialog.hide(context);
        errorToast(
          loginResponseModel.responseMessage.toString().isNotEmpty
              ? loginResponseModel.responseMessage.toString()
              : "Something went wrong",
        );
      }
    } catch (error) {
      LoaderDialog.hide(context);
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
    }
  }
}
