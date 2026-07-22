
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/view/player_trials/player_trials_state.dart';

import '../../backend/api/get_repo.dart';
import '../../backend/model/add_player_video_model.dart';
import '../../backend/model/all_trials_model.dart';
import '../../backend/model/player_trial_detiail_model.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';


class PlayerTrialsLogic extends GetxController {
  final PlayerTrialState state;
  PlayerTrialsLogic({required this.state});

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }
  void _scrollListener() {
    if (!hasMoreData || isLoadingMore || isSearching.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 120) {
      loadMore();
    }
  }

  void loadMore() {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;
    currentPage++;

    getAllTrialsApiPlayer(
      Get.context!,
      currentPage: currentPage,
      limit: limit,
      searchText: searchText.value,
    );
  }


  RxList<AllTrialList> trialsList = <AllTrialList>[].obs;
  AllTrialsModel allTrialsModel = AllTrialsModel();
  final ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  bool hasMoreData = true;
  RxBool isSearching = false.obs;
  RxString searchText = ''.obs;
  int currentPage = 1;
  final int limit = 10;
  RxBool isLoading = true.obs; // initially true



  Future<void> smartRefresh(BuildContext context) async {
    currentPage = 1;
    hasMoreData = true;

    final response = await getAllTrialsApiPlayer(
      context,
      currentPage: 1,
      limit: limit,
    );

    final freshList = response?.data ?? [];

    if (freshList.isEmpty) return;

    final oldIds = trialsList.map((e) => e.id).toSet();
    final newItems = freshList.where((e) => !oldIds.contains(e.id)).toList();

    if (newItems.isNotEmpty) {
      trialsList.insertAll(0, newItems);
    }
  }
  Future<AllTrialsModel?> getAllTrialsApiPlayer(
      BuildContext context, {
        int? currentPage,
        int? limit,
        String? searchText,
      }) async {
    try {
      // 🔹 Show loader only on first page
      if (currentPage == 1) {
        isLoading.value = true; // for UI
        LoaderDialog.show(context);
      } else {
        isLoadingMore = true; // for pagination loader
      }

      await Future.delayed(const Duration(milliseconds: 50));

      final token = state.getoken();
      final lang = state.getLanguage();

      final endpoint =
          '${Utils.baseUrl}trial/list?limit=$limit&page=$currentPage&search=${searchText ?? ""}';

      final response = await getDataWithHeader(endpoint);
      debugPrint("All data received: $response");

      if (response == null) {
        return null;
      }

      dynamic data = response.data;

      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {
          debugPrint("JSON decode failed");
        }
      }

      allTrialsModel = AllTrialsModel.fromJson(data);

      if (allTrialsModel.responseCode == 200) {
        final newData = allTrialsModel.data ?? [];

        if (currentPage == 1) {
          trialsList.assignAll(newData);
          hasMoreData = newData.length >= limit!;
        } else {
          if (newData.length < limit!) {
            hasMoreData = false;
          } else {
            trialsList.addAll(newData);
          }
        }

        update();
      }

      return allTrialsModel;
    } catch (e) {
      debugPrint("Error fetching trials: $e");
      return null;
    } finally {
      // ✅ Always reset loading flags
      isLoading.value = false;
      isLoadingMore = false;
      if (currentPage == 1) LoaderDialog.hide(context);
    }
  }

  Timer? _searchDebounce;

  void onSearchChanged(String value, BuildContext context) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final query = value.trim();

      searchText.value = query;
      isSearching.value = query.isNotEmpty;

      currentPage = 1;
      hasMoreData = true;
      trialsList.clear();

      getAllTrialsApiPlayer(
        context,
        currentPage: currentPage,
        limit: limit,
        searchText: query,
      );
    });
  }



  final Rx<PlayerTrialDetail?> trailDetail = Rx<PlayerTrialDetail?>(null);

  Future<PlayerTrialDetail?> getTrialDetail(String id) async {
    BuildContext? context = Get.context; // 🔹 Safe context from GetX

    try {
      if (context != null) LoaderDialog.show(context);

      final playerId = state.getPlayerid();

      final url = "player-trial/details/$id";

      final response = await state.apiService.getApiWithHeader(
        url,
        showToast: true,
      );

      if (context != null) LoaderDialog.hide(context);

      if (response == null) {
        debugPrint("No response received");
        return null;
      }

      int statusCode = response.statusCode ?? 0;
      dynamic data = response.data;

      // 🔹 SUCCESS (200–299)
      if (statusCode >= 200 && statusCode < 300) {
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (e) {
            debugPrint("JSON decode failed");
          }
        }

        final model = PlayerTrialDetail.fromJson(data);
        // debugPrint("Trial by detail response>> ${model.data}");

        trailDetail.value = model;

        return model;
      }

      // 🔹 ERROR HANDLING
      if (statusCode == 400) debugPrint("400 Bad Request");
      if (statusCode == 401) debugPrint("401 Unauthorized");
      if (statusCode == 403) debugPrint("403 Forbidden");
      if (statusCode == 404) debugPrint("404 Not Found");
      if (statusCode >= 500) debugPrint("Server Error $statusCode");

      return null;
    } catch (e) {
      debugPrint("Error: $e");

      // 🔹 Always hide loader even if exception occurs
      if (context != null) LoaderDialog.hide(context);

      return null;
    }
  }


  final RxMap<int, File> selectedDrillVideos = <int, File>{}.obs;


  Future<void> uploadSelectedDrill({
    required String trialId,
    required BuildContext context,
  }) async {
    if (selectedDrillVideos.isEmpty) {
      debugPrint("No videos selected");
      return;
    }

    try {
      // ✅ Show loader
      LoaderDialog.show(context);

      final response = await state.addClubPlayerDrillVideo(
        fields: {"trialId": trialId, },
        files: _buildMultipartFiles(),
      );

      if (response == null) {
        debugPrint("Upload failed: no response");
        errorToast("Upload failed. Please try again.");
        return;
      }

      /// Parse response safely
      final model = AddPlayerVideoModel.fromJson(response.data);
      if (kDebugMode) {
        print("The add  player videos model: $model");
      }

      if (model.responseCode == 200) {
        successToast(model.responseMessage ?? "Video uploaded successfully");
        LoaderDialog.hide(context);

        // ✅ Clear local selection
        selectedDrillVideos.clear();

        // ✅ Refresh uploaded drills
        // await getUploadedTrialRes(trialId, playerId);
      } else {
        LoaderDialog.hide(context);

        errorToast(model.responseMessage ?? "Upload failed");
        debugPrint("Upload failed: ${model.responseCode}");
      }
    } catch (e, st) {
      debugPrint("Upload error: $e");
      debugPrint(st.toString());
      errorToast("Something went wrong while uploading");
    } finally {
      // ✅ Hide loader
      LoaderDialog.hide(context);
    }
  }
  /// convert index → multipart format
  Map<String, File> _buildMultipartFiles() {
    final Map<String, File> files = {};

    selectedDrillVideos.forEach((index, file) {
      final key = _drillKeyFromIndex(index);
      files[key] = file; // ✅ correct backend key
    });

    return files;
  }

  String _drillKeyFromIndex(int index) {
    switch (index) {
      case 0:
        return "drillOneVideo";
      case 1:
        return "drillTwoVideo";
      case 2:
        return "drillThreeVideo";
      case 3:
        return "drillFourVideo";
      default:
        throw Exception("Invalid drill index: $index");
    }
  }

}
