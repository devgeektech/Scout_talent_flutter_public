import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/model/CommonResponseCodeAndMessageModel.dart';
import '../../backend/model/uploadedPlayerTrialDetail.dart';
import '../../backend/model/uploadedPlayerTrialDetail.dart' as drills;
import '../../utils/toast.dart';
import '../../widget/commomLoader.dart';
import 'trial_player_detail_state.dart';

class TrialPlayerDetailLogic extends GetxController {
  final TrialPlayerDetailState state;
  TrialPlayerDetailLogic({required this.state});

  String trialId = "";
  String playerId = "";
  var drillList = <drills.Drills>[].obs;
  bool isLoading = true;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    trialId = Get.arguments[0];
    playerId = Get.arguments[1];

    if (kDebugMode) {
      print("trialId---->$trialId");
      print("playerId---->$playerId");

    }
    Future.delayed(Duration.zero, () {
      playerTrialDetailApi();
    });
  }


  UploadedPlayerTrialDetail uploadedPlayerTrialDetail = UploadedPlayerTrialDetail();
  Future<UploadedPlayerTrialDetail?> playerTrialDetailApi() async {
    try {
      isLoading = true;

      final response = await state.getPlayerTrials(trialId: trialId,playerId: playerId,);
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        uploadedPlayerTrialDetail = UploadedPlayerTrialDetail.fromJson(data);

        if(uploadedPlayerTrialDetail.responseCode == 200){
          isLoading = false;

          final allDrills = uploadedPlayerTrialDetail.data?.drills ?? [];

          // ✅ Keep only drills that have a video
          drillList.value = allDrills
              .where((drill) =>
          drill.video != null &&
              drill.video.toString().trim().isNotEmpty)
              .toList();

          update();
          if (kDebugMode) {
            print("uploadedPlayerTrialDetail ---> ${uploadedPlayerTrialDetail.data}");
            print("drillList length ---> ${drillList.length}");

          }
        }
        return uploadedPlayerTrialDetail;
      } else {
        isLoading = false;

        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      isLoading = false;

      debugPrint("Error fetching player trial detail: $e");
      return null;
    }
  }



  Future<ResponseCodeAndMessageModel?> updateStatusApi(
      BuildContext context, {
        required String status,
      }) async {
    try {
      LoaderDialog.show(context);

      final response = await state.updateStatus(
        trialId: trialId,
        playerId: playerId,
        status: status,
      );

      if (response != null) {
        dynamic data = response.data;

        // Handle string or map response
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }

        final result = ResponseCodeAndMessageModel.fromJson(data);

        LoaderDialog.hide(context);

        if (result.responseCode == 200) {
          successToast(
            result.responseMessage ?? "Status updated successfully",
          );
          await playerTrialDetailApi();
          update(); // refresh UI
        } else {
          errorToast(
            result.responseMessage ?? "Failed to update status",
          );
        }

        return result;
      } else {
        LoaderDialog.hide(context);
        errorToast("No response received from server");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("Error updating status: $e");
      errorToast("Something went wrong. Please try again.");
      return null;
    }
  }


}
