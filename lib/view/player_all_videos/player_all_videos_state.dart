import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class PlayerAllVideosState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;

PlayerAllVideosState({required this.apiService, required this.sharedPreferencesManager});

int limits = 10;
latestVideos(int page,String playerId) async {
  return await apiService.getApiWithHeader("videos/byPlayer/$playerId?limit=$limits&page=$page");
}
}
