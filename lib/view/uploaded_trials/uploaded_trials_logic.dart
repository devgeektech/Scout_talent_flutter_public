import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/model/uploadedTrialsList.dart';
import 'package:scouttalent2/backend/model/uploadedTrialsList.dart' as trials;
import '../../utils/app_assets.dart';
import '../../utils/paginationHelper.dart';
import '../../utils/toast.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commonDialog.dart';
import 'uploaded_trials_state.dart';

class UploadedTrialsLogic extends GetxController {
  final UploadedTrialsState state;
  UploadedTrialsLogic({required this.state});

 String trialId = "";
  var trialVideosList = <trials.Data>[].obs;

  //Pagination
  int currentPage = 1;
  int limit = 10;
  int totalCount = 0;
  bool isLoadingMore = false;
  final ScrollController scrollController = ScrollController();

 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    trialId = Get.arguments;
    resetPagination();
    Future.delayed(Duration.zero, () {
      getUploadedTrialsVideos(Get.context!,currentPage: currentPage,limit: limit );
    });
    scrollController.addListener(() {
      scrollListener(Get.context!);
    });
  }


  UploadedTrialsListResponse uploadedTrialsListResponse = UploadedTrialsListResponse();
  Future<UploadedTrialsListResponse?> getUploadedTrialsVideos(
      BuildContext context,
      {int? currentPage,
       int? limit,
       String ?searchText
      }) async {
    try {
      if (currentPage == 1) {
        LoaderDialog.show(context);
      }
      await Future.delayed(Duration(milliseconds: 50));
      final response = await state.getUploadedVideosToTrials(trialId,page: currentPage,limit: limit,search: searchText);
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        uploadedTrialsListResponse = UploadedTrialsListResponse.fromJson(data);

        if(uploadedTrialsListResponse.responseCode == 200){
          if (currentPage == 1) {
            trialVideosList.value = uploadedTrialsListResponse.data!;
          } else {
            trialVideosList.addAll(uploadedTrialsListResponse.data!);
          }
          totalCount = uploadedTrialsListResponse.totalRecord!;
          update();

          if (currentPage == 1) {
            LoaderDialog.hide(context);
          }
        }
        return uploadedTrialsListResponse;
      } else {
        LoaderDialog.hide(context);
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("Error fetching uploaded videos to trial: $e");
      return null;
    }
  }

  //scroll listener for pagination
  void scrollListener(BuildContext context) {
    PaginationHelper.handleScroll(
      controller: scrollController,
      limit: limit,
      currentPage: currentPage,
      totalCount: totalCount,
      isLoading: isLoadingMore,
      fetchData: (page) async {
        await getUploadedTrialsVideos(context,limit: limit,currentPage: page);
      },
      onUpdateState: (page, loading) {
        currentPage = page;
        isLoadingMore = loading;
        update();
      },
    );
  }
  void resetPagination() {
    currentPage = 1;
    totalCount = 0;
    isLoadingMore = false;
    trialVideosList.clear();
  }

  Future<void> deletePlayerVideo(String id,int index, BuildContext context) async {
    LoaderDialog.show(context);
    final response = await state.deletePlayersVideo(trialId: id);
    LoaderDialog.hide(context);
    if (response != null && response.statusCode == 200) {
      // Remove from local list immediately
      trialVideosList.removeAt(index);
      // refresh UI instantly
      update();

      //Show success dialog
      showCommonDialog(
        showCloseButton: true,
        context: Get.context!,
        title: "Successfully Deleted !",
        message: "Trial deleted successfully.!",
        svgAsset: AssetPath.successFilled,
      );
    } else {
      errorToast("Failed to delete player");
    }
  }
}
