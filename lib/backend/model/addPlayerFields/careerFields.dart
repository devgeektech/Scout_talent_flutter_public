import 'package:flutter/material.dart';

class CareerFields {
  final TextEditingController careerSeasonController;
  final TextEditingController careerClubController;
  final TextEditingController careerMatchesController;
  final TextEditingController careerGoalsController;
  final TextEditingController careerMinutesController;
  final TextEditingController careerAssistsController;

  CareerFields({
    required this.careerSeasonController,
    required this.careerClubController,
    required this.careerMatchesController,
    required this.careerGoalsController,
    required this.careerMinutesController,
    required this.careerAssistsController,
  });

  CareerFields copyWith({
    TextEditingController? careerSeasonController,
    TextEditingController? careerClubController,
    TextEditingController? careerMatchesController,
    TextEditingController? careerGoalsController,
    TextEditingController? careerMinutesController,
    TextEditingController? careerAssistsController,
  }) {
    return CareerFields(
      careerSeasonController: careerSeasonController ?? this.careerSeasonController,
      careerClubController: careerClubController ?? this.careerClubController,
      careerMatchesController: careerMatchesController ?? this.careerMatchesController,
      careerGoalsController: careerGoalsController ?? this.careerGoalsController,
      careerMinutesController: careerMinutesController ?? this.careerMinutesController,
      careerAssistsController: careerAssistsController ?? this.careerAssistsController,
    );
  }
}
