import 'package:get/get.dart';
import 'package:scouttalent2/view/contact_us/contact_us_state.dart';
import '../../utils/api_exception.dart';
import '../../utils/toast.dart';
import '../../widget/commomLoader.dart';
import 'package:flutter/material.dart';

class ContactUsLogic extends GetxController {
  final ContactUsState state;
  ContactUsLogic({required this.state});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();


  ContactUsRequest contactUsRequest = ContactUsRequest();
  Future<void> contactUsApi(BuildContext context) async {
    try {
      LoaderDialog.show(context);
      contactUsRequest = ContactUsRequest(
          email: emailController.text.toString(),
          name: nameController.text.toString(),
          message: messageController.text.toString(),
          role:state.sharedPreferencesManager.getString('selectedUserRole')
      );
      print("contactUsRequest--->${contactUsRequest.toString()}");
      var response = await state.contactApi(contactUsRequest.toJson());
      print("response-->${response.statusCode}");
      if (response.statusCode == 200) {
        LoaderDialog.hide(context);
        successToast(response.data['responseMessage'] ?? "Success");

        Future.delayed(Duration(milliseconds: 500),() {
          Navigator.of(context).pop(true);
        },);
      } else {
        LoaderDialog.hide(context);
      }
    } catch (error) {
      LoaderDialog.hide(context);
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
    }
  }
}
class ContactUsRequest {
  String? name;
  String? email;
  String? message;
  String? role;

  ContactUsRequest(
      {this.name,
        this.email,
        this.message,
        this.role,
      });

  ContactUsRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    message = json['message'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['message'] = message;
    data['role'] = role;
    return data;
  }
}