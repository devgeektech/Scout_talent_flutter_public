import 'dart:io';

import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';

import '../../utils/string.dart';

class PlayerTrialState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;
  PlayerTrialState({required this.sharedPreferencesManager,required this.apiService});

  String getLanguage() {
    return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
  }
  String getRole() {
    return sharedPreferencesManager.getString('selectedUserRole') ?? '';
  }

  String getoken() {
    return sharedPreferencesManager.getString(AppString.authToken) ?? '';
  }

  String getPlayerid() {
    return sharedPreferencesManager.getString(AppString.uid) ?? '';
  }

  getClubPlayers({int? limit, int? page, String? search}) async {
    final searchQuery = search != null && search.isNotEmpty
        ? "&search=$search"
        : "";
    return await apiService.getApiWithHeader(
      "$clubPlayers?limit=$limit&page=$page$searchQuery",
    );
  }



  getClubPlayersUploaded({String? trialId, String? playerId}) async {
    return await apiService.getApiWithHeader(
      "trial/uploadedVideos?trialId=$trialId&playerId=$playerId",
    );
  }


  Future<dynamic> addClubPlayerDrillVideo(
      {required Map<String, dynamic> fields,
        required Map<String, File> files,}) async {
    return await apiService.postMultipartApi(
      PlayerDrillUploadVideo,
      fields: fields,
      files: files,
    );
  }

}
