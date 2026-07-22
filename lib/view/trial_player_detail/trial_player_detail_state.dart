import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';

class TrialPlayerDetailState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
TrialPlayerDetailState({required this.apiService, required this.sharedPreferencesManager});

getPlayerTrials({String? trialId,String? playerId}) async {
  return await apiService.getApiWithHeader(
    "$playerTrialVideos?trialId=$trialId&playerId=$playerId",
  );
}




Future<dynamic> updateStatus({String? trialId,String? playerId,String? status}) async {
  return await apiService.patchDataHeaders(
    "trial/updateStatus",
    data: {
      "trialId": trialId,
      "playerId": playerId,
      "status": status,
    },
  );
}



}
