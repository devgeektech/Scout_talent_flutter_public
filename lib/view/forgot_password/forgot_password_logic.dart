import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../backend/helper/app_router.dart';
import '../../backend/model/CommonResponseCodeAndMessageModel.dart';
import '../../utils/toast.dart';
import '../../widget/commomLoader.dart';
import 'forgot_password_state.dart';

class ForgotPasswordLogic extends GetxController {
  final ForgotPasswordState state;

  ForgotPasswordLogic({required this.state});

  final TextEditingController emailController = TextEditingController();

  Future<void> forgotPassword(BuildContext context) async {
    String? currentLang = state.getLanguage();
    LoaderDialog.show(context);

    final response = await state.apiService.postApi(
      endpoint: "auth/forgot_password",
      data: {"email": emailController.text.trim()},
      // lang: currentLang,
    );

    LoaderDialog.hide(context);

    if (response != null) {
      final model = ResponseCodeAndMessageModel.fromJson(response.data);

      if (model.responseCode == 200) {
        successToast(model.responseMessage ?? "Email sent!");

        /// Navigate to Reset Password
        Get.toNamed(
          AppRouter.resetPassword,
          arguments: {
            "email": emailController.text.trim(),
          },
        );
        emailController.clear();
      } else {
        errorToast(model.responseMessage ?? "Something went wrong");
      }
    } else {
      errorToast("Failed. Try again.");
    }
  }
}
