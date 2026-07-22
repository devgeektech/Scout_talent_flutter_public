// utils/validators.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/utils.dart';

class Validators {
  // static bool isEmailValid(String email) {
  //   final emailRegex = RegExp(
  //       r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$'
  //   );
  //   return emailRegex.hasMatch(email);
  // }
  static bool isEmailValid(String email) {
    final regex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return regex.hasMatch(email.trim());
  }

  // static bool isEmailValid(String email) {
  //   // Step 1: Basic email format check
  //   final emailRegex = RegExp(
  //     r'^[a-zA-Z0-9]+([._-]?[a-zA-Z0-9]+)*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  //   );
  //
  //   if (!emailRegex.hasMatch(email)) return false;
  //
  //   // Step 2: Extract domain part
  //   final domain = email.split('@').last;
  //
  //   // ❌ Block domain having consecutive hyphens
  //   if (domain.contains('--')) return false;
  //
  //   // Split domain into labels (each part between dots)
  //   final labels = domain.split('.');
  //
  //   for (final label in labels) {
  //     // ❌ Label cannot start or end with hyphen (this blocks yopmail--)
  //     if (label.startsWith('-') || label.endsWith('-')) {
  //       return false;
  //     }
  //   }
  //
  //   return true;
  // }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Email Id'.tr;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email'.tr;
    }

    return null;
  }

  static bool isPasswordValid(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }
  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) return "Message is required".tr;
    if (value.length < 10) return "Message must be at least 10 characters".tr;
    return null;
  }
  static bool isPhoneValid(String phone) {
    final phoneRegex = RegExp(r'^\+?\d{10,14}$');
    return phoneRegex.hasMatch(phone.trim());
  }
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Name is required";
    if (value.length < 3) return "Name must be at least 3 characters";
    return null;
  }
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password'.tr;
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long'.tr;
    } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one capital letter'.tr;
    } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter'.tr;
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number'.tr;
    } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must contain at least one special character'.tr;
    }
    return null;
  }
}
extension SafeImage on String? {
  ImageProvider get profileImage {
    // if valid avatar → network image
    if (this != null && this!.trim().isNotEmpty) {
      return NetworkImage("${Utils.imageUrl}$this");
    }

    // fallback → dummy asset image
    return const AssetImage("assets/images/dummyPerson.png");
  }
}
