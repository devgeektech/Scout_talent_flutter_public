import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/model/uploaded_video_listing_model.dart';
import 'package:scouttalent2/utils/toast.dart';
import '../../backend/model/CommonResponseCodeAndMessageModel.dart';
import '../../backend/model/edit_sheet_model.dart';
import '../../backend/model/getClubPlayerList.dart';
import '../../backend/model/player_module_model.dart';
import '../../backend/model/update_video_model.dart' hide Data;
import '../../backend/model/upload_video_model.dart' hide Data;
import '../../utils/app_assets.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commonDialog.dart';
import 'uploaded_video_state.dart';
import 'package:http/http.dart' as http;
import 'package:scouttalent2/backend/model/getClubPlayerList.dart' as player;

class UploadedVideoLogic extends GetxController {
  final UploadedVideoState state;

  UploadedVideoLogic({required this.state});

  // String? selectedPlayer;
  // Method to toggle selected relation
  final formKey = GlobalKey<FormState>();

  // Reactive variables for dropdowns
  var selectedPlayer = RxnString();
  var selectedVisibility = RxnString();
  var selectedPlayerId = ''.obs;

  // Dropdown error messages
  var selectedPlayerError = ''.obs;
  var selectedVisibilityError = ''.obs;

  int currentPage = 1;
  int limit = 10;
  num totalCount = 0;
  bool isLoadingMore = false;

  final ScrollController scrollController = ScrollController();

