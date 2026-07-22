import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';

class RatePlayerState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
RatePlayerState({required this.sharedPreferencesManager,required this.apiService});


playerRatingState(dynamic body,String playerId) async {
  return await apiService.postApiWithBody("$ratingPlayer/$playerId",body: body);
}

getPlayerRating(String playerId) async {
  return await apiService.getApiWithHeader(
    "$ratingPlayer/$playerId",
  );
}
}
