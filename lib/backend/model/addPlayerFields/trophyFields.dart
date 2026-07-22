import 'dart:io';
import 'package:flutter/material.dart';

class TrophyFields {
  final TextEditingController trophyNameController;
  final TextEditingController trophyYearController;
  File? trophyImage; // Image in bytes (nullable)
  String? trophyImageFileName;

  TrophyFields({
    required this.trophyNameController,
    required this.trophyYearController,
    this.trophyImage,
    this.trophyImageFileName,
  });

  TrophyFields copyWith({
    TextEditingController? trophyNameController,
    TextEditingController? trophyYearController,
    File? trophyImage,
    String? trophyImageFileName,
  }) {
    return TrophyFields(
      trophyNameController: trophyNameController ?? this.trophyNameController,
      trophyYearController: trophyYearController ?? this.trophyYearController,
      trophyImage: trophyImage ?? this.trophyImage,
      trophyImageFileName: trophyImageFileName ?? this.trophyImageFileName,

    );
  }
}