  // Text controllers for title & description
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  void onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        (videosListRes.value?.data?.length ?? 0) < totalCount) {
      isLoadingMore = true;
      currentPage++;

      getAllVideos(page: currentPage, limit: limit, search: searchText).then((_) {
        isLoadingMore = false;
        update();
      });
      getClubPlayersApi(limit: limit, currentPage: currentPage, searchText: searchText);
    }
  }

  Timer? _searchDebounce;

  void onSearchChanged(String value) {
    // Cancel previous timer
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce!.cancel();
    }

    _searchDebounce = Timer(
      const Duration(milliseconds: 400), // debounce time
      () {
        searchText = value;
        currentPage = 1;
        totalCount = 0;
        videosListRes.value?.data?.clear();

        getAllVideos(page: 1, limit: limit, search: value);
      },
    );
  }

  void updateSelectedPlayer(ClubPlayers player) {
    selectedPlayerId.value = player.sId ?? '';
    selectedPlayerError.value = ''; // Clear error
  }

  void updateSelectedVisibility(String value) {
    selectedVisibilityError.value = ''; // Clear error

    selectedVisibility.value = value;
  }

  void submitWithValidation(Function(EditSheetResult) onSubmit) {
    bool valid = true;

    // Check dropdowns
    if (selectedPlayer.value == null) {
      selectedPlayerError.value = 'Please select a player';
      valid = false;
    }

    if (selectedVisibility.value == null) {
      selectedVisibilityError.value = 'Please select visibility';
      valid = false;
    }

    // Check text fields
    if (formKey.currentState?.validate() == false) valid = false;

    if (valid) {
      onSubmit(
        EditSheetResult(
          title: titleController.text,
          description: descriptionController.text,
          player: selectedPlayer.value,
          visibility: selectedVisibility.value,
        ),
      );
    }
  }

  // Submit
  void submit(Function(EditSheetResult) onSubmit) {
    final result = EditSheetResult(
      title: titleController.text,
      description: descriptionController.text,
      player: selectedPlayer.value,
      //visibility: selectedVisibility.value,
      visibility: selectedVisibility.value,
    );
    onSubmit(result);
  }

  /// Upload video with loader
  Future<UploadVideoModel?> uploadVideo({required String videoFilePath}) async {
    try {
      final token = state.getoken();
      final role = state.getRole();
      final lang = state.getLanguage();

      var headers = {'lang': lang, 'Authorization': token};

      var uri = Uri.parse('${Utils.baseUrl}videos');

      var request = http.MultipartRequest('POST', uri);

      if (state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer) {
        request.fields.addAll({'role': role, 'title': titleController.text, 'description': descriptionController.text});
      } else {
        request.fields.addAll({
          'role': role,
          'title': titleController.text,
          'description': descriptionController.text,
          'player': selectedPlayerId.value ?? '',
          'privacy': selectedVisibility.value ?? 'Public',
        });
      }

      request.files.add(await http.MultipartFile.fromPath('video', videoFilePath));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final respStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(respStr);
      final uploadModel = UploadVideoModel.fromJson(jsonResponse);

      if (response.statusCode == 200) {
        // successToast(uploadModel.responseMessage ?? "");
        // ✅ Clear fields after successful upload
        titleController.clear();
        descriptionController.clear();
        selectedPlayer.value = null;
        selectedPlayerId.value = '';
        selectedVisibility.value = null;
        update();
        return uploadModel;
      } else {
        errorToast(uploadModel.responseMessage ?? "");
        print("Upload Failed: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      // ✅ Ensure loader is hidden even if an exception occurs
      errorToast("Upload failed: $e");
      return null;
    }
  }

  final Rx<UploadedVideoListingModel?> videosListRes = Rx<UploadedVideoListingModel?>(null);

  Future<UploadedVideoListingModel?> getAllVideos({int limit = 10, int page = 1, String search = "", String searchField = "all"}) async {
    BuildContext? context = Get.context; // 🔹 Safe context from GetX

    try {
      if (context != null) LoaderDialog.show(context);

      String? role = await Utils().getUserType();

      late String url;

      final playerId = state.getPlayerid();
      if (role == "club") {
        url = "videos/clubPlayer/$playerId?limit=$limit&page=$page&searchField=$searchField&search=$search";
      } else if (role == "agent") {
        url = "videos/agentuser/$playerId?limit=$limit&page=$page&searchField=$searchField&search=$search";
      } else {
        url = "videos/player/list?limit=$limit&page=$page";
      }


      debugPrint("the get upload video url ${url}");
      // final url = "videos/clubPlayer/$playerId?limit=$limit&page=$page&searchField=$searchField&search=$search";

      final response = await state.apiService.getApiWithHeader(url, showToast: true);

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

        final model = UploadedVideoListingModel.fromJson(data);
        debugPrint("Video List: ${model.data}");

        if (page == 1) {
          videosListRes.value = model;
        } else {
          videosListRes.value?.data?.addAll(model.data ?? []);
          videosListRes.refresh();
        }

        totalCount = model.totalRecord ?? 0;
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

  Future<UpdateVideoModel?> updateVideo({required String videoId, required String playerId}) async {
    BuildContext? context = Get.context;
    try {
      if (context != null) LoaderDialog.show(context);

      final body = {'role': state.getRole(), 'title': titleController.text, 'description': descriptionController.text, 'player': playerId};

      final response = await state.apiService.putApi('videos/$videoId', data: body);

      if (context != null) LoaderDialog.hide(context);

      if (response != null && response.statusCode == 200) {
        final updateModel = UpdateVideoModel.fromJson(response.data);
        // successToast(
        //   updateModel.responseMessage ?? "Video updated successfully",
        // );

        // Optionally refresh list
        state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
            ? await getPlayerModuleList(Get.context!, currentPage: 1)
            : await getAllVideos();

        return updateModel;
      } else {
        final message = response?.data['responseMessage'] ?? "Failed to update video";
        errorToast(message);
        return null;
      }
    } catch (e) {
      if (context != null) LoaderDialog.hide(context);
      errorToast("Update failed: $e");
      print("UpdateVideo Exception: $e");
      return null;
    }
  }

  Future<void> deleteVideo(BuildContext context, String videoId) async {
    final endpoint = 'videos/$videoId';

    LoaderDialog.show(context);

    try {
      final response = await state.apiService.deleteApiWithoutBody(endpoint);

      LoaderDialog.hide(context);

      if (response != null && response.data != null) {
        final resJson = ResponseCodeAndMessageModel.fromJson(response.data!);

        if (response.statusCode == 200) {
          // successToast(resJson.responseMessage ?? 'Deleted successfully');
          showCommonDialog(
            showCloseButton: true,
            context: Get.context!,
            title: "Successfully Deleted !",
            message: "Your video was deleted successfully.",
            svgAsset: AssetPath.successFilled,
          );
          state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
              ? getPlayerModuleList(context, currentPage: 1)
              : getAllVideos();
        } else {
          errorToast(resJson.responseMessage ?? 'Something went wrong');
        }
      } else {
        errorToast('No response from server');
      }
    } catch (e) {
      LoaderDialog.hide(context);
      Get.snackbar("Exception", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  //Get players list api
  GetClubPlayersList getClubPlayersList = GetClubPlayersList();
  var playersList = <player.ClubPlayers>[].obs;

  Future<GetClubPlayersList?> getClubPlayersApi({int? currentPage, int? limit, String? searchText}) async {
    try {
      if (currentPage == 1) {}
      await Future.delayed(Duration(milliseconds: 50));
      final response = await state.getClubPlayers(page: currentPage, limit: limit, search: searchText);
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        getClubPlayersList = GetClubPlayersList.fromJson(data);

        if (getClubPlayersList.responseCode == 200) {
          playersList.value = getClubPlayersList.data!;
          // if (currentPage == 1) {
          //   playersList.value = getClubPlayersList.data!;
          // } else {
          //   playersList.addAll(getClubPlayersList.data!);
          // }
          // totalCount = getClubPlayersList.totalRecord!;
          update();
          if (currentPage == 1) {}
        }
        return getClubPlayersList;
      } else {
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching plans: $e");
      return null;
    }
  }

  // Make the whole model reactive
  var playerListModuleModel = Rx<PlayerListModuleModel?>(null);
  var playerListModule = <PlayerListModuleBody>[].obs;

  getPlayerModuleList(BuildContext context, {int? currentPage, int? limit, String? searchText}) async {
    if (context.mounted && currentPage == 1) LoaderDialog.show(context);
    await state.playerModule(page: currentPage).then((response) {
      if (context.mounted && currentPage == 1) LoaderDialog.hide(context);
      if (response != null && response.statusCode == 200) {
        if (currentPage == 1) {
          playerListModule.clear();
        }
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        playerListModuleModel.value = PlayerListModuleModel.fromJson(myMap);
        playerListModule.addAll(playerListModuleModel.value!.data!); // add new data
        update();
      } else {
        errorToast("Something went wrong");
      }
    });
  }

  bool validateUploadForm() {
    if (titleController.text.trim().isEmpty) {
      errorToast("Please enter title");
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      errorToast("Please enter description");
      return false;
    }

    if (selectedPlayerId.value.isEmpty) {
      errorToast("Please select a player");
      return false;
    }

    if (selectedVisibility.value == null || selectedVisibility.value!.isEmpty) {
      errorToast("Please select privacy");
      return false;
    }

    return true; // ✅ All good
  }

  bool validateEditForm({required bool showDropdowns}) {
    if (titleController.text.trim().isEmpty) {
      errorToast("Please enter title");
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      errorToast("Please enter description");
      return false;
    }

    // ✅ Only validate dropdowns IF they are visible
    if (showDropdowns) {
      if (selectedPlayerId.value.isEmpty) {
        errorToast("Please select a player");
        return false;
      }

      // if (selectedVisibility.value == null || selectedVisibility.value!.isEmpty) {
      //   errorToast("Please select visibility");
      //   return false;
      // }
    }

    return true;
  }
}
