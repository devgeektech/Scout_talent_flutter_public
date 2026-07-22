import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class SavedPlayerState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;
  SavedPlayerState({required this.sharedPreferencesManager, required this.apiService});


  int limits = 10;


  fetchingSavedPlayList(int page) async {
    return await apiService.getApiWithHeader("scouting/savedPlayers?limit=$limits&page=$page");
  }

  clearSaved() async {
    return await apiService.patchApiWithoutBody("scouting/savedPlayersList/clear");
  }

}
