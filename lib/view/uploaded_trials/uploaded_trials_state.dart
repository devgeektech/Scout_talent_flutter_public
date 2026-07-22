import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';

class UploadedTrialsState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
UploadedTrialsState({required this.sharedPreferencesManager,required this.apiService});

getUploadedVideosToTrials(String trialId,{int? limit, int? page, String? search}) async {
  final searchQuery = search != null && search.isNotEmpty ? "&search=$search" : "";
  return await apiService.getApiWithHeader(
    "$uploadedTrials?trialId=$trialId&limit=$limit&page=$page$searchQuery",
  );
}
deletePlayersVideo({String? trialId}) async {
  return await apiService.deleteApiWithoutBody("$playerTrialVideos/$trialId");
}

}
