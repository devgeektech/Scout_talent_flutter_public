import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/model/addPlayerFields/ratingRequest.dart';
import 'package:scouttalent2/backend/model/getPlayerRating.dart';

import '../../utils/api_exception.dart';
import '../../utils/toast.dart';
import '../../widget/commomLoader.dart';
import 'rate_player_state.dart';

class RatePlayerLogic extends GetxController {
  final RatePlayerState state;
  RatePlayerLogic({required this.state});

  String playerId ='';
  bool? isRated;

  // Technical
  double shootingSlider = 0;
  double passingSlider = 0;
  double dribblingSlider = 0;
  double ballControlSlider = 0;

  // Physical
  double speedSlider = 0;
  double strengthSlider = 0;
  double staminaSlider = 0;
  double agilitySlider = 0;

  // Defensive / Offensive
  double tacklingSlider = 0;
  double positioningSlider = 0;
  double visionSlider = 0;
  double offTheBallSlider = 0;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    playerId = Get.arguments[0];
    isRated = Get.arguments[1];
    if (kDebugMode) {
      print("playerId----->$playerId");
    }
    if(isRated == true){
      Future.delayed(Duration.zero, () {
        getPlayerRatingApi(Get.context!);
      });
    }
  }


  RatingRequest ratingRequest = RatingRequest();
  Future<void> ratePlayerApi(BuildContext context) async {
    try {
      LoaderDialog.show(context);
      ratingRequest = RatingRequest(
        shooting: shootingSlider.toInt(),
        passing: passingSlider.toInt(),
        dribbling: dribblingSlider.toInt(),
        ballControl: ballControlSlider.toInt(),
        speed: speedSlider.toInt(),
        strength: strengthSlider.toInt(),
        stamina: staminaSlider.toInt(),
        agility: agilitySlider.toInt(),
        tackling: tacklingSlider.toInt(),
        positioning: positioningSlider.toInt(),
        vision: visionSlider.toInt(),
        offBallMovement: offTheBallSlider.toInt(),
      );
      var response = await state.playerRatingState(ratingRequest.toJson(),playerId);
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

  GetPlayerRating getPlayerRating = GetPlayerRating();
  Future<GetPlayerRating?> getPlayerRatingApi(BuildContext context) async {
    try {
      LoaderDialog.show(context);
      await Future.delayed(Duration(milliseconds: 50));
      final response = await state.getPlayerRating(playerId);
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        getPlayerRating = GetPlayerRating.fromJson(data);
        if(getPlayerRating.responseCode == 200){
          _setSlidersFromApi(getPlayerRating.data!);
          update(); // 🔥 refresh GetBuilder UI
          LoaderDialog.hide(context);
          print("getPlayerRating---->${getPlayerRating.toString()}");
        }
        return getPlayerRating;
      } else {
        LoaderDialog.hide(context);
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("Error fetching player rating: $e");
      return null;
    }
  }

  void _setSlidersFromApi(Data data) {
    // Technical
    shootingSlider = (data.shooting ?? 50).toDouble();
    passingSlider = (data.passing ?? 50).toDouble();
    dribblingSlider = (data.dribbling ?? 50).toDouble();
    ballControlSlider = (data.ballControl ?? 50).toDouble();

    // Physical
    speedSlider = (data.speed ?? 50).toDouble();
    strengthSlider = (data.strength ?? 50).toDouble();
    staminaSlider = (data.stamina ?? 50).toDouble();
    agilitySlider = (data.agility ?? 50).toDouble();

    // Defensive / Offensive
    tacklingSlider = (data.tackling ?? 50).toDouble();
    positioningSlider = (data.positioning ?? 50).toDouble();
    visionSlider = (data.vision ?? 50).toDouble();
    offTheBallSlider = (data.offBallMovement ?? 50).toDouble();
  }

}
