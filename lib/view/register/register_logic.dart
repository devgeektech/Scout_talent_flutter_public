import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/widget/commomLoader.dart';
import '../../backend/helper/app_router.dart';
import '../../backend/model/RegisterModel.dart';
import '../../utils/utils.dart';
import 'register_state.dart';
import 'package:http/http.dart' as http;
class RegisterLogic extends GetxController {
  final RegisterState state;

  RegisterLogic({required this.state});

  String? selectedRelation;
  bool isPasswordVisible = false;
  bool isTermConditionsChecked = false;
  bool isSubscribe = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController currentTeamController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  TextEditingController parentFirstNameController = TextEditingController();
  TextEditingController parentLastNameController = TextEditingController();
  TextEditingController parentEmailController = TextEditingController();
  TextEditingController parentContactController = TextEditingController();
  TextEditingController clubNameController = TextEditingController();
  File? profileImage;
  var playerIsMinor = false.obs;
  String? selectedCountry;
  int? playerAge;

  // Method to toggle selected relation
  void updateSelectedRelation(String value) {
    selectedRelation = value;
    update(); // Trigger UI update using GetBuilder
  }

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update(); // Trigger UI update using GetBuilder
  }

  // Method to mark check box
  void termConditionsChecked(bool value) {
    isTermConditionsChecked = !isTermConditionsChecked;
    update();
  }

  // Method to mark isSubscribe check box
  void isSubscribeChecked(bool value) {
    isSubscribe = !isSubscribe;
    update();
  }

  String getRoleText() {
    switch (Utils.userRole) {
      case "player":
        return "Join our team by registering as a player";
      case "scout":
        return "Join our team by registering as a club scout";
      case "agent":
        return "Join our team by registering as a agent";
      case "club":
        return "Join our team by registering as a club / academy.";
      default:
        return "Join our team";
    }
  }

  // Age calculation helper
  int calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  void resetFields() {
    // Clear all text controllers
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    contactController.clear();
    dobController.clear();
    discountController.clear();
    currentTeamController.clear();
    countryNameController.clear();
    parentFirstNameController.clear();
    parentLastNameController.clear();
    parentEmailController.clear();
    parentContactController.clear();
    clubNameController.clear();

    // Reset image and selections
    profileImage = null;
    selectedRelation = null;

    // Reset booleans
    isPasswordVisible = false;
    isTermConditionsChecked = false;
    isSubscribe = false;
    playerIsMinor.value = false;

    // Trigger UI update
    update();
  }

  /// Register user with avatar using multipart
  Future<void> registerWithClubAcademy(BuildContext context) async {
    String? selectedUserRole = state.getRole();
    String? currentLang = state.getLanguage();

    if (kDebugMode) {
      print("Selected User Role: $selectedUserRole");
    }

    // if (profileImage == null) {
    //   errorToast("Please select an avatar image");
    //   return;
    // }
    if (!isTermConditionsChecked) {
      errorToast("Please accept Terms & Conditions".tr);
      return;
    }


    final Map<String, String> fields = {
      'role': selectedUserRole,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone': contactController.text,
      'dob': dobController.text,
      'club': clubNameController.text,
      'termsAndConditions': isTermConditionsChecked.toString(),
      'isSubscribeNewsLetter': isSubscribe.toString(),
      'deviceType': "mobile"
    };

    try {
      LoaderDialog.show(context);
      var uri = Uri.parse('${Utils.baseUrl}auth/register');
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll(fields);

      if(profileImage != null){

        String filename = profileImage!.path.split('/').last;
        String extension = filename.split('.').last.toLowerCase();

        String mimeSubtype;
        if (extension == 'png') {
          mimeSubtype = 'png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeSubtype = 'jpeg';
        } else {
          mimeSubtype = extension.isNotEmpty ? extension : 'jpeg';
        }

        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          profileImage!.path,
          filename: profileImage!.path.split('/').last,
          contentType: http.MediaType("image", mimeSubtype)
        ));
      }


      /// ------------------ ADD HEADERS ------------------
      request.headers.addAll({
        "lang": currentLang,          // <-- language
        "Accept": "application/json",
      });
      if (kDebugMode) {
        print('club scout academy>> $fields');
      }
      if (kDebugMode) {
        print('HEADERS>> ${request.headers}');
      }
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoaderDialog.hide(context);
        final authModel = AuthModel.fromJson(jsonDecode(response.body));

        successToast(authModel.responseMessage ?? "Success");
        //successToast(authModel.data?.otp ?? "Success");
        //resetFields();
        update();
        Get.toNamed(AppRouter.verificationScreen,arguments:[emailController.text.trim(),"register"],);
      } else {
        LoaderDialog.hide(context);

        final authModel = AuthModel.fromJson(jsonDecode(response.body));
        errorToast(authModel.responseMessage ?? "Something went wrong");
      }
    } catch (e) {
      LoaderDialog.hide(context);

      print("🔥 Registration Error: $e");
      errorToast("Registration failed. Try again.");
    }
  }



  Future<void> registerClubScout(BuildContext context) async {
    String? selectedUserRole = state.getRole();
    String? currentLang = state.getLanguage();
    // if (profileImage == null) {
    //   errorToast("Please select an avatar image");
    //   return;
    // }
    if (!isTermConditionsChecked) {
      errorToast("Please accept Terms & Conditions".tr);
      return;
    }

    final Map<String, String> fields = {
      'role': selectedUserRole,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone': contactController.text,
      'dob': dobController.text,
      'referredByAnotherUserCode': discountController.text,
      'currentTeam': currentTeamController.text,
      'county': countryNameController.text,
      'club': clubNameController.text,
      'termsAndConditions': isTermConditionsChecked.toString(),
      'isSubscribeNewsLetter': isSubscribe.toString(),
      'deviceType': "mobile"
    };

    try {
      LoaderDialog.show(context);

      var uri = Uri.parse('${Utils.baseUrl}auth/register');
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll(fields);

      if(profileImage != null){

        String filename = profileImage!.path.split('/').last;
        String extension = filename.split('.').last.toLowerCase();

        String mimeSubtype;
        if (extension == 'png') {
          mimeSubtype = 'png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeSubtype = 'jpeg';
        } else {
          mimeSubtype = extension.isNotEmpty ? extension : 'jpeg';
        }

        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          profileImage!.path,
          filename: profileImage!.path.split('/').last,
          contentType: http.MediaType("image", mimeSubtype)
        ));
      }


      request.headers.addAll({
        "lang": currentLang,          // <-- language
        "Accept": "application/json",
      });
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);



      LoaderDialog.hide(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authModel = AuthModel.fromJson(jsonDecode(response.body));
        successToast(authModel.responseMessage ?? "Success");
        //successToast(authModel.data?.otp ?? "Success");

        //resetFields();
        update();
        Get.toNamed(AppRouter.verificationScreen,arguments:[emailController.text.trim(),"register"],);
      } else {
        final authModel = AuthModel.fromJson(jsonDecode(response.body));
        errorToast(authModel.responseMessage ?? "Something went wrong");
      }
    } catch (e) {
      LoaderDialog.hide(context);
      errorToast("Registration failed. Try again.");
    }
  }




  Future<void> registerAgent(BuildContext context) async {
    String? selectedUserRole = state.getRole();
    String? currentLang = state.getLanguage();
    // if (profileImage == null) {
    //   errorToast("Please select an avatar image");
    //   return;
    // }
    if (!isTermConditionsChecked) {
      errorToast("Please accept Terms & Conditions".tr);
      return;
    }

    final Map<String, String> fields = {
      'role': selectedUserRole,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone': contactController.text,
      'dob': dobController.text,
      'termsAndConditions': isTermConditionsChecked.toString(),
      'isSubscribeNewsLetter': isSubscribe.toString(),
      'deviceType': "mobile"
    };

    try {
      LoaderDialog.show(context);

      var uri = Uri.parse('${Utils.baseUrl}auth/register');
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll(fields);
      print('agent fields>> $fields');

      if(profileImage != null){

        String filename = profileImage!.path.split('/').last;
        String extension = filename.split('.').last.toLowerCase();

        String mimeSubtype;
        if (extension == 'png') {
          mimeSubtype = 'png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeSubtype = 'jpeg';
        } else {
          mimeSubtype = extension.isNotEmpty ? extension : 'jpeg';
        }

        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          profileImage!.path,
          filename: profileImage!.path.split('/').last,
          contentType: http.MediaType("image", mimeSubtype)
        ));
      }

      request.headers.addAll({
        "lang": currentLang,          // <-- language
        "Accept": "application/json",
      });
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      LoaderDialog.hide(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authModel = AuthModel.fromJson(jsonDecode(response.body));
        successToast(authModel.responseMessage ?? "Success");
        //successToast(authModel.data?.otp ?? "Success");

        //resetFields();
        update();

        Get.toNamed(AppRouter.verificationScreen,arguments:[emailController.text.trim(),"register"],);
      } else {
        final authModel = AuthModel.fromJson(jsonDecode(response.body));
        errorToast(authModel.responseMessage ?? "Something went wrong");
      }
    } catch (e) {
      LoaderDialog.hide(context);
      print("🔥 ClubScout Registration Error: $e");
      errorToast("Registration failed. Try again.");
    }
  }



  Future<void> registerWithPlayer(BuildContext context) async {

    String? selectedUserRole = state.getRole();
    String? currentLang = state.getLanguage();
    // if (profileImage == null) {
    //   errorToast("Please select an avatar image");
    //   return;
    // }
    if (!isTermConditionsChecked) {
      errorToast("Please accept Terms & Conditions".tr);
      return;
    }

    final Map<String, String> fields = {
      'role': selectedUserRole,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone': contactController.text,
      'dob': dobController.text,
      'referredByAnotherUserCode': discountController.text,
      'currentTeam': currentTeamController.text,
      'playerAge': playerAge.toString(),
      'parentFirstName': parentFirstNameController.text,
      'parentLastName': parentLastNameController.text,
      'parentEmail': parentEmailController.text,
      'parentPhone': parentContactController.text,
      'parentRelation': selectedRelation??"",
      'termsAndConditions': isTermConditionsChecked.toString(),
      'isSubscribeNewsLetter': isSubscribe.toString(),
      'deviceType': "mobile"
    };

    try {
      LoaderDialog.show(context);

      var uri = Uri.parse('${Utils.baseUrl}auth/register');
      var request = http.MultipartRequest('POST', uri);

      // Add form fields
      request.fields.addAll(fields);

      // Add avatar file

      if(profileImage != null){

        String filename = profileImage!.path.split('/').last;
        String extension = filename.split('.').last.toLowerCase();

        String mimeSubtype;
        if (extension == 'png') {
          mimeSubtype = 'png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          mimeSubtype = 'jpeg';
        } else {
          mimeSubtype = extension.isNotEmpty ? extension : 'jpeg';
        }

        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          profileImage!.path,
          filename: profileImage!.path.split('/').last,
          contentType: http.MediaType("image", mimeSubtype)
        ));
      }


      request.headers.addAll({
        "lang": currentLang,          // <-- language
        "Accept": "application/json",
      });


      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      LoaderDialog.hide(context);


      if (response.statusCode == 200 || response.statusCode == 201) {
        final authModel = AuthModel.fromJson(jsonDecode(response.body));
        successToast(authModel.responseMessage ?? "Registration Successful");
        //successToast(authModel.data?.otp ?? "Success");

        //resetFields();
        update();
        Get.toNamed(AppRouter.verificationScreen,arguments:[emailController.text.trim(),"register"],);
      } else {
        final authModel = AuthModel.fromJson(jsonDecode(response.body));
        errorToast(authModel.responseMessage ?? "Registration failed");
      }
    } catch (e) {
      LoaderDialog.hide(context);
      errorToast("Registration failed. Try again.");
    }
  }


  /// Returns API role string based on selected user role
  String getApiRole(String? selectedUserRole) {
    if (selectedUserRole == null || selectedUserRole.isEmpty) return '';

    switch (selectedUserRole) {
      case "Club / Academy":
        return "club";
      case "Club Scout":
        return "scout";
        case "Agent":
        return "agent";
        case "Player":
        return "player";
      default:
        return selectedUserRole;
    }
  }

}
